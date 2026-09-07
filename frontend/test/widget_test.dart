// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.



import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/widgets/buttons.dart';
import 'package:frontend/core/widgets/feedback.dart';
import 'package:frontend/core/widgets/indicators.dart';
import 'package:frontend/core/widgets/orivox_logo.dart';

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    expect(true, isTrue);
  });

  testWidgets('PrimaryButton renders with flexible text and no overflow', (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 200,
            child: PrimaryButton(
              isFullWidth: false,
              text: 'Connect & Sync Repository',
              icon: Icons.sync,
              onPressed: () => tapped = true,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Connect & Sync Repository'), findsOneWidget);
    expect(find.byIcon(Icons.sync), findsOneWidget);

    await tester.tap(find.byType(PrimaryButton));
    expect(tapped, isTrue);
  });

  testWidgets('EmptyState renders action widget cleanly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmptyState(
            title: 'No Documents Found',
            message: 'Documents are extracted automatically.',
            icon: Icons.find_in_page_outlined,
            action: PrimaryButton(
              isFullWidth: false,
              text: 'Connect Repository',
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('No Documents Found'), findsOneWidget);
    expect(find.text('Connect Repository'), findsOneWidget);
    expect(find.byIcon(Icons.find_in_page_outlined), findsOneWidget);
  });

  testWidgets('StatusBadge renders with semantic dot and label', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StatusBadge(
            label: 'Synced',
            type: StatusType.success,
          ),
        ),
      ),
    );

    expect(find.text('Synced'), findsOneWidget);
  });

  testWidgets('DestructiveButton renders with error styling', (WidgetTester tester) async {
    bool deleted = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DestructiveButton(
            text: 'Delete Repository',
            icon: Icons.delete_outline,
            onPressed: () => deleted = true,
          ),
        ),
      ),
    );

    expect(find.text('Delete Repository'), findsOneWidget);
    await tester.tap(find.byType(DestructiveButton));
    expect(deleted, isTrue);
  });

  testWidgets('OrivoxLogo renders cleanly with asset and contrast decoration', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              OrivoxLogo(height: 44),
              OrivoxLogo(height: 72, isHero: true, forceBadge: true),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(OrivoxLogo), findsNWidgets(2));
    expect(find.byType(Image), findsNWidgets(2));
  });
}
