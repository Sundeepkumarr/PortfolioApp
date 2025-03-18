import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  List<dynamic> repos = [];
  bool showAll = false;
  bool isLoading = true;
  // Replace with your GitHub username.
  final String githubUsername = 'your-github-username';

  @override
  void initState() {
    super.initState();
    _fetchRepos();
  }

  Future<void> _fetchRepos() async {
    setState(() {
      isLoading = true;
    });
    final url = 'https://api.github.com/users/$githubUsername/repos';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> repoData = jsonDecode(response.body);
      setState(() {
        repos = repoData;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching repositories')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Decide which repos to display.
    final List<dynamic> displayRepos = showAll ? repos : repos.take(3).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Projects"),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchRepos,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Animated list of repository items.
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        child: ListView.builder(
                          key: ValueKey(showAll),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: displayRepos.length,
                          itemBuilder: (context, index) {
                            final repo = displayRepos[index];
                            return ProjectRepoItem(
                              repoName: repo['name'] ?? '',
                              repoDescription: repo['description'] ?? '',
                              repoStars: repo['stargazers_count'] ?? 0,
                              animationDelay: index * 300,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showAll = !showAll;
                          });
                        },
                        child:
                            Text(showAll ? "Show Less" : "All Personal Repo"),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Total Repos: ${repos.length}",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

/// A widget that displays each repository item with an animated appearance.
class ProjectRepoItem extends StatelessWidget {
  final String repoName;
  final String repoDescription;
  final int repoStars;
  final int animationDelay;

  const ProjectRepoItem({
    super.key,
    required this.repoName,
    required this.repoDescription,
    required this.repoStars,
    required this.animationDelay,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: animationDelay)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: Duration(milliseconds: 500),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Card(
              color: Colors.grey[900],
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(repoName, style: TextStyle(color: Colors.white)),
                subtitle: Text(repoDescription,
                    style: TextStyle(color: Colors.white70)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.yellowAccent, size: 16),
                    SizedBox(width: 4),
                    Text(repoStars.toString(),
                        style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
