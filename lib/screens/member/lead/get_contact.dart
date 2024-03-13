

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:mrwebbeast/utils/widgets/loading_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../controllers/member/leads/leads_controllers.dart';

class ContactSelection {
  final String name;
  final String phoneNumber;

  ContactSelection(this.name, this.phoneNumber);
}


class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  late Future<List<Contact>> _loadContactsFuture;
  List<ContactSelection> _selectedContacts = [];
  List<Contact> contacts =[];
  bool? isLoading =false;
  @override
  void initState() {
    super.initState();
    _loadContactsFuture = _loadContacts();
  }

  Future<List<Contact>> _loadContacts() async {
    await _askPermissions();
    return ContactsService.getContacts().then((contacts) {

      return contacts.toList();
    }).catchError((e) {
      print('Error loading contacts: $e');
      return [];
    });
  }

  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus != PermissionStatus.granted) {
      _handleInvalidPermissions(permissionStatus);
    }
  }
  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus =
      await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      const snackBar = SnackBar(
          content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      const snackBar = SnackBar(
          content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              List data =[];
              for (var element in _selectedContacts) {
                data.add({
                  'name':element.name,
                  'mobile':element.phoneNumber,
                });
              }
              context.read<ListsControllers>().addLeadFromContacts(context: context, details: data);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  isLoading=false;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),

                border: OutlineInputBorder(),
              ),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Contact>>(
              future: _loadContactsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingScreen();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error loading contacts: ${snapshot.error}'),
                  );
                } else {
                contacts = snapshot.data ?? [];
                  return
                    ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      Contact contact = contacts[index];
                      bool isSelected = _selectedContacts.any((selectedContact) =>
                      selectedContact.phoneNumber == (contact.phones?.isNotEmpty==true ? contact.phones?.first.value : ''));
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(contact.givenName?.substring(0, 1) ?? ''),
                        ),
                        title: Text(contact.displayName ?? ''),
                        subtitle: Text(contact.phones?.isNotEmpty==true
                            ? contact.phones?.first.value ?? ''
                            : 'No phone number'),
                        trailing: Checkbox(
                          value: isSelected,
                          focusColor: MaterialStateColor.resolveWith((states) {
                            return Colors.black;
                          }),
                          // side: BorderSide.none,
                          activeColor: MaterialStateColor.resolveWith((states) {
                            return Colors.black;
                          }),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value != null && value) {
                                _selectedContacts.add(ContactSelection(
                                    contact.displayName ?? '',
                                    contact.phones?.isNotEmpty==true
                                        ? contact.phones?.first.value ?? ''
                                        : ''));
                              } else {
                                _selectedContacts.removeWhere((selectedContact) =>
                                selectedContact.phoneNumber ==
                                    (contact.phones?.isNotEmpty==true
                                        ? contact.phones?.first.value
                                        : ''));
                              }
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedContacts.removeWhere((selectedContact) =>
                              selectedContact.phoneNumber ==
                                  (contact.phones?.isNotEmpty==true
                                      ? contact.phones?.first.value
                                      : ''));
                            } else {
                              _selectedContacts.add(ContactSelection(
                                  contact.displayName ?? '',
                                  contact.phones?.isNotEmpty==true
                                      ? contact.phones?.first.value ?? ''
                                      : ''));
                            }
                          });
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
