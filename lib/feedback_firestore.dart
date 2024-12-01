import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackFirestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 피드백 저장하는 메서드
  Future<void> saveFeedback(String emoji, String message, String label) async {
    try {
      await _firestore.collection('feedbacks').add({
        'emoji': emoji,
        'message': message,
        'label': label,
        'timestamp': FieldValue.serverTimestamp(), // 서버 타임스탬프 저장
      });
      print("Feedback saved successfully");
    } catch (e) {
      print("Error saving feedback: $e");
    }
  }

  // 피드백 데이터를 Firestore에서 조회하는 메서드 (예시)
  Future<List<Map<String, dynamic>>> getFeedbacks() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('feedbacks').get();
      List<Map<String, dynamic>> feedbackList = querySnapshot.docs.map((doc) {
        // 타임스탬프가 null인 경우 처리 (기본값으로 현재 시간 사용)
        Timestamp timestamp = doc['timestamp'] ?? Timestamp.now();
        DateTime dateTime = timestamp.toDate();

        return {
          'emoji': doc['emoji'],
          'message': doc['message'],
          'label': doc['label'],
          'timestamp': dateTime,  // 타임스탬프를 DateTime 객체로 변환
        };
      }).toList();
      return feedbackList;
    } catch (e) {
      print("Error getting feedbacks: $e");
      return [];
    }
  }
}
