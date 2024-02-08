// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
//
// class NetworkSensitive extends StatelessWidget {
//   final Widget child;
//
//
//   NetworkSensitive({
//     this.child,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     var connectionStatus = Provider.of<ConnectivityStatus>(context);
//
//     if (connectionStatus == ConnectivityStatus.WiFi) {
//       return child;
//     }
//
//     if (connectionStatus == ConnectivityStatus.Cellular) {
//       return Container(child: Text('Koneksi Mobile'), );
//     }
//
//     if (connectionStatus == ConnectivityStatus.Offline) {
//       return Container(child: Text('Koneksi Offline'), );
//     }
//   }
// }