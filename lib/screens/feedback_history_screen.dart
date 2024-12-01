import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackHistoryScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getFeedbackHistory() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      QuerySnapshot querySnapshot = await _firestore
          .collection('feedbacks')
          .where('userId', isEqualTo: user.uid) // 전체 히스토리 가져오기
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'emoji': data['emoji'] ?? '😐',
          'message': data['message'] ?? '',
          'label': data['label'] ?? 'Unknown',
          'timestamp': data['timestamp'] != null
              ? (data['timestamp'] as Timestamp).toDate()
              : DateTime.now(),
        };
      }).toList();
    }

    return [];
  }

  String formatTimestamp(DateTime timestamp) {
    return DateFormat('yyyy-MM-dd HH:mm').format(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback History'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getFeedbackHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final history = snapshot.data ?? [];

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final feedback = history[index];
              return ListTile(
                leading: Text(feedback['emoji'], style: TextStyle(fontSize: 32)),
                title: Text(feedback['message']),
                subtitle: Text(
                  formatTimestamp(feedback['timestamp']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
