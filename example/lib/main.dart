import 'package:flutter/material.dart';
import 'package:resend_timer_button/resend_timer_button.dart';

void main() {
  runApp(const ResendTimerExampleApp());
}

class ResendTimerExampleApp extends StatelessWidget {
  const ResendTimerExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resend Timer Button Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  final ResendTimerButtonController _controller = ResendTimerButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Resend Timer Button Demo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Basic Timer time format',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Elevation Button',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 12),
              ResendTimerButton(
                onPressed: () => debugPrint("Button pressed"),
                text: const Text("Resend in"),
                duration: 2,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
              ),
              const SizedBox(height: 40),
              const Text(
                'Timer with raw seconds format',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Outlined Button',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 12),
              ResendTimerButton(
                onPressed: () => debugPrint("Button pressed"),
                text: const Text("Resend in"),
                duration: 2,
                format: ResendTimeFormat.number,
                buttonType: ButtonType.outlined_button,
                textColor: Colors.deepOrange,
              ),
              const SizedBox(height: 40),
              const Text(
                'With Controller & Loading',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Text Button',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 12),
              ResendTimerButton(
                controller: _controller,
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    _controller.loading();
                    await Future.delayed(const Duration(seconds: 3));
                    _controller.startTimer();
                  });
                },
                text: const Text("Send again"),
                duration: 2,
                format: ResendTimeFormat.time,
                buttonType: ButtonType.text_button,
                textColor: Colors.teal,
                loadingIndicatorColor: Colors.teal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
