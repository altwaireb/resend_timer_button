import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resend_timer_button/resend_timer_button.dart';

void main() {
  testWidgets('Displays countdown in time format by default', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ResendTimerButton(
            onPressed: () {},
            text: const Text('Resend in'),
            duration: 60,
          ),
        ),
      ),
    );

    // 01:00 = 60 seconds
    expect(find.text('01:00'), findsOneWidget);
  });

  testWidgets('Displays countdown in number format', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ResendTimerButton(
            onPressed: () {},
            text: const Text('Resend in'),
            duration: 60,
            format: ResendTimeFormat.number,
          ),
        ),
      ),
    );

    expect(find.text('60'), findsOneWidget);
  });

  testWidgets('Button is disabled during countdown and enables after',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ResendTimerButton(
            onPressed: () {},
            text: const Text('Resend in'),
            duration: 2,
          ),
        ),
      ),
    );

    // Initial state: button disabled
    final ElevatedButton buttonBefore =
        tester.widget(find.byType(ElevatedButton));
    expect(buttonBefore.onPressed, isNull);

    // Wait for countdown to finish
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Button should now be enabled
    final ElevatedButton buttonAfter =
        tester.widget(find.byType(ElevatedButton));
    expect(buttonAfter.onPressed, isNotNull);
  });

  testWidgets('Shows loading indicator when loading triggered via controller',
      (tester) async {
    final controller = ResendTimerButtonController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ResendTimerButton(
            controller: controller,
            onPressed: () {},
            text: const Text('Resend in'),
            duration: 60,
          ),
        ),
      ),
    );

    // Manually trigger loading
    controller.loading();
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Controller can manually enable the button', (tester) async {
    final controller = ResendTimerButtonController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ResendTimerButton(
            controller: controller,
            onPressed: () {},
            text: const Text('Resend in'),
            duration: 60,
          ),
        ),
      ),
    );

    controller.enableButton();
    await tester.pump();

    final ElevatedButton button = tester.widget(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Supports text_button and outlined_button types', (tester) async {
    // Text Button
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ResendTimerButton(
            onPressed: () {},
            text: const Text('TextButton'),
            duration: 60,
            buttonType: ButtonType.text_button,
          ),
        ),
      ),
    );

    expect(find.byType(TextButton), findsOneWidget);

    // Outlined Button
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ResendTimerButton(
            onPressed: () {},
            text: const Text('OutlinedButton'),
            duration: 60,
            buttonType: ButtonType.outlined_button,
          ),
        ),
      ),
    );

    expect(find.byType(OutlinedButton), findsOneWidget);
  });

  testWidgets('Button becomes immediately enabled if duration is 0',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ResendTimerButton(
            onPressed: () {},
            text: const Text('Instant'),
            duration: 0,
          ),
        ),
      ),
    );

    await tester.pump(); // allow timer to process

    final ElevatedButton button = tester.widget(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Countdown updates every second', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ResendTimerButton(
          onPressed: () {},
          text: const Text('Resend in'),
          duration: 3,
        ),
      ),
    );

    // Initial state
    expect(find.text('00:03'), findsOneWidget);

    // After 1 second
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('00:02'), findsOneWidget);

    // After another second
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('00:01'), findsOneWidget);

    // After final second
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Resend in'), findsOneWidget);
  });
}
