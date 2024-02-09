import 'package:flutter/material.dart';
import 'package:gaas/utils/widgets/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
            debugPrint("Progress is $progress");
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
      ..loadRequest(Uri.parse(widget.url ?? "www.google.com"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              backButton(context: context),
            ],
          ),
          leadingWidth: 50,
          title: Text(widget.title ?? "Google"),
          centerTitle: true,
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            WebViewWidget(
              controller: controller,
            ),
            if (isLoading == true) const CircularProgressIndicator()
          ],
        ));
  }
}
