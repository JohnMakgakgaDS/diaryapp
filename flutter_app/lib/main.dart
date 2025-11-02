import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'diary_home_page.dart';

void main() {
  runApp(const DiaryApp());
}

class DiaryApp extends StatelessWidget {
  const DiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diary App',
      theme: ThemeData(primarySwatch: Colors.indigo),
      debugShowCheckedModeBanner: false,
      home: const DiaryHomePage(),  // ← added the home widget here
    );
  }
}





 

