import 'package:flutter/material.dart';
import 'dart:async'; // Import for using Timer
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          primary: Colors.green,
          secondary: Colors.greenAccent,
          surface: Colors.lightGreen,
          background: Colors.green[50],
        ),
        useMaterial3: true,
      ),
      home: const FirstPage(),
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
  int timerDuration = 10; // Default to 10 minutes
  bool isTimerRunning = false;
  late Timer timer;
  int remainingTime = 0; // Time remaining in seconds

  void startTimer() {
    setState(() {
      isTimerRunning = true;
      remainingTime = timerDuration * 60; // Convert to seconds
    });

    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (remainingTime <= 0) {
        setState(() {
          coins += 10; // Increase coins by 10
          isTimerRunning = false;
          remainingTime = 0; // Reset remaining time
        });
        timer.cancel();
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

  void cancelTimer() {
    if (isTimerRunning) {
      timer.cancel();
      setState(() {
        isTimerRunning = false;
        timerDuration = 10; // Reset timer duration to 10 minutes
        remainingTime = timerDuration * 60; // Reset remaining time to 10 minutes in seconds
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
      body: Stack(
        children: [
          // Main content in the center
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  SleekCircularSlider(
                    initialValue: timerDuration.toDouble(),
                    min: 10,
                    max: 120,
                    onChange: (double value) {
                      setState(() {
                        timerDuration = value.toInt();
                        remainingTime = timerDuration * 60;
                      });
                    },
                    appearance: CircularSliderAppearance(
                      customColors: CustomSliderColors(
                        dotColor: Colors.greenAccent,
                        trackColor: Colors.green[100],
                        progressBarColor: Colors.green,
                      ),
                      size: 250,
                    ),
                    innerWidget: (double value) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/tree.png',
                            fit: BoxFit.cover,
                            height: 100,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    formattedTime,
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isTimerRunning ? cancelTimer : startTimer,
                    child: Text(isTimerRunning ? 'Cancel Timer' : 'Start Timer'),
                  ),
                ],
              ),
            ),
          ),
          // Coin counter with image in the top-right corner
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.greenAccent.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'images/gold_coin.png', // Displays the gold coin image
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Coins: $coins',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: const Text(
                'Navigation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Timer'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const FirstPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Second Page'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Third Page'),
              onTap: () {
                Navigator.pop(context);
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
