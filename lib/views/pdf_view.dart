import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class PdfView extends StatefulWidget {
  final String url;

  PdfView({required this.url});

  @override
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);
  final ValueNotifier<int> _totalPages = ValueNotifier<int>(0);
  PDFViewController? _pdfViewController;

  Future<String> getFilePath() async {
    var file = await DefaultCacheManager().getSingleFile(widget.url);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getFilePath(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('MyLibrary PDF gratuit'),
            ),
            body: Stack(
              children: <Widget>[
                PDFView(
                  filePath: snapshot.data!,
                  onViewCreated: (PDFViewController pdfViewController) {
                    _pdfViewController = pdfViewController;
                  },
                  onPageChanged: (int? page, int? total) {
                    _currentPage.value = page ?? _currentPage.value;
                    _totalPages.value = total ?? _totalPages.value;
                  },
                  onError: (error) {
                    print(error.toString());
                  },
                  onPageError: (page, error) {
                    print('$page: ${error.toString()}');
                  },
                ),
              ],
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const Offstage(),
                  ValueListenableBuilder<int>(
                    valueListenable: _currentPage,
                    builder: (context, value, child) {
                      return value > 0
                          ? FloatingActionButton(
                              child: const Icon(Icons.arrow_back),
                              onPressed: () {
                                _currentPage.value -= 1;
                                _pdfViewController!.setPage(_currentPage.value);
                              },
                            )
                          : const Offstage();
                    },
                  ),
                  ValueListenableBuilder<int>(
                    valueListenable: _currentPage,
                    builder: (context, value, child) {
                      return Text('${value + 1} / ${_totalPages.value}');
                    },
                  ),
                  ValueListenableBuilder<int>(
                    valueListenable: _currentPage,
                    builder: (context, value, child) {
                      return value + 1 < _totalPages.value
                          ? FloatingActionButton(
                              child: const Icon(Icons.arrow_forward),
                              onPressed: () {
                                _currentPage.value += 1;
                                _pdfViewController!.setPage(_currentPage.value);
                              },
                            )
                          : const Offstage();
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}