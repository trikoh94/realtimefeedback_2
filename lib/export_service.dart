import 'dart:html' as html; // 이름 충돌 방지
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ExportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Firestore 데이터를 가져와 CSV로 변환 후 브라우저에서 다운로드
  Future<void> exportCsvForWeb() async {
    try {
      // Firestore에서 데이터 가져오기
      final querySnapshot = await _firestore.collection('feedbacks').get();
      final docs = querySnapshot.docs;

      if (docs.isEmpty) throw Exception('데이터가 없습니다.');

      // CSV 헤더 생성
      List<String> headers = docs.first.data().keys.toList();
      StringBuffer csv = StringBuffer(headers.join(',') + '\n');

      // CSV 본문 생성
      for (var doc in docs) {
        csv.writeln(doc.data().values.map((value) => _formatValue(value)).join(','));
      }

      // CSV를 브라우저에서 다운로드
      final html.Blob blob = html.Blob([csv.toString()]); // dart:html의 Blob 사용
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = 'data_export_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv'
        ..click();
      html.Url.revokeObjectUrl(url); // URL 해제
    } catch (e) {
      throw Exception('CSV 생성 중 오류 발생: $e');
    }
  }

  /// 값 포맷팅 (특히 날짜 처리)
  String _formatValue(dynamic value) {
    if (value is Timestamp) {
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(value.toDate());
    } else if (value is String && value.contains(',')) {
      return '"$value"'; // 쉼표가 포함된 문자열은 따옴표로 감싸기
    }
    return value?.toString() ?? '';
  }
}
