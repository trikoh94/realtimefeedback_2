import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:realfeedback_2/screens/success_screen.dart';
import 'instruction_screen.dart'; // 파일명 변경 반영
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackScreen extends StatefulWidget {
  final List<Map<String, dynamic>> emojiFeedback;
  final int badgeLevel;
  final VoidCallback onViewStatistics;
  final String className;
  final String professor;
  final String classNum;

  FeedbackScreen({
    required this.emojiFeedback,
    required this.badgeLevel,
    required this.onViewStatistics,
    required this.className,
    required this.professor,
    required this.classNum,
  });

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  List<Map<String, dynamic>> emojiFeedback = [];
  final messageController = TextEditingController();
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  String selectedLabel = '';
  String selectedEmoji = '';
  String sessionId = '';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveFeedbackToFirestore(
      String emoji, String message, String label) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await _firestore.collection('feedbacks').add({
          'emoji': emoji,
          'message': message,
          'label': label,
          'timestamp': FieldValue.serverTimestamp(),
          'userId': user.uid,
          'sessionId': sessionId,
          'className': widget.className,
          'professor': widget.professor,
          'classNum': widget.classNum,
          'classId': widget.classNum,
        });
        print("Feedback saved to Firestore successfully");
      } else {
        print("User is not logged in");
      }
    } catch (e) {
      print("Error saving feedback to Firestore: $e");
    }
  }

  Future<void> getFeedbacksFromFirestore() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('feedbacks')
            .where('userId', isEqualTo: user.uid)
            .where('sessionId', isEqualTo: sessionId)
            .orderBy('timestamp', descending: true)
            .get();

        setState(() {
          emojiFeedback = querySnapshot.docs.map((doc) {
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
        });
      }
    } catch (e) {
      print("Error fetching feedbacks from Firestore: $e");
    }
  }

  void selectEmojiAndLabel(String emoji, String label) {
    setState(() {
      selectedEmoji = emoji;
      selectedLabel = label;
    });
  }

  void submitFeedback() {
    if (messageController.text.isEmpty || selectedLabel.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a message and select an emoji')),
      );
      return;
    }

    setState(() {
      final feedback = {
        'emoji': selectedEmoji,
        'message': messageController.text,
        'timestamp': DateTime.now(),
        'label': selectedLabel,
      };
      emojiFeedback.add(feedback);

      saveFeedbackToFirestore(
        selectedEmoji,
        messageController.text,
        selectedLabel,
      );

      messageController.clear();
      selectedLabel = '';
      selectedEmoji = '';
    });

    analytics.logEvent(
      name: 'feedback_submitted',
      parameters: {
        'emoji': selectedEmoji,
        'label': selectedLabel,
        'message': emojiFeedback.last['message'],
        'timestamp': formatTimestamp(emojiFeedback.last['timestamp']),
      },
    );
  }

  void goToSuccessScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SuccessScreen(
          emojiFeedback: emojiFeedback,
          badgeLevel: widget.badgeLevel,
          onViewStatistics: widget.onViewStatistics,
        ),
      ),
    );
  }

  String formatTimestamp(DateTime timestamp) {
    return DateFormat('yyyy-MM-dd HH:mm').format(timestamp);
  }

  @override
  void initState() {
    super.initState();
    sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    getFeedbacksFromFirestore();
  }

  Widget _buildEmojiButton(String emoji, String label) {
    final isSelected = selectedEmoji == emoji;

    return GestureDetector(
      onTap: () => selectEmojiAndLabel(emoji, label),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue[200] : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(10),
            child: Text(
              emoji,
              style: TextStyle(fontSize: 40),
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String emoji, String message, String label,
      DateTime timestamp) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Text(
          emoji,
          style: TextStyle(fontSize: 40),
        ),
        title: Text(message),
        subtitle: Text(
          '${formatTimestamp(timestamp)}\nLabel: $label',
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('${widget.className} Feedback', style: TextStyle(color: Colors.white)),
    actions: [
    IconButton(
    icon: Icon(Icons.info_outline),
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => InstructionScreen()),
    );
    },
    ),
    ],
    backgroundColor: Colors.blue[800],
    ),
    body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Center(
    child: Text(
    'How do you feel about ${widget.className}?',
    style: TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: Colors.blue[800],
    ),
    ),
    ),
    SizedBox(height: 10),
    Text(
    'Professor: ${widget.professor}, Class #: ${widget.classNum}',
    style: TextStyle(
    fontSize: 16,
    color: Colors.black54,
    ),
    ),
    SizedBox(height: 18),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
    _buildEmojiButton('😊', 'Understand'),
    _buildEmojiButton('🤩', 'Interested'),
    _buildEmojiButton('😕', 'Confused'),
    _buildEmojiButton('❓', 'Question'),
    _buildEmojiButton('✏️', 'Others'),
    ],
    ),
    SizedBox(height: 20),
    TextField(
    controller: messageController,
    decoration: InputDecoration(
    labelText: 'Leave a message',
    border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue[800]!, width: 2),
    ),
    ),
    ),
    SizedBox(height: 20),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    ElevatedButton(
    onPressed: submitFeedback,
    child: Text('Submit Feedback'),
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue[200],
    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
    textStyle:
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    ),
    ),
    SizedBox(width: 20),
    ElevatedButton(
    onPressed: goToSuccessScreen,
    child: Text('Class End'),
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.red[300],
    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 70),
    textStyle:
    TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30),
    ),
    ),
    ),
    ],
    ),
    SizedBox(height: 20),
    Text(
    'Your Feedback:',
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    Expanded(
    child: ListView.builder(
    itemCount: emojiFeedback.length,
    itemBuilder: (context, index) {
    final feedback = emojiFeedback[index];
    return _buildChatBubble(
    feedback['emoji'],
    feedback['message'],
    feedback['label'], feedback['timestamp'],
    );
    },
    ),
    ),
    ],
    ),
    ),
    );
  }
}
