import 'package:flutter/material.dart';
// Import the file where FeedbackScreen is defined
import 'package:realfeedback_2/screens/feedback_screen.dart';

class ClassInfoScreen extends StatelessWidget {
  final int classNum;
  final String professor;

  ClassInfoScreen({required this.classNum, required this.professor, required String studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class $classNum Information', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Professor: $professor',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Text(
                'Class Information:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Class $classNum - ${_getClassName(classNum)}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue[800],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeedbackScreen(
                        emojiFeedback: [], // Provide an empty list or populated list as needed
                        badgeLevel: 1, // Set a default badge level (e.g., 1)
                        onViewStatistics: () {
                          // Define an action for viewing statistics or leave empty
                        }, className: '', professor: '', classNum: '',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800], // Button color
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  'Give Feedback',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getClassName(int classNum) {
    switch (classNum) {
      case 1:
        return 'Economics';
      case 2:
        return 'Physics';
      case 3:
        return 'AI Design';
      default:
        return 'Human Perspective';
    }
  }
}
