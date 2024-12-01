import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart'; // url_launcher 추가
import 'class_selection_screen.dart';
import 'login_screen.dart';
import 'drawer_menu.dart';
import 'feedback_history_screen.dart';

class HomeScreen extends StatefulWidget {
  final String? name;

  HomeScreen({this.name});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _launchTaejaePortal() async {
    const url = 'https://portal.taejae.ac.kr/main/indx/index.do';
    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        if (!snapshot.hasData) {
          return Scaffold(
            body: Center(child: Text('No user is logged in.')),
          );
        }

        User? user = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Image.asset('lib/assets/image/logo2.png', height: 32),
                SizedBox(width: 8),
                Text(
                  'Dashboard',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.blue[800],
          ),
          drawer: DrawerMenu(user: user),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey[200]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  // 프로필 카드
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: user?.photoURL != null
                                ? NetworkImage(user!.photoURL!)
                                : AssetImage('lib/assets/image/default_avatar.jpg')
                            as ImageProvider,
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Welcome, ${widget.name ?? user?.displayName ?? 'User'}",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          GestureDetector(
                            onTap: _launchTaejaePortal,
                            child: Text(
                              "Taejae University Portal",
                              style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.blue[800],
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  // 기능 버튼
                  _buildButton(
                    context,
                    'Select Class',
                    Icons.class_,
                    Colors.lightBlue[300]!,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClassSelectionScreen(
                            studentId: user!.uid,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  _buildButton(
                    context,
                    'View Feedback History',
                    Icons.history,
                    Colors.green[300]!,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FeedbackHistoryScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  _buildButton(
                    context,
                    'Log Out',
                    Icons.logout,
                    Colors.red[300]!,
                        () async {
                      await _auth.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                            (Route<dynamic> route) => false,
                      );
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton(
      BuildContext context,
      String text,
      IconData icon,
      Color backgroundColor,
      VoidCallback onPressed,
      ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              SizedBox(width: 16),
              Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
