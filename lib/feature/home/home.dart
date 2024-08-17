import 'package:flutter/material.dart';
import 'package:flutterproject/feature/home/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterproject/feature/utils/enums.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc()..add(GroupFetched()); // Initialize and trigger the event
  }



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _homeBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text('Groups List'),
          Spacer(),
              ElevatedButton(onPressed :()async
                  {
                  final storage = FlutterSecureStorage();
                  await storage.delete(key: 'token');
                  Navigator.pushNamed(context, '/login');

                  }, child: Text("Log out"))
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<HomeBloc, GroupState>(
          builder: (context, state) {
            switch (state.groupStatus) {
              case GroupStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case GroupStatus.failure:
                return Center(child: Text(state.message));
              case GroupStatus.success:
                return ListView.builder(
                  itemCount: state.grouplist.length,
                  itemBuilder: (context, index) {
                    final item = state.grouplist[index];
                    return ListTile(
                      title: Text(item.name.toString()),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/group',
                            arguments: {
                              'name': item.name.toString(),
                              'id': item.iD,
                              'adminId': item.adminID,
                            },
                          );
                        },
                        child: const Text('View Details'),
                      ),
                    );
                  },
                );
              default:
                return const Center(child: Text('Unexpected state'));
            }
          },
        ),
        floatingActionButton: Container(
          width: 150.0,  // Set the desired width
          height: 50.0,
          child: FloatingActionButton(
            onPressed: () {
              // Define the action to create a group
              // For example, navigate to a group creation screen
              Navigator.pushNamed(context, '/createGroup');
            },
            child: const Padding(
              padding: EdgeInsets.all(9.0),
              child: Text(
                'Create Group',
                style: TextStyle(fontSize: 15), // Adjust font size as needed
                textAlign: TextAlign.center, // Center the text within the button
              ),
            ),
            tooltip: 'Create Group',
          ),
        ),
      ),
    );
  }
}
