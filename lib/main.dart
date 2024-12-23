import 'package:flutter/material.dart';
import 'dart:async'; // Import for using Timer
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:productivity_app_andy/progressPage.dart';
import 'package:productivity_app_andy/splashScreen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:productivity_app_andy/providers/task_provider.dart';
import 'package:productivity_app_andy/providers/tree_provider.dart';
import 'package:productivity_app_andy/providers/coins_provider.dart';
import 'services/weather_service.dart';
import 'models/weather.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskProvider()),
        ChangeNotifierProvider(create: (context) => TreeProvider()),
        ChangeNotifierProvider(create: (context) => CoinsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          primary: Colors.green,
          secondary: Colors.greenAccent,
          surface: const Color.fromARGB(255, 106, 199, 139),
          background: const Color(0xFFB9EDDD),
        ),
        scaffoldBackgroundColor: const Color(0xFFB9EDDD),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// Timer Page

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int timerDuration = 10; // Default to 10 seconds
  bool isTimerRunning = false;
  bool isBreakActive = false;
  late Timer timer;
  int remainingTime = 0; // Time remaining in seconds
  int breakTimeSeconds = 0; // Break time counter
  Timer? breakTimer; // Timer for break time
  bool showBreakTime = false; // Flag to control visibility of break time
  bool showBackToTimerButton = false; // Flag for the back to timer button
  int _selectedIndex = 0;
  int _selectedTreeIndex = 0;
  final List<Widget> _pages = [
    const TimerContent(), // We'll create this widget to hold the timer content
    const TasksPage(),
    const ProgressPage(), // You'll need to create this page
    const TreesPage(),
  ];

  @override
  void initState() {
    super.initState();
    remainingTime =
        timerDuration; // Set initial remaining time to timerDuration
  }

  void startTimer() {
    setState(() {
      isTimerRunning = true;
      remainingTime =
          timerDuration; // Reset remaining time to timerDuration when starting
      isBreakActive = false; // Ensure break is not active
      breakTimeSeconds = 0; // Reset break time counter
      showBreakTime = false; // Hide break time initially
      showBackToTimerButton = false; // Hide back to timer button initially
    });

    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (remainingTime <= 0) {
        setState(() {
          isTimerRunning = false;
          remainingTime = timerDuration;
        });

        // Calculate coins based on minutes (10 coins per minute)
        final minutesCompleted =
            timerDuration ~/ 60; // Convert seconds to minutes
        final coinsEarned = minutesCompleted * 10;

        // Add coins when timer completes
        final coinsProvider =
            Provider.of<CoinsProvider>(context, listen: false);
        coinsProvider.addCoins(coinsEarned);

        // Increment trees planted
        coinsProvider.plantTree(); // This only increments trees planted

        // Add task when timer completes
        final taskProvider = Provider.of<TaskProvider>(context, listen: false);
        taskProvider.addTask(Task(
          id: DateTime.now().toString(),
          title: "Focus Session",
          createdAt: DateTime.now(),
          focusTime: Duration(seconds: timerDuration),
          treesPlanted: 1, // This can be adjusted based on your logic
          isCompleted:
              true, // Ensure this is set to true only when a task is completed
        ));

        // Show completion dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Session Complete!'),
              content: Text('Good job! You earned $coinsEarned coins!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );

        timer.cancel();
      } else {
        setState(() {
          remainingTime--;
        });
      }
    });
  }

  void goBackToTimer() {
    setState(() {
      isTimerRunning = false;
      remainingTime = timerDuration; // Reset remaining time to timerDuration
      showBreakTime = false; // Hide break time when going back to timer
      showBackToTimerButton =
          false; // Hide back to timer button when going back
    });
    MaterialPageRoute(
        builder: (context) =>
            const FirstPage()); // Navigate to the default home page
  }

  void startBreakTimer() {
    if (isBreakActive && breakTimer == null) {
      breakTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        if (!isBreakActive) {
          timer.cancel(); // Stop break timer if break is no longer active
          breakTimer = null; // Reset break timer reference
        } else {
          setState(() {
            breakTimeSeconds++; // Increment break time counter
          });
        }
      });
    }
  }

  String get formattedTime {
    if (remainingTime == 0) {
      return ''; // Return empty string when time is up
    }
    return remainingTime.toString().padLeft(2, '0'); // Format remaining time
  }

  String get formattedBreakTime {
    return '$breakTimeSeconds'; // Show the break time seconds
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Start break timer if break is active
    if (isBreakActive) {
      startBreakTimer();
    }

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/fglogo.png',
          height: 120,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF87C4B4),
      ),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF87C4B4),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.nature),
            label: 'Trees',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer on dispose
    breakTimer?.cancel(); // Cancel the break timer if active
    super.dispose();
  }
}

// Trees Page //

class TreesPage extends StatefulWidget {
  const TreesPage({super.key});

  static const List<String> treeSpeciesNames = [
    'Cerasus s.', // Default unlocked
    'Ulmus m.',
    'Picea s.',
    'Rhizophora m.',
    'Dracaena d.',
    'Eucalyptus d.',
    'Sequoiadendron g.',
    'Salix b.',
    'Malus a.',
    'Acer p.',
  ];

  static const List<String> treeImages = [
    'images/cherry.png',
    'images/elm.png',
    'images/spruce.png',
    'images/mangrove.png',
    'images/dragon.png',
    'images/rainbow.png',
    'images/giant.png',
    'images/willow.png',
    'images/crab.png',
    'images/maple.png',
  ];

  @override
  _TreesPageState createState() => _TreesPageState();
}

class _TreesPageState extends State<TreesPage> {
  int _selectedTreeIndex = 0;
  final List<bool> _hovered =
      List.generate(TreesPage.treeSpeciesNames.length, (index) => false);
  final List<bool> _unlockedTrees = List.generate(
      TreesPage.treeSpeciesNames.length,
      (index) => index == 0); // First tree unlocked
  static const int treeCost = 10;

  @override
  Widget build(BuildContext context) {
    final coinsProvider = Provider.of<CoinsProvider>(context);
    final treeProvider = Provider.of<TreeProvider>(context);
    final unlockedTrees = treeProvider.unlockedTrees;

    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Choose a Tree Species',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Coins: ${coinsProvider.coins}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              padding: const EdgeInsets.all(8.0),
              children:
                  List.generate(TreesPage.treeSpeciesNames.length, (index) {
                return Card(
                  elevation: unlockedTrees[index] ? 8 : 4,
                  color: unlockedTrees[index]
                      ? Colors.green[200]
                      : Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      if (unlockedTrees[index]) {
                        final treeProvider =
                            Provider.of<TreeProvider>(context, listen: false);
                        treeProvider.setSelectedTree(index);
                        setState(() {
                          _selectedTreeIndex = index;
                        });
                      } else {
                        _purchaseTree(context, index);
                      }
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: ColorFiltered(
                              colorFilter: unlockedTrees[index]
                                  ? const ColorFilter.mode(
                                      Colors.transparent,
                                      BlendMode.saturation,
                                    )
                                  : const ColorFilter.mode(
                                      Colors.grey,
                                      BlendMode.saturation,
                                    ),
                              child: Image.asset(
                                TreesPage.treeImages[index],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          left: 5,
                          child: Container(
                            color: Colors.black54,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2.0),
                            child: Text(
                              unlockedTrees[index]
                                  ? TreesPage.treeSpeciesNames[index]
                                  : '${TreesPage.treeSpeciesNames[index]} (10 coins)',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  void _purchaseTree(BuildContext context, int index) {
    final coinsProvider = Provider.of<CoinsProvider>(context, listen: false);
    final treeProvider = Provider.of<TreeProvider>(context, listen: false);

    if (!treeProvider.unlockedTrees[index] && coinsProvider.coins >= treeCost) {
      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Purchase'),
            content: Text(
                'Do you want to purchase ${TreesPage.treeSpeciesNames[index]}?'),
            actions: [
              TextButton(
                onPressed: () {
                  coinsProvider.spendCoins(treeCost);
                  treeProvider.unlockTree(index); // Unlock the tree
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '${TreesPage.treeSpeciesNames[index]} unlocked!'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text('Purchase'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough coins! Need 10 coins to unlock.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

// Tasks Page //

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final List<Map<String, dynamic>> _tasks = [];
  bool _isMicActive = false;

  void _addNewTask(String task) {
    setState(() {
      if (task.isNotEmpty) {
        _tasks.add({'text': task, 'isCompleted': false});
      }
    });
  }

  void _toggleTaskCompletion(int index) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final task = Task(
      id: DateTime.now().toString(),
      title: _tasks[index]['text'],
      createdAt: DateTime.now(),
      focusTime: const Duration(minutes: 0), // or actual time if you track it
      treesPlanted: 1,
      isCompleted: true,
    );

    taskProvider.addTask(task);

    setState(() {
      _tasks[index]['isCompleted'] = true;
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          _tasks.removeAt(index);
        });
      });
    });
  }

  void _toggleMic() {
    setState(() {
      _isMicActive = !_isMicActive;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('How can AI help you with planning today?'),
        duration: Duration(seconds: 5),
      ),
    );
  }

  void _showAddTaskDialog() {
    final TextEditingController taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(
              hintText: 'Enter a new task',
            ),
            onSubmitted: (value) {
              _addNewTask(value);
              Navigator.of(context).pop();
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                final task = taskController.text;
                _addNewTask(task);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _tasks.length,
            itemBuilder: (context, index) {
              final task = _tasks[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          task['text'],
                          style: TextStyle(
                            decoration: task['isCompleted']
                                ? TextDecoration.lineThrough
                                : null,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.check_circle, color: Colors.green),
                        onPressed: task['isCompleted']
                            ? null
                            : () => _toggleTaskCompletion(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                onPressed: _toggleMic,
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.mic,
                  size: 30,
                  color: _isMicActive ? Colors.red : Colors.white,
                ),
              ),
              FloatingActionButton(
                onPressed: _showAddTaskDialog,
                backgroundColor: Colors.green,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Create a new widget for the timer content
class TimerContent extends StatefulWidget {
  const TimerContent({super.key});

  @override
  State<TimerContent> createState() => _TimerContentState();
}

class _TimerContentState extends State<TimerContent> {
  int timerDuration = 600; // Changed to seconds (10 minutes default)
  bool isTimerRunning = false;
  late Timer timer;
  int remainingTime = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMusicPlaying = false;
  bool _isMuted = false;
  String currentTrack = 'music/nintendo.mp3';
  Weather? _currentWeather;
  bool _isLoadingWeather = false;

  @override
  void initState() {
    super.initState();
    remainingTime = timerDuration;
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    _fetchWeather(); // Fetch weather data on initialization
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoadingWeather = true;
    });

    try {
      final weather =
          await WeatherService.getWeather(); // No city passed, uses default
      setState(() {
        _currentWeather = weather;
        _isLoadingWeather = false;
      });
    } catch (e) {
      print('Error fetching weather: $e');
      setState(() {
        _isLoadingWeather = false;
      });
    }
  }

  void startTimer() {
    setState(() {
      isTimerRunning = true;
      remainingTime = timerDuration;
    });

    // Start playing music when timer starts
    try {
      _audioPlayer.play(AssetSource(currentTrack));
      setState(() {
        _isMusicPlaying = true;
        _isMuted = false;
      });
    } catch (e) {
      print('Error playing audio: $e');
    }

    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (remainingTime <= 0) {
        setState(() {
          isTimerRunning = false;
          remainingTime = timerDuration;
        });

        // Calculate coins based on minutes (10 coins per minute)
        final minutesCompleted =
            timerDuration ~/ 60; // Convert seconds to minutes
        final coinsEarned = minutesCompleted * 10;

        // Add coins when timer completes
        final coinsProvider =
            Provider.of<CoinsProvider>(context, listen: false);
        coinsProvider.addCoins(coinsEarned);

        // Increment trees planted
        coinsProvider.plantTree(); // This only increments trees planted

        // Add task when timer completes
        final taskProvider = Provider.of<TaskProvider>(context, listen: false);
        taskProvider.addTask(Task(
          id: DateTime.now().toString(),
          title: "Focus Session",
          createdAt: DateTime.now(),
          focusTime: Duration(seconds: timerDuration),
          treesPlanted: 1, // This can be adjusted based on your logic
          isCompleted:
              true, // Ensure this is set to true only when a task is completed
        ));

        // Show completion dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Session Complete!'),
              content: Text('Good job! You earned $coinsEarned coins!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );

        timer.cancel();
        _audioPlayer.stop();
        setState(() {
          _isMusicPlaying = false;
        });
      } else {
        setState(() {
          remainingTime--;
        });
      }
    });
  }

  void abortTimer() async {
    if (isTimerRunning) {
      int timeSpent = timerDuration - remainingTime;
      int minutesSpent = (timeSpent / 60).ceil();

      timer.cancel();
      await _audioPlayer.stop();

      setState(() {
        _isMusicPlaying = false;
        isTimerRunning = false;
        remainingTime = timerDuration;
      });
    }
  }

  Future<void> _changeTrack(String newTrack) async {
    try {
      currentTrack = newTrack;
      if (_isMusicPlaying) {
        await _audioPlayer.stop();
        await _audioPlayer.play(AssetSource(currentTrack));
      }
    } catch (e) {
      print('Error changing track: $e');
    }
  }

  void _toggleMute() async {
    try {
      setState(() {
        _isMuted = !_isMuted;
      });

      if (_isMuted) {
        await _audioPlayer.setVolume(0);
      } else {
        await _audioPlayer.setVolume(1);
      }
    } catch (e) {
      print('Error toggling mute: $e');
    }
  }

  String get formattedTime {
    if (remainingTime == 0) {
      return '';
    }
    int minutes = remainingTime ~/ 60;
    int seconds = remainingTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void goBackToTimer() {
    setState(() {
      isTimerRunning = false;
      remainingTime = timerDuration;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final treeProvider = Provider.of<TreeProvider>(context);
    final selectedTreeIndex = treeProvider.selectedTreeIndex;
    final coinsProvider = Provider.of<CoinsProvider>(context, listen: false);

    // Calculate opacity based on remaining time
    double treeOpacity = isTimerRunning
        ? 0.2 +
            (0.8 *
                (1 -
                    remainingTime /
                        timerDuration)) // Starts at 0.2, ends at 1.0
        : 0.2; // Default opacity when timer is not running

    return Stack(
      children: [
        // Background Tree Image
        Positioned.fill(
          child: Opacity(
            opacity: treeOpacity,
            child: Image.asset(
              TreesPage.treeImages[selectedTreeIndex],
              fit: BoxFit.contain,
            ),
          ),
        ),
        // Weather Display Widget - Smaller and Top-Left Positioned
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF87C4B4),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isLoadingWeather)
                  const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else if (_currentWeather != null) ...[
                  Text(
                    '${_currentWeather!.description} | ${_currentWeather!.temperature.toStringAsFixed(1)}°C',
                    style: TextStyle(
                      color: Colors.grey[700], // Same as music icon color
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ] else
                  Text(
                    'Weather unavailable',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Timer content
        Center(
          child: Column(
            children: [
              // Existing timer content
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.playlist_play, color: Colors.grey),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Select Music'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.music_note),
                                    title: const Text('Nintendo Music'),
                                    onTap: () async {
                                      await _changeTrack('music/nintendo.mp3');
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.music_note),
                                    title: const Text('Chill Music'),
                                    onTap: () async {
                                      await _changeTrack('music/chillguy.mp3');
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.music_note),
                                    title: const Text('Rain Sounds'),
                                    onTap: () async {
                                      await _changeTrack('music/rain.mp3');
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.music_note),
                                    title: const Text('Minecraft Music'),
                                    onTap: () async {
                                      await _changeTrack('music/minecraft.mp3');
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        _isMuted ? Icons.volume_off : Icons.volume_up,
                        color: _isMusicPlaying ? Colors.green : Colors.grey,
                      ),
                      onPressed: _toggleMute,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SleekCircularSlider(
                      appearance: CircularSliderAppearance(
                        size: 200,
                        customColors: CustomSliderColors(
                          progressBarColor: Colors.green,
                          trackColor: Colors.green[100],
                          shadowColor: Colors.green[200],
                        ),
                        startAngle: 180,
                        angleRange: 180,
                        customWidths: CustomSliderWidths(
                          progressBarWidth: 20,
                          trackWidth: 20,
                          shadowWidth: 22,
                        ),
                      ),
                      min: 0,
                      max: 60,
                      initialValue: isTimerRunning
                          ? (remainingTime / 60).toDouble()
                          : (remainingTime / 60).floor().toDouble(),
                      onChange: !isTimerRunning
                          ? (double value) {
                              setState(() {
                                timerDuration = (value.round() * 60);
                                remainingTime = timerDuration;
                              });
                            }
                          : null,
                      innerWidget: (double value) {
                        if (isTimerRunning) {
                          final minutes = (remainingTime / 60).floor();
                          final seconds = (remainingTime % 60).floor();
                          return Center(
                            child: Text(
                              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                              style: const TextStyle(fontSize: 48),
                            ),
                          );
                        } else {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${value.round()} min',
                                  style: const TextStyle(fontSize: 48),
                                ),
                                Text(
                                  'Drag to set minutes',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!isTimerRunning)
                          ElevatedButton(
                            onPressed: startTimer,
                            child: const Text('Start Timer'),
                          ),
                        if (isTimerRunning)
                          ElevatedButton(
                            onPressed: abortTimer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Abort Timer'),
                          ),
                      ],
                    ),
                    // Coins display
                    const SizedBox(height: 20),
                    Text(
                      'Coins: ${coinsProvider.coins}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// end

