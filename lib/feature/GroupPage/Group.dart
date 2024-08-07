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
            Text('ID: $id', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Admin ID: $adminId', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const Text('Options', style: TextStyle(fontSize: 18)),
            const Divider(),
            Expanded(
              child: ListView(
                children: const <Widget>[
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text('Add member'),
                  ),
                  ListTile(
                    leading: Icon(Icons.currency_exchange),
                    title: Text('Add expense'),
                  ),
                  ListTile(
                    leading: Icon(Icons.group),
                    title: Text('View members'),
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
