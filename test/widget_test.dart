import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:key_track/main.dart';
import 'package:key_track/data/repositories/key_repository.dart';

void main() {
  testWidgets('Key Handover Tracker UI smoke test', (WidgetTester tester) async {
    // Set viewport size to avoid off-screen list view items not being built
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0; // 360x800 logical pixels

    // Reset size after test
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // Initialize mock shared preferences
    SharedPreferences.setMockInitialValues({});
    await KeyRepository().init();

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that the title of the app is shown.
    expect(find.text('Key Handover Tracker'), findsOneWidget);

    // Verify that the initial keys from Repository are shown.
    expect(find.text('Meeting Room'), findsOneWidget);
    expect(find.text('Server Room'), findsOneWidget);
    expect(find.text('Store Room'), findsOneWidget);
    expect(find.text('Main Gate'), findsOneWidget);

    // Verify status badges are present (by finding "Available" texts)
    expect(find.text('Available'), findsNWidgets(4));
  });
}
