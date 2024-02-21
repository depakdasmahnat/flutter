// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
//
// import 'package:get/get.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// import '../../../../../shared/controllers/user_controller.dart';
// import '../controllers/terms_and_condition_controller.dart';
//
// class TermsAndConditionsView extends GetView<TermsAndConditionsController> {
//   UserController userController = Get.put(UserController());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('WebView'),
//           centerTitle: true,
//         ),
//         body: Stack(
//           children: [
//           WebView(
//            initialUrl: 'about:blank', // Replace with the URL you want to load
//           javascriptMode: JavascriptMode.unrestricted, // Adjust the JavaScript mode as needed
//           onWebViewCreated: (WebViewController webViewController) {
//             webViewController.loadUrl(Uri.dataFromString(
//               userController.termandCondition.value,
//               mimeType: 'text/html',
//               // encoding: 'utf-8',
//             ).toString());
//           },
//           onPageFinished: (url) {
//             controller.isloading(true);
//             print("is loading ${ controller.isloading}");
//           },
//         ),
//             Obx(
//             () {
//                 return controller.isloading.value==false? Center(
//                   child: SpinKitCircle(
//                     color: Colors.red,
//                   ),
//                 ):Offstage();
//               }
//             )
//
//           ],
//         ));
//   }
// }stf
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mrwebbeast/core/services/api/api_service.dart';

class WebScreen extends StatefulWidget {
  String type;

  WebScreen({super.key, required this.type});

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  bool isLoading = false;
  String url = '';

  getTerm() async {
    try {
      var res = await http.get(
        Uri.parse('https://api.gtp.proapp.in/api/v1/${widget.type}'),
        headers: ApiService().defaultHeaders(),
      );
      print('check status code ${res.statusCode}');
      if (res.statusCode == 200) {
        setState(() {
          url = res.body;
        });
      }
    } catch (a) {
      print(a);
    }
  }

  // @override
  // void initState() {
  //   getTerm();
  //   if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Column()

        //     body:Stack(
        //     children:[
        //     if (url.isNotEmpty) // Only load WebView when the URL is not empty
        // WebView(
        //   // initialUrl: url,
        //   // javascriptMode: JavascriptMode.unrestricted,
        //   // gestureNavigationEnabled: true,
        //   // zoomEnabled: false,
        //   // userAgent: HttpHeaders.userAgentHeader,
        //   initialUrl: 'about:blank',
        //   javascriptMode: JavascriptMode.unrestricted,
        //   onWebViewCreated: (controller) {
        //     controller.loadUrl(Uri.dataFromString(
        //       url,
        //       mimeType: 'text/html',
        //     ).toString());
        //   },
        //   onPageStarted: (url) {
        //     setState(() {
        //       isLoading = false;
        //     });
        //   },
        //   onPageFinished: (url) {
        //     setState(() {
        //       isLoading = true;
        //     });
        //   },
        // )
        // ,
        // isLoading==false?Center(
        // child: CircularProgressIndicator(),
        // ):Offstage()
        // ]
        // )

        );
  }
}
