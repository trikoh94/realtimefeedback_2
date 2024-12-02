import 'package:flutter/material.dart';
import 'professor_console_screen.dart'; // ProfessorConsoleScreen import
import 'feedback_statistics_page.dart'; // Statistics Screen Import

class ProfessorUserPage extends StatefulWidget {
  final String professorName;
  final String className;
  final String classNum;
  final String classId;

  ProfessorUserPage({
    required this.professorName,
    required this.className,
    required this.classNum,
    required this.classId,
  });

  @override
  _ProfessorUserPageState createState() => _ProfessorUserPageState();
}

class _ProfessorUserPageState extends State<ProfessorUserPage> {
  List<Map<String, dynamic>> classFeedback = [];

  // 피드백 데이터를 받아오는 함수 (예시)
  void _loadFeedbackData() {
    // 예시: 실제 데이터를 Firebase나 다른 곳에서 불러오는 로직
    setState(() {
      classFeedback = [
        {'emoji': '🙂', 'timestamp': '2024-12-01 12:00'},
        {'emoji': '😢', 'timestamp': '2024-12-01 12:05'},
        {'emoji': '🙂', 'timestamp': '2024-12-01 12:10'},
        // 추가 피드백 데이터
      ];
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFeedbackData(); // 초기 데이터 로딩
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Professor Profile'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center( // 중앙 정렬을 위해 Center 위젯 추가
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 세로로 중앙 정렬
            crossAxisAlignment: CrossAxisAlignment.center, // 가로로 중앙 정렬
            children: [
              // Real-time Feedback 강조
              Text(
                'Real-time Feedback',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              SizedBox(height: 20),
              Icon(
                Icons.person,
                size: 100,
                color: Colors.blue[800],
              ),
              SizedBox(height: 10),
              Text(
                'Professor: ${widget.professorName}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Class: ${widget.className}',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              SizedBox(height: 8),
              Text(
                'Class Number: ${widget.classNum}',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 40),

              // Button to Navigate to Feedback Console
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfessorConsoleScreen(
                        classId: widget.classId,
                        sessionId: 'session1',
                        className: widget.className,
                        professor: widget.professorName,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Go to Feedback Console',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),

              // Statistics Button to View Feedback Stats
              ElevatedButton(
                onPressed: () {
                  // Navigate to statistics screen with class feedback data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StatisticsScreen(
                        className: widget.className,
                        classFeedback: classFeedback,
                        classFeedbackMap: {},
                        emojiFeedback: classFeedback.map((e) => e['emoji']).toList(),
                        classId: widget.classId, // 전달된 피드백 데이터
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'View Feedback Statistics',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
