import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/feature/GroupPage/group_bloc.dart';
import 'package:flutterproject/feature/utils/enums.dart';

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
          title: Text(name),
        ),
        body: BlocBuilder<GroupBloc, GroupState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.people),
                          title: Text('Add Member'),
                          trailing: ElevatedButton(
                            onPressed: () {
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
                            child: Icon(Icons.add),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.currency_exchange),
                          title: Text('Add Expense'),
                          trailing: ElevatedButton(
                            onPressed: () {
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
                            child: Icon(Icons.add),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.group),
                          title: Text('Members & Exchange'),
                          trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/viewMember',
                                arguments: {
                                  'name': name,
                                  'id': id,
                                  'adminId': adminId,
                                },
                              );
                            },
                            child: Icon(Icons.search),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.details),
                          title: Text('Group Details'),
                          trailing: ElevatedButton(
                            onPressed: () {
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
                            child: Icon(Icons.details),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.delete),
                          title: Text('Delete Group'),
                          trailing: ElevatedButton(
                            onPressed: () {
                              context
                                  .read<GroupBloc>()
                                  .add(DeleteGroup(groupid: id));
                              if(state.deleteStatus==DeleteStatus.success) {
                                Navigator.pushNamed(context, '/home');
                              }
                            },
                            child: Icon(Icons.delete),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Define your action here
          },
          child: const Icon(Icons.add),
          tooltip: 'Add new',
        ),
      ),
    );
  }
}
