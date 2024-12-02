import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends StatelessWidget {
  final String classId;

  StatisticsScreen({required this.classId, required String className, required List<Map<String, dynamic>> classFeedback, required Map classFeedbackMap, required List emojiFeedback});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Statistics'),
        backgroundColor: Colors.blue[800],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestore
            .collection('feedbacks')
            .where('classId', isEqualTo: classId) // classId에 해당하는 피드백만 가져오기
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

          // 이모지 통계 계산
          final emojiCounts = _getEmojiCounts(feedbackDocs);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Feedback Breakdown 📊',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 16),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: _getMaxCount(emojiCounts) * 1.3,
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final emojis = emojiCounts.keys.toList();
                              if (value >= 0 && value < emojis.length) {
                                return Text(
                                  emojis[value.toInt()],
                                  style: TextStyle(fontSize: 20),
                                );
                              }
                              return Text('');
                            },
                            reservedSize: 30,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              return Text(value.toInt().toString());
                            },
                          ),
                        ),
                      ),
                      gridData: FlGridData(
                        drawHorizontalLine: true,
                        drawVerticalLine: false,
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          bottom: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      barGroups: _createBarGroups(emojiCounts),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                _buildLegend(emojiCounts),
              ],
            ),
          );
        },
      ),
    );
  }

  // 피드백 데이터에서 이모지별로 통계 계산
  Map<String, int> _getEmojiCounts(List<QueryDocumentSnapshot<Map<String, dynamic>>> feedbackDocs) {
    final emojiCounts = <String, int>{};

    for (final doc in feedbackDocs) {
      final feedbackData = doc.data();
      final emoji = feedbackData['emoji'] ?? '😐';
      emojiCounts[emoji] = (emojiCounts[emoji] ?? 0) + 1;
    }

    return emojiCounts;
  }

  // 최대 피드백 수로 Y축 크기 결정
  double _getMaxCount(Map<String, int> emojiCounts) {
    return emojiCounts.values.isNotEmpty
        ? emojiCounts.values.reduce((max, value) => max > value ? max : value).toDouble()
        : 1.0;
  }

  // 바 차트를 위한 데이터 생성
  List<BarChartGroupData> _createBarGroups(Map<String, int> emojiCounts) {
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.red, Colors.purple];
    int colorIndex = 0;

    return emojiCounts.entries.map((entry) {
      final index = emojiCounts.keys.toList().indexOf(entry.key);
      final count = entry.value.toDouble();

      final color = colors[colorIndex % colors.length];
      colorIndex++;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: count,
            color: color,
            width: 20,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: _getMaxCount(emojiCounts) * 1.3,
              color: Colors.grey[200],
            ),
          ),
        ],
      );
    }).toList();
  }

  // 피드백의 이모지 레전드 생성
  Widget _buildLegend(Map<String, int> emojiCounts) {
    return Wrap(
      spacing: 12,
      children: emojiCounts.keys.map((emoji) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 6,
              backgroundColor: _getEmojiColor(emoji),
            ),
            SizedBox(width: 4),
            Text(emoji),
          ],
        );
      }).toList(),
    );
  }

  // 이모지에 맞는 색상 반환
  Color _getEmojiColor(String emoji) {
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.red, Colors.purple];
    final index = emoji.hashCode % colors.length;
    return colors[index];
  }
}
