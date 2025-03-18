import 'package:flutter/material.dart';

/// Model class for a Skill.
class Skill {
  final String name;
  final int percentage; // Percentage value (0 to 100)
  Skill({required this.name, required this.percentage});
}

/// SkillPage shows different categories with drop-down (ExpansionTile)
/// Each expanded tile shows a list of skills with circular animations.
class SkillPage extends StatelessWidget {
  // Sample skill data organized by category.
  final Map<String, List<Skill>> skillCategories = {
    'App Development': [
      Skill(name: 'Dart', percentage: 90),
      Skill(name: 'Flutter', percentage: 85),
    ],
    'Web Development': [
      Skill(name: 'HTML', percentage: 90),
      Skill(name: 'CSS', percentage: 80),
      Skill(name: 'JavaScript', percentage: 85),
    ],
    'Databases': [
      Skill(name: 'MySQL', percentage: 80),
      Skill(name: 'PostgreSQL', percentage: 70),
      Skill(name: 'MongoDB', percentage: 75),
    ],
    'Software': [
      Skill(name: 'C', percentage: 80),
      Skill(name: 'C++', percentage: 75),
      Skill(name: 'Python', percentage: 85),
    ],
  };

  SkillPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Skills'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: skillCategories.keys.map((category) {
          return ExpansionTile(
            backgroundColor: Colors.grey[900],
            collapsedBackgroundColor: Colors.black,
            title: Text(
              category,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: skillCategories[category]!
                      .map((skill) => SkillWidget(
                            name: skill.name,
                            percentage: skill.percentage,
                          ))
                      .toList(),
                ),
              )
            ],
          );
        }).toList(),
      ),
    );
  }
}

/// SkillWidget shows a circular animated progress indicator with a percentage value.
class SkillWidget extends StatelessWidget {
  final String name;
  final int percentage;

  const SkillWidget({
    super.key,
    required this.name,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: percentage / 100),
          duration: Duration(seconds: 2),
          builder: (context, double value, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: value,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  ),
                ),
                Text(
                  '${(value * 100).round()}%',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            );
          },
        ),
        SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
