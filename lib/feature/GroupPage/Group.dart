import 'package:flutter/material.dart';

class GroupDetailScreen extends StatefulWidget {
  const GroupDetailScreen({Key? key}) : super(key: key);

  @override
  _GroupDetailScreenState createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Expanded(
              child: ListView(
                children:  <Widget>[
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text('Add member'),
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
                    title: Text('Add expense'),
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
                    leading: Icon(Icons.group),
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
                    leading: Icon(Icons.group),
                    title: Text('Delete group'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/delete',
                          arguments: {
                            'name': name,
                            'id': id,
                            'adminId': adminId,
                          },
                        );
                      },
                      child: Icon(Icons.delete),
                    ),

                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Define your action here
          // For example, you can navigate to another screen or open a dialog
        },
        child: const Icon(Icons.add),
        tooltip: 'Add new',
      ),
    );
  }
}
