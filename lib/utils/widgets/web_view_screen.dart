import 'package:flutter/material.dart';
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
<<<<<<< HEAD
  WebViewController controller = WebViewController();
=======
  // WebViewController controller = WebViewController();
>>>>>>> guestUI

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
<<<<<<< HEAD
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
      ..loadRequest(Uri.parse(widget.url ?? 'www.google.com'));
  }
=======
  // void initState() {
  //   super.initState();
  //   controller = WebViewController()
  //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //     ..setNavigationDelegate(
  //       NavigationDelegate(
  //         onProgress: (int progress) {
  //           debugPrint('Progress is $progress');
  //         },
  //         onPageStarted: (String url) {},
  //         onPageFinished: (String url) {
  //           setState(() {
  //             isLoading = false;
  //           });
  //         },
  //         onWebResourceError: (WebResourceError error) {},
  //         onNavigationRequest: (NavigationRequest request) async {
  //           await _launchURL(request.url);
  //           return NavigationDecision.prevent;
  //         },
  //       ),
  //     )
  //     ..loadRequest(Uri.parse(widget.url ?? 'www.google.com'));
  // }
>>>>>>> guestUI

  @override
  Widget build(BuildContext context) {
    debugPrint('Web Url :- ${widget.url}');
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          elevation: 0,
          title: Text(widget.title ?? 'Google'),
          centerTitle: true,
          snap: true,
          pinned: true,
          floating: true,
          expandedHeight: 230,
        ),
        SliverFillRemaining(
          child: Stack(
            alignment: Alignment.center,
            children: [
<<<<<<< HEAD
              WebViewWidget(
                controller: controller,
              ),
=======
              // WebViewWidget(
              //   controller: controller,
              // ),
>>>>>>> guestUI
              if (isLoading == true) const CircularProgressIndicator(),
            ],
          ),
        ),
      ],
    );
  }
}
