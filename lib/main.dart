// import 'package:flutter/material.dart';
// import 'dart:async'; // Import for using Timer
// import 'package:sleek_circular_slider/sleek_circular_slider.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Productivity App',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.green,
//           primary: Colors.green,
//           secondary: Colors.greenAccent,
//           surface: Colors.lightGreen,
//           background: Colors.green[50],
//         ),
//         useMaterial3: true,
//       ),
//       home: const FirstPage(),
//     );
//   }
// }

// class FirstPage extends StatefulWidget {
//   const FirstPage({super.key});

//   @override
//   State<FirstPage> createState() => _FirstPageState();
// }

// class _FirstPageState extends State<FirstPage> {
//   int coins = 0;
//   int timerDuration = 10; // Default to 10 seconds
//   bool isTimerRunning = false;
//   bool isBreakActive = false;
//   late Timer timer;
//   int remainingTime = 0; // Time remaining in seconds
//   int breakTimeSeconds = 0; // Break time counter
//   Timer? breakTimer; // Timer for break time
//   bool showBreakTime = false; // Flag to control visibility of break time

//   @override
//   void initState() {
//     super.initState();
//     remainingTime = timerDuration; // Set initial remaining time to timerDuration
//   }

//   void startTimer() {
//     setState(() {
//       isTimerRunning = true;
//       remainingTime = timerDuration; // Reset remaining time to timerDuration when starting
//       isBreakActive = false; // Ensure break is not active
//       breakTimeSeconds = 0; // Reset break time counter
//       showBreakTime = false; // Hide break time initially
//     });

//     timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
//       if (remainingTime <= 0) {
//         setState(() {
//           coins += 10; // Increase coins by 10
//           isTimerRunning = false;
//           remainingTime = 0; // Reset remaining time
//           isBreakActive = true; // Activate break timer
//           showBreakTime = true; // Show break time
//         });
//         timer.cancel();
//       } else {
//         setState(() {
//           remainingTime--; // Decrease remaining time
//         });
//       }
//     });
//   }

//   void cancelTimer() {
//     if (isTimerRunning) {
//       timer.cancel();
//       setState(() {
//         isTimerRunning = false;
//         timerDuration = 10; // Reset timer duration to 10 seconds
//         remainingTime = timerDuration; // Reset remaining time to 10 seconds
//       });
//     }
//   }

//   void goBackToTimer() {
//     setState(() {
//       isTimerRunning = false;
//       remainingTime = timerDuration; // Reset remaining time to timerDuration
//       showBreakTime = false; // Hide break time when going back to timer
//     });
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const FirstPage()), // Navigate to the default home page
//     );
//   }

//   void startBreakTimer() {
//     if (isBreakActive && breakTimer == null) {
//       breakTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
//         if (!isBreakActive) {
//           timer.cancel(); // Stop break timer if break is no longer active
//           breakTimer = null; // Reset break timer reference
//         } else {
//           setState(() {
//             breakTimeSeconds++; // Increment break time counter
//           });
//         }
//       });
//     }
//   }

//   String get formattedTime {
//     if (remainingTime == 0) {
//       return ''; // Return empty string when time is up
//     }
//     return '${remainingTime.toString().padLeft(2, '0')}'; // Format remaining time
//   }

//   String get formattedBreakTime {
//     return '$breakTimeSeconds'; // Show the break time seconds
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Start break timer if break is active
//     if (isBreakActive) {
//       startBreakTimer();
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Pomodoro Timer'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings),
//             onPressed: () {
//               // Add your settings action here if needed
//             },
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.green,
//               ),
//               child: Text(
//                 'Menu',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.home),
//               title: const Text('Home'),
//               onTap: () {
//                 Navigator.pop(context); // Close the drawer
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.list),
//               title: const Text('Tasks'),
//               onTap: () {
//                 // Navigate to your tasks page here
//                 Navigator.pop(context); // Close the drawer
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.calendar_today),
//               title: const Text('Calendar'),
//               onTap: () {
//                 // Navigate to your calendar page here
//                 Navigator.pop(context); // Close the drawer
//               },
//             ),
//             // Add more menu items as needed
//           ],
//         ),
//       ),
//       body: Stack(
//         children: [
//           // Main content in the center
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   const SizedBox(height: 20),
//                   if (!isTimerRunning && remainingTime == 0)
//                     const Text(
//                       'Hooray! You planted a tree!',
//                       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     )
//                   else if (isTimerRunning)
//                     const Text(
//                       'Keep going! You can do it!',
//                       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     )
//                   else
//                     const Text(
//                       'Plant a tree today!',
//                       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                   SleekCircularSlider(
//                     initialValue: timerDuration.toDouble(),
//                     min: 1, // Minimum value in seconds
//                     max: 120, // Maximum value in seconds
//                     onChange: (double value) {
//                       setState(() {
//                         timerDuration = value.toInt();
//                         remainingTime = timerDuration; // Update remaining time in seconds
//                       });
//                     },
//                     onChangeEnd: (double value) {
//                       if (!isTimerRunning && remainingTime == 0) {
//                         goBackToTimer(); // Trigger go back to timer when slider is adjusted after timer ends
//                       }
//                     },
//                     appearance: CircularSliderAppearance(
//                       customColors: CustomSliderColors(
//                         dotColor: Colors.greenAccent,
//                         trackColor: Colors.green[100],
//                         progressBarColor: Colors.green,
//                       ),
//                       size: 250,
//                     ),
//                     innerWidget: (double value) {
//                       return Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Stack(
//                             alignment: Alignment.bottomCenter, // Align the rectangle and image at the bottom
//                             children: [
//                               // Brown rectangle representing the tree's roots
//                               Container(
//                                 width: 100, // Adjust width as necessary
//                                 height: 10, // Height of the roots
//                                 color: Colors.brown, // Brown color for the roots
//                               ),
//                               // Tree image
//                               Image.asset(
//                                 'images/tree.png',
//                                 fit: BoxFit.cover,
//                                 height: 100,
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8), // Add space between the image and stopwatch
//                           if (showBreakTime) // Display break time when flag is true
//                             AnimatedOpacity(
//                               opacity: showBreakTime ? 1.0 : 0.0, // Control opacity for fade effect
//                               duration: const Duration(milliseconds: 500), // Fade duration
//                               child: Text(
//                                 'Break Time: $formattedBreakTime',
//                                 style: const TextStyle(
//                                   fontSize: 16, // Smaller font size for break stopwatch
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   // Display the selected timer duration
//                   if (!showBreakTime) // Only show selected time when break is not active
//                     AnimatedOpacity(
//                       opacity: isTimerRunning ? 0.0 : 1.0, // Fade out when timer starts
//                       duration: const Duration(milliseconds: 500), // Set fade animation duration
//                       child: Text(
//                         '${timerDuration ~/ 60} min ${timerDuration % 60} sec',
//                         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   if (isTimerRunning) // Show formatted time when timer is running
//                     Text(
//                       formattedTime,
//                       style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
//                     ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (isTimerRunning) {
//                         cancelTimer(); // Cancel the timer if running
//                       } else {
//                         startTimer(); // Start the timer
//                       }
//                     },
//                     child: Text(isTimerRunning ? 'Cancel Timer' : 'Start Timer'),
//                   ),
//                   ElevatedButton(
//                     onPressed: goBackToTimer,
//                     child: const Text('Go Back to Timer'), // New button to go back to timer
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     timer.cancel();
//     breakTimer?.cancel(); // Cancel break timer if it's active
//     super.dispose();
//   }
// }

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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
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
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Calendar'),
              onTap: () {
                // Navigate to your calendar page here
                Navigator.pop(context); // Close the drawer
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
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    )
                  else if (isTimerRunning)
                    const Text(
                      'Keep going! You can do it!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    )
                  else
                    const Text(
                      'Plant a tree today!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  if (isTimerRunning) // Show formatted time when timer is running
                    Text(
                      formattedTime,
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                  const SizedBox(height: 20),
                  // The 'Go Back to Timer' button with fade effect
                  AnimatedOpacity(
                    opacity: showBackToTimerButton ? 1.0 : 0.0, // Fade in effect
                    duration: const Duration(milliseconds: 500), // Set fade animation duration
                    child: ElevatedButton(
                      onPressed: goBackToTimer,
                      child: const Text('Go Back to Timer'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Start timer button
                  if (!isTimerRunning && remainingTime > 0)
                    ElevatedButton(
                      onPressed: startTimer,
                      child: const Text('Start Timer'),
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
    timer.cancel();
    breakTimer?.cancel(); // Cancel break timer when disposing
    super.dispose();
  }
}


