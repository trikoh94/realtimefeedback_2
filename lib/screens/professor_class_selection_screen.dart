import 'package:flutter/material.dart';
import 'login_screen.dart'; // 로그인 화면 import
import 'professor_user_page.dart'; // 교수 전용 페이지

class ProfessorClassSelectionScreen extends StatefulWidget {
  final String professorName;

  ProfessorClassSelectionScreen({required this.professorName});

  @override
  _ProfessorClassSelectionScreenState createState() =>
      _ProfessorClassSelectionScreenState();
}

class _ProfessorClassSelectionScreenState
    extends State<ProfessorClassSelectionScreen> {
  final List<Map<String, String>> classes = [
    {'className': 'Economics 101', 'professor': 'Prof. Ham', 'classNum': '1'},
    {'className': 'Physics 101', 'professor': 'Prof. Lee', 'classNum': '2'},
    {'className': 'Design AI 101', 'professor': 'Prof. Kwack', 'classNum': '3'},
    {'className': 'Human Perspectives 101', 'professor': 'Prof. Jungseok Lee', 'classNum': '4'},
    {'className': 'Human Perspectives 102', 'professor': 'Prof. Hazard', 'classNum': '5'},
  ];

  void _onClassSelected(String className, String classNum, String professorName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfessorUserPage(
          professorName: professorName, // Pass professor name
          className: className,
          classNum: classNum,
          classId: classNum, // You can modify this as needed
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.class_, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Select Your Class',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.blue[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // 로그인 화면으로 돌아가기
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()), // 로그인 화면으로 이동
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: classes.length,
          itemBuilder: (context, index) {
            var classInfo = classes[index];
            return _buildClassButton(
              context,
              classNum: classInfo['classNum']!,
              className: classInfo['className']!,
              professorName: classInfo['professor']!,
            );
          },
        ),
      ),
    );
  }

  Widget _buildClassButton(BuildContext context, {
    required String classNum,
    required String className,
    required String professorName,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: ListTile(
        onTap: () => _onClassSelected(className, classNum, professorName),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        tileColor: Colors.white,
        leading: Icon(Icons.class_, color: Colors.blue[800], size: 30),
        title: Text(
          className,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue[800]),
      ),
    );
  }
}
