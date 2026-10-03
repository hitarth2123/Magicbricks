import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magicbricks_commercial/main.dart';

void main() {
  testWidgets('commercial app shell renders', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(const MagicbricksApp());

    expect(find.text('Customer sign in'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(0), 'customer@magicbricks.com');
    await tester.enterText(find.byType(TextField).at(1), 'customer123');
    await tester.tap(find.text('Sign in'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Space that works'), findsOneWidget);
    expect(find.text('Overview'), findsOneWidget);

    await tester.tap(find.text('Find a property'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Phoenix');
    await tester.tap(find.text('Search'));
    await tester.pump();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(find.text('1 spaces match your business needs'), findsOneWidget);

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}
