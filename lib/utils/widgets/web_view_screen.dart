import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/services/api/api_service.dart';
import 'appbar.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key, this.title, this.url}) : super(key: key);
  final String? title;
  final String? url;

  @override
  WebViewScreenState createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {
  bool isLoading = true;
  WebViewController controller = WebViewController();
  _launchURL(String url) async {
    try {
      await launchUrlString(
        url,
        mode: LaunchMode.externalApplication,
      );

      debugPrint('Launching $url');
    } catch (e, s) {
      debugPrint('Url Launch Error $e & $s');
    }
  }
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('Progress is $progress');
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            await _launchURL(request.url);
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url ?? 'www.google.com'), headers: ApiService().defaultHeaders());
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(size.height * 0.06),
            child: CustomAppBar(
              showLeadICon: true,
              title: widget.title,
            )),
      body:Stack(
        children: [
          WebViewWidget(
            controller: controller,
          ),
          if (isLoading == true) const Center(child: CircularProgressIndicator()),
        ],
      )

    );
  }
}
