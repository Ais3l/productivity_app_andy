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
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          primary: Colors.green,
          secondary: Colors.greenAccent,
          surface: const Color.fromARGB(255, 106, 199, 139),
          background: Colors.green[50],
        ),
        useMaterial3: true,
      ),
      home: const FirstPage(),
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

  @override
  void initState() {
    super.initState();
    remainingTime = timerDuration; // Set initial remaining time to timerDuration
  }

  void startTimer() {
    setState(() {
      isTimerRunning = true;
      remainingTime = timerDuration; // Reset remaining time to timerDuration when starting
      isBreakActive = false; // Ensure break is not active
      breakTimeSeconds = 0; // Reset break time counter
      showBreakTime = false; // Hide break time initially
      showBackToTimerButton = false; // Hide back to timer button initially
    });

    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (remainingTime <= 0) {
        setState(() {
          coins += 10; // Increase coins by 10
          isTimerRunning = false;
          remainingTime = 0; // Reset remaining time
          isBreakActive = true; // Activate break timer
          showBreakTime = true; // Show break time
          showBackToTimerButton = true; // Show back to timer button
        });
        timer.cancel();
      } else {
        setState(() {
          remainingTime--; // Decrease remaining time
        });
      }
    });
  }

  void goBackToTimer() {
    setState(() {
      isTimerRunning = false;
      remainingTime = timerDuration; // Reset remaining time to timerDuration
      showBreakTime = false; // Hide break time when going back to timer
      showBackToTimerButton = false; // Hide back to timer button when going back
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const FirstPage()), // Navigate to the default home page
    );
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
    return '${remainingTime.toString().padLeft(2, '0')}'; // Format remaining time
  }

  String get formattedBreakTime {
    return '$breakTimeSeconds'; // Show the break time seconds
  }

  @override
  Widget build(BuildContext context) {
    // Start break timer if break is active
    if (isBreakActive) {
      startBreakTimer();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Add your settings action here if needed
            },
          ),
        ],
      ),
      
      //

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'images/tree.png',
                    width: 40,
                    height: 40,
                  ),
                  SizedBox(width: 10),

                  Expanded( // Use Expanded to take up the remaining space
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10), // Space between name and tree info

                        Text(
                          'Your Tree Species: Juglans nigra', // Example species
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          'Trees Planted Today: 0', // Example number
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Timer'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),

            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Tasks'),
              onTap: () {
                // Navigate to your tasks page here
                Navigator.pop(context); // Close the drawer
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const TasksPage(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0); // Starting point of the animation (off screen)
                      const end = Offset.zero; // Ending point (on screen)
                      const curve = Curves.easeInOut; // Curve for the animation

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve)); // Tween for animation
                      var offsetAnimation = animation.drive(tween); // Apply tween to the animation

                      return SlideTransition(
                        position: offsetAnimation,
                        child: FadeTransition(
                          opacity: animation, // Fade in effect
                          child: child,
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.trending_up),
              title: const Text('Progress'),
              onTap: () {
                // Navigate to your progress page here
                Navigator.pop(context); // Close the drawer
              },
            ),

            ListTile(
              leading: const Icon(Icons.nature),
              title: const Text('Trees'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const TreesPage(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0); // Starting point of the animation (off screen)
                      const end = Offset.zero; // Ending point (on screen)
                      const curve = Curves.easeInOut; // Curve for the animation

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve)); // Tween for animation
                      var offsetAnimation = animation.drive(tween); // Apply tween to the animation

                      return SlideTransition(
                        position: offsetAnimation,
                        child: FadeTransition(
                          opacity: animation, // Fade in effect
                          child: child,
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            // Add more menu items as needed
          ],
        ),
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
                  if (!isTimerRunning && remainingTime == 0)
                    const Text(
                      'Hooray! You planted a tree!',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    )
                  else if (isTimerRunning)
                    const Text(
                      'Keep going! You can do it!',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    )
                  else
                    const Text(
                      'Plant a tree today!',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  SleekCircularSlider(
                    initialValue: timerDuration.toDouble(),
                    min: 1, // Minimum value in seconds
                    max: 120, // Maximum value in seconds
                    onChange: (double value) {
                      setState(() {
                        timerDuration = value.toInt();
                        remainingTime = timerDuration; // Update remaining time in seconds
                      });
                    },
                    onChangeEnd: (double value) {
                      if (!isTimerRunning && remainingTime == 0) {
                        goBackToTimer(); // Trigger go back to timer when slider is adjusted after timer ends
                      }
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
                          Stack(
                            alignment: Alignment.bottomCenter, // Align the rectangle and image at the bottom
                            children: [
                              // Brown rectangle representing the tree's roots
                              Container(
                                width: 100, // Adjust width as necessary
                                height: 10, // Height of the roots
                                color: Colors.brown, // Brown color for the roots
                              ),
                              // Tree image
                              Image.asset(
                                'images/tree.png',
                                fit: BoxFit.cover,
                                height: 100,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8), // Add space between the image and stopwatch
                          if (showBreakTime) // Display break time when flag is true
                            AnimatedOpacity(
                              opacity: showBreakTime ? 1.0 : 0.0, // Control opacity for fade effect
                              duration: const Duration(milliseconds: 500), // Fade duration
                              child: Text(
                                'Break Time: $formattedBreakTime',
                                style: const TextStyle(
                                  fontSize: 16, // Smaller font size for break stopwatch
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  // Display the selected timer duration
                  if (!showBreakTime) // Only show selected time when break is not active
                    AnimatedOpacity(
                      opacity: isTimerRunning ? 0.0 : 1.0, // Fade out when timer starts
                      duration: const Duration(milliseconds: 500), // Set fade animation duration
                      child: Text(
                        '${timerDuration ~/ 60} min ${timerDuration % 60} sec',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  if (isTimerRunning) // Show formatted time when timer is running
                    Text(
                      formattedTime,
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  const SizedBox(height: 20),
                  if (!isTimerRunning  && !showBackToTimerButton)
                    ElevatedButton(
                      onPressed: startTimer,
                      child: const Text('Plant'),
                    ),
                  if (showBackToTimerButton)
                    ElevatedButton(
                      onPressed: goBackToTimer,
                      child: const Text('Go Back to Timer'),
                    ),
                ],
              ),
            ),
          ),
          // Coin display in the top right corner
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 85, 182, 90),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'images/gold_coin.png', // Path to your image
                    height: 24, // Set the desired height
                    width: 24, // Set the desired width
                  ),

                  // const Icon(
                  //   Icons.monetization_on,
                  //   color: Colors.white,
                  // ),
                  
                  const SizedBox(width: 5),
                  Text(
                    '$coins',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
    'Cerasus serrulata',
    'Ulmus',
    'Picea',
    'Rhizophora mangle L.',
    'Dracaena draco',
    'Eucalyptus deglupta',
    'Sequoiadendron g.',
    'Salix babylonica',
    'Malus angustifolia',
    'Acer palmatum',
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
  final List<bool> _hovered = List.generate(TreesPage.treeSpeciesNames.length, (index) => false);

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
        title: const Text(''),
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
              children: List.generate(TreesPage.treeSpeciesNames.length, (index) {
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
                    color: _hovered[index] ? Colors.green[200] : Colors.green[100],
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
                              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
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
  final List<Map<String, dynamic>> _tasks = []; // List to hold tasks with their completion status
  bool _isMicActive = false; // State variable for mic icon color

  void _addNewTask(String task) {
    setState(() {
      if (task.isNotEmpty) {
        _tasks.add({'text': task, 'isCompleted': false}); // Adds a new task to the end of the list
      }
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index]['isCompleted'] = true; // Mark the task as completed
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          _tasks.removeAt(index); // Remove task after clicking the check icon
        });
      });
    });
  }

  void _toggleMic() {
    setState(() {
      _isMicActive = !_isMicActive; // Toggle the mic icon state
    });
  }

  void _showAddTaskDialog() {
    final TextEditingController _taskController = TextEditingController(); // Local controller for dialog input

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: TextField(
            controller: _taskController,
            decoration: const InputDecoration(
              hintText: 'Enter a new task',
            ),
            onSubmitted: (value) {
              _addNewTask(value);
              Navigator.of(context).pop(); // Close the dialog after submission
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                final task = _taskController.text;
                _addNewTask(task);
                Navigator.of(context).pop(); // Close the dialog after submission
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog without adding
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
        title: const Text(
          'Tasks',
          style: TextStyle(color: Colors.white), // Set the font color to white
        ),
        backgroundColor: Colors.green, // AppBar background color
      ),
      body: Column(
        children: [
          // Display each task with a check icon
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(12.0), // Padding inside the container
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color of the task container
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2), // Shadow effect
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3), // Position of the shadow
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            task['text'],
                            style: TextStyle(
                              decoration: task['isCompleted'] ? TextDecoration.lineThrough : null, // Strike through if completed
                              fontSize: 16.0, // Increase font size for better readability
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.check_circle, color: Colors.green), // Check icon
                          onPressed: task['isCompleted'] ? null : () => _toggleTaskCompletion(index), // Only allow if not completed
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
        padding: const EdgeInsets.all(16.0), // Padding around the bottom navigation bar
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space between items
          children: [
            FloatingActionButton(
              onPressed: _toggleMic, // Toggle mic icon state
              backgroundColor: Colors.green,
              child: Icon(
                Icons.mic,
                size: 30,
                color: _isMicActive ? Colors.red : Colors.white, // Change color based on state
              ),
            ),
            FloatingActionButton(
              onPressed: _showAddTaskDialog, // Show dialog to add a new task
              backgroundColor: Colors.green,
              child: const Icon(Icons.add, color: Colors.white), // Set the plus icon color to white
            ),
          ],
        ),
      ),
      backgroundColor: Colors.green[100], // Match the home page color scheme
    );
  }
}
