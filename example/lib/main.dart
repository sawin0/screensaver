import 'package:flutter/material.dart';
import 'package:screensaver/screensaver.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Screen Saver Demo',
      theme: ThemeData.dark(),
      // Wrap your entire app with ScreenSaverWrapper
      home: ScreenSaverWrapper(
        mediaItems: [
          // Local image asset
          ScreenSaverMedia.image('assets/images/syambhu.jpg'),

          // Network image
          ScreenSaverMedia.image(
            'https://missionhimalayatreks.com/wp-content/uploads/2023/12/Natural-beauty-of-Nepal.webp',
            placeholder:
                'assets/images/syambhu.jpg', // Fallback if network fails
          ),

          // Local GIF
          ScreenSaverMedia.gif('assets/gifs/nepal.gif'),

          // Local video
          ScreenSaverMedia.video('assets/videos/machhapuchre.mp4'),

          // Network video
          ScreenSaverMedia.video(
            'https://cdn.pixabay.com/video/2024/07/13/220945_tiny.mp4',
            placeholder: 'assets/images/syambhu.jpg',
          ),
        ],
        inactivityDuration: const Duration(seconds: 10), // 10 seconds for demo
        slideDuration: const Duration(seconds: 4),
        backgroundColor: Colors.black,
        slideCurve: Curves.linear,
        child: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _lastActiveTime;

  @override
  void initState() {
    super.initState();
    _lastActiveTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screen Saver Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Wait 10 seconds without interaction\nTap anywhere to reset timer',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() => _lastActiveTime = DateTime.now());
              },
              child: const Text('Reset Activity Timer'),
            ),
            const SizedBox(height: 20),
            StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                final secondsSinceActive = DateTime.now()
                    .difference(_lastActiveTime ?? DateTime.now())
                    .inSeconds;
                final secondsRemaining = 10 - secondsSinceActive;

                return Text(
                  secondsSinceActive < 10
                      ? 'Screen saver in: ${secondsRemaining}s'
                      : 'Screen saver active! Tap to dismiss',
                  style: TextStyle(
                    fontSize: 18,
                    color: secondsSinceActive > 8
                        ? Colors.orange
                        : Colors.white,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Activity detected! Timer reset')),
          );
          setState(() => _lastActiveTime = DateTime.now());
        },
        child: const Icon(Icons.touch_app),
      ),
    );
  }
}
