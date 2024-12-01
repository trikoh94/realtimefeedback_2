import 'package:flutter/material.dart';
import 'export_service.dart';

class ExportScreen extends StatelessWidget {
  final ExportService _exportService = ExportService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Export Data')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await _exportService.exportCsvForWeb();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('CSV 다운로드 완료!')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('오류 발생: $e')),
              );
            }
          },
          child: Text('Export Data to CSV'),
        ),
      ),
    );
  }
}
