import 'package:flutter/material.dart';
import 'dart:async'; // Import for using Timer
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:productivity_app_andy/progressPage.dart';
import 'package:device_preview/device_preview.dart';
import 'package:productivity_app_andy/splashScreen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:productivity_app_andy/providers/task_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: DevicePreview(
        enabled: true,
        builder: (context) => const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
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
  int coins = 0;
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
          coins += 10;
          isTimerRunning = false;
          remainingTime = 0;
          isBreakActive = true;
          showBreakTime = true;
          showBackToTimerButton = true;
        });

        // Add task when timer completes
        final taskProvider = Provider.of<TaskProvider>(context, listen: false);
        taskProvider.addTask(Task(
          id: DateTime.now().toString(),
          title: "Focus Session",
          createdAt: DateTime.now(),
          focusTime: Duration(seconds: timerDuration),
          treesPlanted: 1,
          isCompleted: true,
        ));

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
          height: 50,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF87C4B4),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Add your settings action here if needed
            },
          ),
        ],
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
    'Cerasus s.',
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
  final List<bool> _hovered =
      List.generate(TreesPage.treeSpeciesNames.length, (index) => false);

  void _showSnackBar(BuildContext context, String treeName) {
    final snackBar = SnackBar(
      content: Text('You selected $treeName'),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/fglogo.png',
          height: 50,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF87C4B4),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Choose a Tree Species',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 5, // Display 5 boxes per row
              childAspectRatio: 0.8, // Adjust for smaller boxes
              padding: const EdgeInsets.all(8.0),
              children:
                  List.generate(TreesPage.treeSpeciesNames.length, (index) {
                return MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _hovered[index] = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _hovered[index] = false;
                    });
                  },
                  child: Card(
                    elevation: _hovered[index] ? 8 : 4,
                    color:
                        _hovered[index] ? Colors.green[200] : Colors.green[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        final treeName = TreesPage.treeSpeciesNames[index];
                        _showSnackBar(context, treeName); // Show notification
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Image.asset(
                                TreesPage.treeImages[index],
                                fit: BoxFit.contain,
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
                                TreesPage.treeSpeciesNames[index],
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
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
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
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/fglogo.png',
          height: 50,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF87C4B4),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
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
                          icon: const Icon(Icons.check_circle,
                              color: Colors.green),
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
        ],
      ),
      bottomNavigationBar: Padding(
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
  int coins = 0;
  int timerDuration = 600; // Changed to seconds (10 minutes default)
  bool isTimerRunning = false;
  bool isBreakActive = false;
  late Timer timer;
  int remainingTime = 0;
  int breakTimeSeconds = 0;
  Timer? breakTimer;
  bool showBreakTime = false;
  bool showBackToTimerButton = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMusicPlaying = false;
  bool _isMuted = false;
  String currentTrack = 'music/nintendo.mp3';

  @override
  void initState() {
    super.initState();
    remainingTime = timerDuration;
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  void startTimer() {
    setState(() {
      isTimerRunning = true;
      remainingTime = timerDuration;
      isBreakActive = false;
      breakTimeSeconds = 0;
      showBreakTime = false;
      showBackToTimerButton = false;
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
          coins += 10;
          isTimerRunning = false;
          remainingTime = 0;
          isBreakActive = true;
          showBreakTime = true;
          showBackToTimerButton = true;
        });

        // Add this block to create a task when timer completes
        final taskProvider = Provider.of<TaskProvider>(context, listen: false);
        taskProvider.addTask(Task(
          id: DateTime.now().toString(),
          title: "Focus Session",
          createdAt: DateTime.now(),
          focusTime: Duration(seconds: timerDuration),
          treesPlanted: 1,
          isCompleted: true,
        ));

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
        coins += minutesSpent;
        isTimerRunning = false;
        remainingTime = timerDuration;
        isBreakActive = false;
        breakTimeSeconds = 0;
        showBreakTime = false;
        showBackToTimerButton = false;
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

  void startBreakTimer() {
    if (isBreakActive && breakTimer == null) {
      breakTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        if (!isBreakActive) {
          timer.cancel();
          breakTimer = null;
        } else {
          setState(() {
            breakTimeSeconds++;
          });
        }
      });
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

  String get formattedBreakTime {
    return '$breakTimeSeconds';
  }

  void goBackToTimer() {
    setState(() {
      isTimerRunning = false;
      remainingTime = timerDuration;
      showBreakTime = false;
      showBackToTimerButton = false;
      isBreakActive = false;
      breakTimeSeconds = 0;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    timer.cancel();
    breakTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isBreakActive) {
      startBreakTimer();
    }

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/fglogo.png',
          height: 50,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFB9EDDD),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.playlist_play, color: Colors.white),
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
                      color: _isMusicPlaying ? Colors.green : Colors.white,
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
                              const Text(
                                'Drag to set minutes',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
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
                  // Break time display
                  if (showBreakTime) ...[
                    const Text(
                      'Break Time',
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Time elapsed: ${formattedBreakTime}s',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    if (showBackToTimerButton)
                      ElevatedButton(
                        onPressed: goBackToTimer,
                        child: const Text('Back to Timer'),
                      ),
                  ],
                  // Coins display
                  const SizedBox(height: 20),
                  Text(
                    'Coins: $coins',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// end

