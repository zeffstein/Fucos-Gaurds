import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Fucos Guard'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _sessionTime = 25 * 60; // Default 25 minutes
  Timer? _timer;
  final List<bool> _isLoading = [false, false, false, false, false];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _startSession() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_sessionTime > 0) {
        setState(() {
          _sessionTime--;
        });
      } else {
        timer.cancel();
        _showSessionCompleteDialog();
      }
    });
  }

  void _showSessionCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Session Complete'),
        content: const Text('Great job! Take a short break.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _onButtonPressed(int index) async {
    setState(() {
      _isLoading[index] = true;
    });

    // Simulate a delay for loading
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading[index] = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if the app is running on the web
    if (!kIsWeb) {
      return Scaffold(
        body: Center(
          child: Text(
            'This app is only accessible online.',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        backgroundColor: const Color(0xFF212B38), // Match the background color
      );
    }

    final List<String> buttonNames = [
      'Start Session',
      'Pause Session',
      'Reset Timer',
      'View Analytics',
      'Settings'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        color: const Color(0xFF212B38), // Set background color to #212B38
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Align buttons to the top
          mainAxisAlignment: MainAxisAlignment.start, // Align buttons to the left
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align buttons to the left within the column
              mainAxisAlignment: MainAxisAlignment.start, // Align buttons to the top within the column
              children: List.generate(5, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0), // Add some spacing
                  child: ElevatedButton(
                    onPressed: _isLoading[index] ? null : () => _onButtonPressed(index),
                    child: _isLoading[index]
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(buttonNames[index]), // Unique button name
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}