import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DiaryHomePage extends StatefulWidget {
  const DiaryHomePage({super.key});

  @override
  _DiaryHomePageState createState() => _DiaryHomePageState();
}

class _DiaryHomePageState extends State<DiaryHomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<String, List<String>> _entries = {}; // key = yyyy-MM-dd, value = list of entries
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('diary_entries');
    if (data != null) {
      setState(() {
        _entries = Map<String, List<String>>.from(
          (jsonDecode(data) as Map).map(
            (key, value) => MapEntry(key, List<String>.from(value)),
          ),
        );
      });
    }
  }

  Future<void> _saveEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('diary_entries', jsonEncode(_entries));
  }

  List<String> _getEntriesForDay(DateTime day) {
    return _entries[day.toIso8601String().substring(0, 10)] ?? [];
  }

  void _addEntry() {
    String text = _textController.text.trim();
    if (text.isEmpty) return;

    String key = _selectedDay.toIso8601String().substring(0, 10);
    setState(() {
      if (_entries.containsKey(key)) {
        _entries[key]!.add(text);
      } else {
        _entries[key] = [text];
      }
      _textController.clear();
      _saveEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final entries = _getEntriesForDay(_selectedDay);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary Home'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(entries[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Add a diary entry',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addEntry,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEntry,
        child: const Icon(Icons.add),
      ),
    );
  }
}
