import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/feature/utils/enums.dart';
import 'package:flutterproject/feature/ViewMember/view_member_bloc.dart';

class ViewMemberScreen extends StatefulWidget {
  const ViewMemberScreen({super.key});

  @override
  State<ViewMemberScreen> createState() => _ViewMemberScreenState();
}

class _ViewMemberScreenState extends State<ViewMemberScreen> with SingleTickerProviderStateMixin {
  late ViewMemberBloc _viewMemberBloc;
  late String name;
  late int id;
  late int adminId;
  late int userId;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _viewMemberBloc = ViewMemberBloc(); // Initialize and trigger the event

    // Initialize animation controller and animations
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _viewMemberBloc.close();
    _controller.dispose();
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
    userId = args['userId'] as int;
    _viewMemberBloc..add(GroupIdChanged(group_id: id));
    _viewMemberBloc..add(MemberFetched());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _viewMemberBloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent, // Set the background color of the header
          elevation: 4.0, // Add some shadow to the header
          title: Text(
            'Member & Exchange', // Display the user's name or a default title
            style: const TextStyle(
              fontSize: 20.0, // Set the font size
              fontWeight: FontWeight.bold, // Make the text bold
              color: Colors.white, // Text color
            ),
          ),
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
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Card(
                          color: Colors.blue.shade50, // Set the background color of the card
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Adjusts the margin around the card
                          elevation: 3.0, // Adds a slight shadow to the card
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), // Rounds the corners of the card
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // Adds padding inside the ListTile
                            title: Text(item.name.toString()),
                            trailing: item.iD == state.current_user_id
                                ? null
                                : ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/exchange',
                                  arguments: {
                                    'member_name': item.name.toString(),
                                    'member_id': item.iD,
                                    'member_email': item.email,
                                    'Group_Id': id,
                                    'Admin_Id': adminId,
                                  },
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min, // Adjusts the Row to wrap its children
                                children: const [
                                  Icon(Icons.currency_rupee),
                                  SizedBox(width: 6),
                                  Text('Exchange'), // Adds some space between the Text and Icon
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              default:
                return const Center(child: Text('Unexpected state'));
            }
          },
        ),
      ),
    );
  }
}
