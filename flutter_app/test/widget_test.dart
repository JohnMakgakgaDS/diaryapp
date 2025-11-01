import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/diary_home_page.dart';

void main() {
  testWidgets('Diary Home Page loads widgets', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: DiaryHomePage()));

    // Test that the AppBar exists
    expect(find.byType(AppBar), findsOneWidget);

    // Test that a ListView exists (for diary entries)
    expect(find.byType(ListView), findsOneWidget);

    // Test that a FloatingActionButton exists
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
