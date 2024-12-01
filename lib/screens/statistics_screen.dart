import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> emojiFeedback;

  StatisticsScreen({required this.emojiFeedback});

  @override
  Widget build(BuildContext context) {
    // Calculate statistics
    final emojiCounts = _getEmojiCounts(emojiFeedback);
    final sadFeedbackTimestamps = _getSadFeedbackTimestamps(emojiFeedback);

    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Statistics'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Feedback Breakdown 📊',
              style: Theme.of(context).textTheme.headlineSmall,
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
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.blueAccent,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final emoji = emojiCounts.keys.elementAt(groupIndex);
                        final count = rod.toY.toInt();
                        final total = emojiFeedback.length;
                        final percentage = (count / total * 100).toStringAsFixed(1);
                        return BarTooltipItem(
                          '$emoji: $count feedbacks\n$percentage%',
                          TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildLegend(emojiCounts),
            SizedBox(height: 16),
            _buildChallengePart(sadFeedbackTimestamps),
          ],
        ),
      ),
    );
  }

  // Calculate emoji feedback counts
  Map<String, int> _getEmojiCounts(List<Map<String, dynamic>> feedback) {
    final emojiCounts = <String, int>{};
    for (final item in feedback) {
      final emoji = item['emoji'];
      emojiCounts[emoji] = (emojiCounts[emoji] ?? 0) + 1;
    }
    return emojiCounts;
  }

  // Extract timestamps for feedback marked with "sad" emoji
  List<String> _getSadFeedbackTimestamps(List<Map<String, dynamic>> feedback) {
    return feedback
        .where((item) => item['emoji'] == '🤔❓') // Assuming 😢 represents "sad"
        .map((item) => item['timestamp'].toString()) // Convert timestamp to string if necessary
        .toList();
  }

  // Get maximum count for chart Y-axis limit
  double _getMaxCount(Map<String, int> emojiCounts) {
    return emojiCounts.values.isNotEmpty
        ? emojiCounts.values.reduce((max, value) => max > value ? max : value).toDouble()
        : 1.0;
  }

  // Create data for each bar in the chart
  List<BarChartGroupData> _createBarGroups(Map<String, int> emojiCounts) {
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.red, Colors.purple];
    int colorIndex = 0;

    return emojiCounts.entries.map((entry) {
      final index = emojiCounts.keys.toList().indexOf(entry.key);
      final count = entry.value.toDouble();

      // Cycle through colors if there are more emojis than colors
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
        showingTooltipIndicators: [0],
      );
    }).toList();
  }

  // Build a legend for the chart
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

  // Map emoji to color based on its index
  Color _getEmojiColor(String emoji) {
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.red, Colors.purple];
    final index = emoji.hashCode % colors.length;
    return colors[index];
  }

  // Build Challenge Part section with timestamps for "sad" feedback
  Widget _buildChallengePart(List<String> timestamps) {
    if (timestamps.isEmpty) return SizedBox.shrink(); // No sad feedback, so hide this section

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Challenge Part',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
          ),
        ),
        SizedBox(height: 8),
        ...timestamps.map((timestamp) => Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            '• $timestamp',
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        )),
      ],
    );
  }
}
