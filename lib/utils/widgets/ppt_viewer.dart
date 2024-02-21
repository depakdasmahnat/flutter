import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PPTViewer extends StatelessWidget {
  const PPTViewer({super.key, this.url});

  final String? url;

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
      body: SfPdfViewer.network('$url'),
    );
  }
}
