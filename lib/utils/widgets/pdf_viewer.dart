import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewer extends StatelessWidget {
  const PDFViewer({super.key, this.pdfUrl});

  final String? pdfUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Column(
          children: [
            BackButton(),
          ],
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SfPdfViewer.network('$pdfUrl'),
    );
  }
}
