import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // List to alternate your name text.
  final List<String> names = ["sundeepkumarr", "संदीप कुमार"];
  int currentIndex = 0;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();

    // Initialize the rotation animation for the circle.
    _rotationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    // Timer to switch the name text every 3 seconds.
    Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % names.length;
      });
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  // Function to download (open) your resume URL.
  Future<void> _downloadResume() async {
    final url =
        'https://your-resume-url.com'; // Replace with your actual resume URL.
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch resume URL')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Top part: Background image with rotating circle.
          Expanded(
            flex: 4,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/1.png', // Ensure your image is in the assets folder.
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                RotationTransition(
                  turns: _rotationController,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Middle part: Animated name text, work highlights, and download button.
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  child: Text(
                    names[currentIndex],
                    key: ValueKey<String>(names[currentIndex]),
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "App Developer | Web Developer | Content Creator",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _downloadResume,
                  child: Text("Download Resume"),
                ),
              ],
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar with Home and an extra icon to navigate to another page.
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: 0, // Home page is the default selected index.
        onTap: (index) {
          // For example: if user taps the Achievements icon.
          if (index == 1) {
            Navigator.pushNamed(context, '/achievements');
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Achievements",
          ),
        ],
      ),
    );
  }
}
