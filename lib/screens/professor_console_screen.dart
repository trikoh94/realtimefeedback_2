  import 'package:flutter/material.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:intl/intl.dart';

  class ProfessorConsoleScreen extends StatelessWidget {
    final String classId;

    ProfessorConsoleScreen({required this.classId, required String sessionId, required String className, required String professor});

    @override
    Widget build(BuildContext context) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      return Scaffold(
        appBar: AppBar(
          title: Text('Feedback Console'),
          backgroundColor: Colors.blue[800],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _firestore
              .collection('feedbacks')
              .where('classId', isEqualTo: classId)
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final feedbackDocs = snapshot.data?.docs ?? [];

            if (feedbackDocs.isEmpty) {
              return Center(
                child: Text(
                  'No feedbacks yet.',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              );
            }

            return ListView.builder(
              itemCount: feedbackDocs.length,
              itemBuilder: (context, index) {
                final feedbackData = feedbackDocs[index].data();

                final emoji = feedbackData['emoji'] ?? '😐';
                final message = feedbackData['message'] ?? 'No message provided.';
                final label = feedbackData['label'] ?? 'Unknown';
                final timestamp = feedbackData['timestamp'] is Timestamp
                    ? (feedbackData['timestamp'] as Timestamp).toDate()
                    : DateTime.now(); // 기본값 설정

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: Text(
                      emoji,
                      style: TextStyle(fontSize: 40),
                    ),
                    title: Text(
                      message,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${DateFormat('yyyy-MM-dd HH:mm').format(timestamp)}\nLabel: $label',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    }
  }
