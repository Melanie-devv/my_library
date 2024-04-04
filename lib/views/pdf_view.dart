import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class PdfView extends StatelessWidget {
  final String url;

  PdfView({required this.url});

  Future<String> getFilePath() async {
    var file = await DefaultCacheManager().getSingleFile(url);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getFilePath(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('MyLibrary PDF'),
            ),
            body: PDFView(
              filePath: snapshot.data!,
              onViewCreated: (PDFViewController pdfViewController) {
                pdfViewController.setPage(0);
              },
              onError: (error) {
                print(error.toString());
              },
              onPageError: (page, error) {
                print('$page: ${error.toString()}');
              },
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}