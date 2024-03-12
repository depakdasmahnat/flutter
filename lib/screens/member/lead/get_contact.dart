//
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:mrwebbeast/screens/guest/guest_check_demo/guest_check_demo_step2.dart';
// import 'package:mrwebbeast/utils/widgets/loading_screen.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// // class ContactsPage extends StatefulWidget {
// //   const ContactsPage({super.key});
// //
// //   @override
// //   _ContactsPageState createState() => _ContactsPageState();
// // }
// //
// // class _ContactsPageState extends State<ContactsPage> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     _askPermissions();
// //   }
// //
// //   Future<void> _askPermissions() async {
// //     PermissionStatus permissionStatus = await _getContactPermission();
// //     if (permissionStatus != PermissionStatus.granted) {
// //       _handleInvalidPermissions(permissionStatus);
// //     }
// //   }
// //
// //   Future<PermissionStatus> _getContactPermission() async {
// //     PermissionStatus permission = await Permission.contacts.status;
// //     if (permission != PermissionStatus.granted &&
// //         permission != PermissionStatus.permanentlyDenied) {
// //       PermissionStatus permissionStatus = await Permission.contacts.request();
// //       return permissionStatus;
// //     } else {
// //       return permission;
// //     }
// //   }
// //   _getNumber(){
// //     ContentResolver cr = getActivity().getContentResolver();
// //     Cursor cur = cr.query(ContactsContract.Contacts.CONTENT_URI, null, null, null, null);
// //     if (cur.getCount() > 0) {
// //       while (cur.moveToNext()) {
// //         String id = cur.getString(cur.getColumnIndex(
// //             ContactsContract.Contacts._ID));
// //         String name = cur.getString(cur.getColumnIndex(
// //             ContactsContract.Contacts.DISPLAY_NAME));
// //         if (Integer.parseInt(cur.getString(cur.getColumnIndex(
// //             ContactsContract.Contacts.HAS_PHONE_NUMBER))) > 0) {
// //           Cursor pCur = cr.query(
// //               ContactsContract.CommonDataKinds.Phone.CONTENT_URI,
// //               null,
// //               ContactsContract.CommonDataKinds.Phone.CONTACT_ID +" = ?",
// //               new String[]{id}, null);
// //           while (pCur.moveToNext()) {
// //             int phoneType = pCur.getInt(pCur.getColumnIndex(
// //                 ContactsContract.CommonDataKinds.Phone.TYPE));
// //             String phoneNumber = pCur.getString(pCur.getColumnIndex(
// //                 ContactsContract.CommonDataKinds.Phone.NUMBER));
// //             switch (phoneType) {
// //               case Phone.TYPE_MOBILE:
// //                 Log.e(name + "(mobile number)", phoneNumber);
// //                 break;
// //               case Phone.TYPE_HOME:
// //                 Log.e(name + "(home number)", phoneNumber);
// //                 break;
// //               case Phone.TYPE_WORK:
// //                 Log.e(name + "(work number)", phoneNumber);
// //                 break;
// //               case Phone.TYPE_OTHER:
// //                 Log.e(name + "(other number)", phoneNumber);
// //                 break;
// //               default:
// //                 break;
// //             }
// //           }
// //           pCur.close();
// //         }
// //       }
// //     }
// //
// // }
// //
// //   void _handleInvalidPermissions(PermissionStatus permissionStatus) {
// //     if (permissionStatus == PermissionStatus.denied) {
// //       const snackBar = SnackBar(content: Text('Access to contact data denied'));
// //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
// //     } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
// //       const snackBar =
// //       SnackBar(content: Text('Contact data not available on device'));
// //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
// //     }
// //   }
// //
// //   Future<List<Contact>>? reqContact;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Contacts List'),
// //       ),
// //       body: Column(
// //         children: [
// //           ElevatedButton(
// //               onPressed: () {
// //                 setState(() {
// //                   reqContact = ContactsService.getContacts();
// //                 });
// //               },
// //               child: const Text("Load Contact")),
// //           Expanded(
// //               child: FutureBuilder(
// //                   future: reqContact,
// //                   builder: (context, snp) {
// //                     if (snp.connectionState == ConnectionState.done) {
// //                       var contacts = snp.data;
// //
// //                       if (contacts != null) {
// //                         return ListView.builder(
// //                             shrinkWrap: true,
// //                             itemCount: contacts.length,
// //                             itemBuilder: (context, index) {
// //                               Contact contact = contacts[index];
// //
// //                               return ListTile(
// //
// //                                   title: Text(' ${contact.displayName}'),
// //                                   subtitle: Text(contact.phones?.single.value.toString()??
// //                                       'not found'));
// //                             });
// //                       }
// //                       return Container();
// //                     }
// //                     return Container();
// //                   })),
// //         ],
// //       ),
// //     );
// //   }
// // }
// class ContactsPage extends StatefulWidget {
//   @override
//   _ContactsPageState createState() => _ContactsPageState();
// }
//
// class _ContactsPageState extends State<ContactsPage> {
//
//
//
//   bool? isLoading = true;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getContactPermission();
//   }
//
//   void getContactPermission() async {
//     if (await Permission.contacts.isGranted) {
//       fetchContacts();
//       // contacts = await getDeviceDetails();
//     } else {
//       await Permission.contacts.request();
//     }
//   }
//
//
//   void fetchContacts() async {
//     contacts = await ContactsService.getContacts();
//
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: CustomText1(text: 'Contact',fontSize: 17,fontWeight: FontWeight.w600),
//       ),
//       body: isLoading==true
//           ? const LoadingScreen()
//           :
//       ListView.builder(
//         itemCount: contacts.length,
//         itemBuilder: (context, index) {
//           // Contact? contact = contacts[index];
//           // List<Item> phoneNumbers = contact?.phones?.toList()??[];
//           return Column(
//             children: [
//               ListTile(
//                 title: Text(' ${contacts[index]}'),
//                 // subtitle: Column(
//                 //   crossAxisAlignment: CrossAxisAlignment.start,
//                 //   children: phoneNumbers.map((Item phoneNumber) {
//                 //     return Text('${contacts[index].phones?[0].value}');
//                 //   }).toList(),
//                 // ),
//               ),
//
//               const Divider(
//                 height: 1,
//                 thickness: 1,
//                 color: Color(0xFF3B3B3B),
//               )
//             ],
//           );
//         },
//       ),
//     );
//   }
// }