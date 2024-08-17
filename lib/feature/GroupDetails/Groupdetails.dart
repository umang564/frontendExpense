import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/feature/utils/enums.dart';
import 'package:flutterproject/feature/GroupDetails/group_details_bloc.dart';


class GroupdetailsScreen extends StatefulWidget {
  const GroupdetailsScreen({super.key});

  @override
  State<GroupdetailsScreen> createState() => _GroupdetailsScreenState();
}

class _GroupdetailsScreenState extends State<GroupdetailsScreen> {
  late  GroupDetailsBloc _groupDetailsBloc;
  late String name;
  late int id;
  late int adminId;

  @override
  void initState() {
    super.initState();
    _groupDetailsBloc = GroupDetailsBloc();// Initialize and trigger the event
  }

  @override
  void dispose() {
    _groupDetailsBloc.close();
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
    _groupDetailsBloc..add(FetchDetails(
        group_id: id));

  }





  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _groupDetailsBloc,
      child: Scaffold(
        appBar: AppBar(

          title: const Text("Members & exchange"),
        ),
        body: BlocBuilder<GroupDetailsBloc, GroupDetailsState>(
          builder: (context, state) {
            switch (state.details) {
              case Details.loading:
                return const Center(child: CircularProgressIndicator());
              case Details.error:
                return Center(child: Text(state.message));
              case Details.success:
                return ListView.builder(
                  itemCount: state.detaillist.length,
                  itemBuilder: (context, index) {
                    final item = state.detaillist[index];
                    return ListTile(
                      title: Text(item.category.toString()),
                      subtitle: Text(   "Given by ="+ item.givenByName.toString() +"\n"+"description =" +item.description.toString()),
                      trailing: Text(item.amount.toString()),
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
                'Summary of group',
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
