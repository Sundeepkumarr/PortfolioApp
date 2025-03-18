import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  // This variable holds the currently selected section.
  String _selectedSection = 'education';

  // Returns content based on the selected section.
  Widget _buildContent() {
    switch (_selectedSection) {
      case 'education':
        return Container(
          key: ValueKey('education'),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SLC: Completed",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                "+2: Completed",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                "Bachelor: Running",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        );
      case 'experience':
        return Container(
          key: ValueKey('experience'),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Intern at XYZ Company",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                "Freelance Developer at ABC",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        );
      case 'achievement':
        return Container(
          key: ValueKey('achievement'),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Winner of Coding Competition",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                "Developed an award-winning app",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        );
      default:
        return Container();
    }
  }

  // Helper to build a custom button for each section.
  Widget _buildSectionButton(String title, String section) {
    bool isSelected = _selectedSection == section;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedSection = section;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("About"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Section buttons
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSectionButton("Education", "education"),
                _buildSectionButton("Experience", "experience"),
                _buildSectionButton("Achievement", "achievement"),
              ],
            ),
          ),
          // Animated content area.
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }
}
