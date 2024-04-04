import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfView extends StatelessWidget {
  final String url;

  const PdfView({required this.url});

  @override
  Widget build(BuildContext context) {
    return PDFView(
      filePath: url,
      autoSpacing: true,
      pageSnap: true,
      onError: (error) {
        print(error.toString());
      },
      onPageError: (page, error) {
        print('$page: ${error.toString()}');
      },
    );
  }
}
