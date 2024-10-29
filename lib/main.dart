import 'package:flutter/material.dart';
import 'dart:async'; // Import for using Timer

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productivity App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FirstPage(), // Set FirstPage as the initial home
    );
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int coins = 0;
  int? timerDuration; // Changed to nullable int
  bool isTimerRunning = false;
  late Timer timer;
  int remainingTime = 0; // Time remaining in seconds

  void startTimer() {
    if (timerDuration != null && timerDuration! > 0) {
      setState(() {
        isTimerRunning = true;
        remainingTime = timerDuration! * 60; // Convert to seconds
      });

      timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        if (remainingTime <= 0) {
          // Timer completed, increase coin count
          setState(() {
            coins += 10; // Increase coins by 10
            isTimerRunning = false;
            remainingTime = 0; // Reset remaining time
          });
          timer.cancel();
          // Show a completion message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pomodoro completed! You earned 10 coins!')),
          );
        } else {
          setState(() {
            remainingTime--; // Decrease remaining time
          });
        }
      });
    }
  }

  void stopTimer() {
    if (isTimerRunning) {
      timer.cancel();
      setState(() {
        isTimerRunning = false;
      });
    }
  }

  String get formattedTime {
    int minutes = remainingTime ~/ 60;
    int seconds = remainingTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Add your settings action here if needed
            },
          ),
        ],
      ),
      body: Center( // Centering the content
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Total Coins: $coins', style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
              Text('Set Pomodoro Timer (10 to 120 minutes):'),
              const SizedBox(height: 10),
              DropdownButton<int>(
                value: timerDuration, // Changed to nullable int
                hint: const Text('Select duration'),
                items: List.generate(121, (index) => index + 10) // Generates numbers from 10 to 120
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value minutes'),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    timerDuration = newValue; // Set selected value
                  });
                },
              ),
              const SizedBox(height: 20),
              if (isTimerRunning) // Show countdown if the timer is running
                Text(
                  formattedTime,
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isTimerRunning ? null : startTimer,
                child: const Text('Start Timer'),
              ),
              ElevatedButton(
                onPressed: isTimerRunning ? stopTimer : null,
                child: const Text('Stop Timer'),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: const Text(
                'Navigation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Second Page'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Third Page'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ThirdPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Page'),
      ),
      body: const Center(
        child: Text('This is the second page.'),
      ),
    );
  }
}

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Third Page'),
      ),
      body: const Center(
        child: Text('This is the third page.'),
      ),
    );
  }
}
