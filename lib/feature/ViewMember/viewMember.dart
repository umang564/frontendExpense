import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/feature/utils/enums.dart';
import 'package:flutterproject/feature/ViewMember/view_member_bloc.dart';


class ViewMemberScreen extends StatefulWidget {
  const ViewMemberScreen({super.key});

  @override
  State<ViewMemberScreen> createState() => _ViewMemberScreenState();
}

class _ViewMemberScreenState extends State<ViewMemberScreen> {
  late ViewMemberBloc _viewMemberBloc;
  late String name;
  late int id;
  late int adminId;

  @override
  void initState() {
    super.initState();
    _viewMemberBloc = ViewMemberBloc();// Initialize and trigger the event
  }

  @override
  void dispose() {
    _viewMemberBloc.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Extract arguments from the ModalRoute
    final Map<String, dynamic> args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    name = args['name'] as String;
    id = args['id'] as int;
    adminId = args['adminId'] as int;
    _viewMemberBloc..add(GroupIdChanged(group_id: id));
    _viewMemberBloc..add(MemberFetched());
  }





  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _viewMemberBloc,
      child: Scaffold(
        appBar: AppBar(

          title: const Text("Member list"),
        ),
        body: BlocBuilder<ViewMemberBloc, ViewMemberState>(
          builder: (context, state) {
            switch (state.viewMemberStatus) {
              case ViewMemberStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case ViewMemberStatus.faiure:
                return Center(child: Text(state.message));
              case ViewMemberStatus.success:
                return ListView.builder(
                  itemCount: state.memberlist.length,
                  itemBuilder: (context, index) {
                    final item = state.memberlist[index];
                    return ListTile(
                      title: Text(item.name.toString()),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/settlement',
                            arguments: {
                              'name': item.name.toString(),
                              'id': item.iD,
                              'email': item.email,
                            },
                          );
                        },
                        child: const Text('Settlement'),
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
              Navigator.pushNamed(context, '/Summary');
            },
            child: const Padding(
              padding: EdgeInsets.all(9.0),
              child: Text(
                'Create Group',
                style: TextStyle(fontSize: 15), // Adjust font size as needed
                textAlign: TextAlign.center, // Center the text within the button
              ),
            ),
            tooltip: 'Summary',
          ),
        ),
      ),
    );
  }
}
