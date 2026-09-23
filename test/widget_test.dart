import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:py_pizza/main.dart';

void main() {
  Future<void> launch(WidgetTester tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const PyApp());
    await tester.pumpAndSettle();
  }

  Future<void> addMargherita(WidgetTester tester) async {
    await tester.tap(find.byKey(const ValueKey('nav-menu')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Classic Margherita').last);
    await tester.tap(find.text('Classic Margherita').last);
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Add to bag'));
    await tester.pumpAndSettle();
  }

  testWidgets('browse menu, add pizza, and update the bag', (tester) async {
    await launch(tester);

    expect(find.text('Your next favorite\nbite is here.'), findsOneWidget);
    await addMargherita(tester);
    await tester.tap(find.byKey(const ValueKey('nav-bag')));
    await tester.pumpAndSettle();

    expect(find.text('Your bag'), findsOneWidget);
    expect(find.text('Classic Margherita'), findsOneWidget);
    expect(find.textContaining('Place demo order'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('search narrows the visible menu', (tester) async {
    await launch(tester);

    await tester.tap(find.byKey(const ValueKey('nav-menu')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('menu-search')), 'fries');
    await tester.pumpAndSettle();

    expect(find.text('Loaded Fries'), findsOneWidget);
    expect(find.text('Pepperoni Pop'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('placing the demo order clears the bag', (tester) async {
    await launch(tester);

    await addMargherita(tester);
    await tester.tap(find.text('VIEW BAG'));
    await tester.pumpAndSettle();
    final placeOrder = find.byKey(const ValueKey('place-order'));
    await tester.ensureVisible(placeOrder);
    await tester.tap(placeOrder);
    await tester.pumpAndSettle();

    expect(find.text('Order up! 🍕'), findsOneWidget);
    expect(find.textContaining('no real order'), findsNothing);
    await tester.tap(find.text('Nice!'));
    await tester.pumpAndSettle();
    expect(find.text('Your bag is waiting.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('landscape layout remains usable without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(932, 430);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('nav-menu')));
    await tester.pumpAndSettle();

    expect(find.text('Explore the menu'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
