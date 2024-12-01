import 'package:flutter/material.dart';
import 'feedback_screen.dart';
import 'home_screen.dart'; // HomeScreen import

class ClassSelectionScreen extends StatefulWidget {
  final String studentId;

  ClassSelectionScreen({required this.studentId});

  @override
  _ClassSelectionScreenState createState() => _ClassSelectionScreenState();
}

class _ClassSelectionScreenState extends State<ClassSelectionScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Container(), // 첫 번째 페이지를 빈 화면으로 대체
    HomeScreen(), // HomeScreen
  ];

  final List<Map<String, String>> classes = [
    {'className': 'Economics 101', 'professor': 'Prof. Ham', 'classNum': '1'},
    {'className': 'Physics 101', 'professor': 'Prof. Lee', 'classNum': '2'},
    {'className': 'Design AI 101', 'professor': 'Prof. Kwack', 'classNum': '3'},
    {'className': 'Human Perspectives 101', 'professor': 'Prof. Jungseok Lee', 'classNum': '4'},
    {'className': 'Human Perspectives 102', 'professor': 'Prof. Hazard', 'classNum': '5'},
  ];

  void _onClassSelected(String className, String professor, String classNum) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FeedbackScreen(
          emojiFeedback: [],
          badgeLevel: 1,
          onViewStatistics: () {
            print("View Statistics Clicked");
          },
          className: className,
          professor: professor,
          classNum: classNum,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      // Home 탭 클릭 시 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.school, color: Colors.white),
            SizedBox(width: 8),
            Text('Select Class',  style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.blue[800],
      ),
      body: ListView.builder(
        itemCount: classes.length,
        itemBuilder: (context, index) {
          var classInfo = classes[index];
          return _buildClassButton(
            context,
            classNum: classInfo['classNum']!,
            professor: classInfo['professor']!,
            className: classInfo['className']!,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: 'Class Selection',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
        ],
        backgroundColor: Colors.blue[800],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: true,
      ),
    );
  }

  Widget _buildClassButton(BuildContext context, {
    required String classNum,
    required String professor,
    required String className,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        onTap: () => _onClassSelected(className, professor, classNum),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        tileColor: Colors.white,
        leading: Icon(Icons.class_, color: Colors.blue[800]),
        title: Text(
          className,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[800]),
        ),
        subtitle: Text(
          'Professor: $professor',
          style: TextStyle(fontSize: 14, color: Colors.blue[600]),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue[800]),
      ),
    );
  }
}
