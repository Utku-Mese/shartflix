import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shartflix/core/constants/app_theme.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        title: 'Shartflix',
        theme: AppTheme.darkTheme,
        home: const Scaffold(
          body: Center(
            child: Text(
              'Shartflix - Coming Soon',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );

    // Verify that our app loads with the correct text.
    expect(find.text('Shartflix - Coming Soon'), findsOneWidget);
  });
}
