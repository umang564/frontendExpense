import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/feature/GroupPage/group_bloc.dart';
import 'package:flutterproject/feature/utils/enums.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GroupDetailScreen extends StatefulWidget {
  const GroupDetailScreen({Key? key}) : super(key: key);

  @override
  _GroupDetailScreenState createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  late final GroupBloc _groupBloc = GroupBloc(); // Simplified initialization
  late String name;
  late int id;
  late int adminId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Extract arguments from the ModalRoute
    final Map<String, dynamic> args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    name = args['name'] as String;
    id = args['id'] as int;
    adminId = args['adminId'] as int;
  }

  @override
  void dispose() {
    _groupBloc.close(); // Properly close the bloc to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _groupBloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent, // Set the background color of the header
          elevation: 4.0, // Add some shadow to the header
          title: Text(
            name, // Display the user's name or a default title
            style: TextStyle(
              fontSize: 20.0, // Set the font size
              fontWeight: FontWeight.bold, // Make the text bold
              color: Colors.white, // Text color
            ),
          ),
          // Hide the back button if needed
        ),
        body: BlocListener<GroupBloc, GroupState>(
          listenWhen: (previous, current) => previous.deleteStatus != current.deleteStatus,
          listener: (context, state) {
            if (state.deleteStatus == DeleteStatus.success) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Deleted successfully')),
                );
              Navigator.pushNamed(context, '/home');
            }
          },
          child: BlocBuilder<GroupBloc, GroupState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/addMember',
                                arguments: {
                                  'name': name,
                                  'id': id,
                                  'adminId': adminId,
                                },
                              );
                            },
                            child: Card(
                              color: Colors.blue.shade50, // Set the card background color to blue shade 50
                              elevation: 2.0,
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16.0),
                                leading: Icon(Icons.people),
                                title: Text('Add Member'),
                                trailing: Icon(Icons.add),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/addexpense',
                                arguments: {
                                  'name': name,
                                  'id': id,
                                  'adminId': adminId,
                                },
                              );
                            },
                            child: Card(
                              color: Colors.blue.shade50, // Set the card background color to blue shade 50
                              elevation: 2.0,
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16.0),
                                leading: Icon(Icons.currency_exchange),
                                title: Text('Add Expense'),
                                trailing: Icon(Icons.add),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/viewMember',
                                arguments: {
                                  'name': name,
                                  'id': id,
                                  'adminId': adminId,
                                  'userId': state.current_user_id,
                                },
                              );
                            },
                            child: Card(
                              color: Colors.blue.shade50, // Set the card background color to blue shade 50
                              elevation: 2.0,
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16.0),
                                leading: Icon(Icons.group),
                                title: Text('Members & Exchange'),
                                trailing: Icon(Icons.search),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/details',
                                arguments: {
                                  'name': name,
                                  'id': id,
                                  'adminId': adminId,
                                },
                              );
                            },
                            child: Card(
                              color: Colors.blue.shade50, // Set the card background color to blue shade 50
                              elevation: 2.0,
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16.0),
                                leading: Icon(Icons.details),
                                title: Text('Group Details'),
                                trailing: Icon(Icons.details),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/SettledHistory',
                                arguments: {
                                  'name': name,
                                  'id': id,
                                  'adminId': adminId,
                                },
                              );
                            },
                            child: Card(
                              color: Colors.blue.shade50, // Set the card background color to blue shade 50
                              elevation: 2.0,
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16.0),
                                leading: Icon(Icons.details),
                                title: Text('Settle History'),
                                trailing: Icon(Icons.details),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final storage = FlutterSecureStorage();
                              String? x = await storage.read(key: 'current_user_id');

                              int? currentUserId;

                              if (x != null && x.isNotEmpty) {
                                currentUserId = int.tryParse(x);
                              }

                              if (currentUserId != null) {
                                print('Current user ID: $currentUserId');
                              } else {
                                print('Failed to parse user ID or ID is not set.');
                              }

                              if (currentUserId == adminId) {
                                context.read<GroupBloc>().add(DeleteGroup(groupid: id));
                              } else {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    const SnackBar(content: Text('Oops, you are not the admin')),
                                  );
                              }
                            },
                            child: Card(
                              color: Colors.blue.shade50, // Set the card background color to blue shade 50
                              elevation: 2.0,
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16.0),
                                leading: Icon(Icons.delete),
                                title: Text('Delete Group'),
                                trailing: Icon(Icons.delete),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
