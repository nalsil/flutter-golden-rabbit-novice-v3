// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:image_editor_v2/screen/home_screen.dart';

void main() {
  testWidgets('Image editor smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    // Verify that the image selection button is present
    expect(find.text('이미지 선택하기'), findsOneWidget);

    // Verify that the app bar icons are present
    expect(find.byIcon(Icons.image_search_outlined), findsOneWidget);
    expect(find.byIcon(Icons.delete_forever_outlined), findsOneWidget);
    expect(find.byIcon(Icons.save), findsOneWidget);
  });
}
