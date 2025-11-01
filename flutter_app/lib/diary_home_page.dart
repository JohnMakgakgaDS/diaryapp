import 'package:flutter/material.dart';
import 'lib.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class DiaryHomePage extends StatefulWidget {
  const DiaryHomePage({super.key});

  @override
  _DiaryHomePageState createState() => _DiaryHomePageState();
}

class _DiaryHomePageState extends State<DiaryHomePage> {
  DateTime _selectedDay = DateTime.now();
  List _entries = [];

  final String baseUrl = 'http://<your-ip>:8000/api/entries'; // change IP

  @override
  void initState() {
    super.initState();
    fetchEntries();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchEntries() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl?date=${_selectedDay.toIso8601String().split("T")[0]}'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      setState(() {
        _entries = json.decode(response.body);
      });
    }
  }

  Future<void> addEntry(String title, String type) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'date': _selectedDay.toIso8601String().split("T")[0],
        'title': title,
        'description': '',
        'type': type,
      }),
    );
    if (response.statusCode == 201) fetchEntries();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    await http.post(
      Uri.parse('http://<your-ip>:8000/api/logout'),
      headers: {'Authorization': 'Bearer $token'},
    );
    await prefs.remove('token');
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _showAddDialog() {
    String newTitle = '';
    String type = 'todo';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Entry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(onChanged: (val) => newTitle = val, decoration: const InputDecoration(labelText: 'Title')),
            DropdownButton<String>(
              value: type,
              items: const [
                DropdownMenuItem(value: 'todo', child: Text('To-Do')),
                DropdownMenuItem(value: 'event', child: Text('Event')),
              ],
              onChanged: (val) => setState(() => type = val!),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              addEntry(newTitle, type);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Diary'),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _selectedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, _) {
              setState(() => _selectedDay = selectedDay);
              fetchEntries();
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[index];
                return ListTile(
                  title: Text(entry['title']),
                  subtitle: Text(entry['type']),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
