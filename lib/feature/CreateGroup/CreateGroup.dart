import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/feature/CreateGroup/creategroup_bloc.dart';
import 'package:flutterproject/feature/utils/enums.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  late CreategroupBloc _creategroupBloc;
  final TextEditingController _groupNameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _creategroupBloc = CreategroupBloc();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _focusNode.dispose();
    _creategroupBloc.close(); // Close the bloc to free up resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _creategroupBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(Icons.create),
              const Text(' Create Group'),
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            BlocListener<CreategroupBloc, CreategroupState>(
              listener: (context, state) {
                if(state.createGroupStatus==CreateGroupStatus.success){
                  Navigator.pushNamed(context, '/createGroup');

                }
              },
              child: Text(""),
            ),
            BlocBuilder<CreategroupBloc, CreategroupState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _groupNameController,
                          focusNode: _focusNode,
                          decoration: const InputDecoration(
                            labelText: 'Group Name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a group name';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            context.read<CreategroupBloc>().add(
                                GroupNameChanged(groupName: value));
                          },
                          onEditingComplete: () {
                            // Optionally, you can do something when the editing is complete
                            FocusScope.of(context)
                                .unfocus(); // Unfocus the field
                          },
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {

                            if (_formKey.currentState!.validate()) {
                              context.read<CreategroupBloc>().add(
                                  CreateGroupApi());
                              if (state.createGroupStatus ==
                                  CreateGroupStatus.success) {

                              }
                            }
                          },
                          child: const Text('Create Group'),
                        ),
                        BlocBuilder<CreategroupBloc, CreategroupState>(
                          builder: (context, state) {
                            if (state.createGroupStatus ==
                                CreateGroupStatus.loading) {
                              return const CircularProgressIndicator();
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        ElevatedButton(onPressed: () {
                          Navigator.pushNamed(context, '/home');
                        }, child: Text("move to home screen"))
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
