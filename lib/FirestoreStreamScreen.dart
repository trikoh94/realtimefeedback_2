import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreStreamDataScreen extends StatefulWidget {
  @override
  _FirestoreStreamDataScreenState createState() =>
      _FirestoreStreamDataScreenState();
}

class _FirestoreStreamDataScreenState extends State<FirestoreStreamDataScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stream Data Example'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          // Firestore 데이터 처리
          final data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var user = data[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(user['name'] ?? 'Unknown Name'),
                subtitle: Text(user['email'] ?? 'Unknown Email'),
              );
            },
          );
        },
      ),
    );
  }
}
