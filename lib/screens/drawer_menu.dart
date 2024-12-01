// drawer_menu.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'class_selection_screen.dart';
import 'feedback_screen.dart';  // FeedbackScreen을 임포트

class DrawerMenu extends StatelessWidget {
  final User? user;

  DrawerMenu({required this.user});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text(
            'App Menu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ListTile(
          title: Text('Export CSV'),
          onTap: () {
            // CSV 내보내기 화면으로 이동
          },
        ),
        ListTile(
          title: Text('Select Class'),
          onTap: () {
            if (user != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassSelectionScreen(
                    studentId: user!.uid, // Pass user ID
                  ),
                ),
              );
            }
          },
        ),
        ListTile(
          title: Text('Provide Feedback'),
          onTap: () {
            // 기존 피드백 데이터가 있을 경우 전달하고, 없으면 빈 리스트를 전달
            List<Map<String, dynamic>> feedbackData = []; // 빈 데이터 예시
            int badgeLevel = 1; // 예시 배지 레벨
            VoidCallback onViewStatistics = () {
              // 통계 보기 콜백 (필요한 기능 구현)
              print("View Statistics");
            };

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FeedbackScreen(
                  emojiFeedback: feedbackData, // 피드백 데이터
                  badgeLevel: badgeLevel,      // 배지 레벨
                  onViewStatistics: onViewStatistics, className: '', professor: '', classNum: '',  // 통계 보기 콜백
                ),
              ),
            );
          },
        )

      ],
    );
  }
}
