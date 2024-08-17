import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/feature/AddMember/add_member_bloc.dart';
import 'package:flutterproject/feature/utils/enums.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  late AddMemberBloc _addMemberBloc;
  final TextEditingController _groupNameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addMemberBloc = AddMemberBloc();
  }

  late String name;
  late int id;
  late int adminId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Extract arguments from the ModalRoute
    final Map<String, dynamic> args =
    ModalRoute
        .of(context)!
        .settings
        .arguments as Map<String, dynamic>;

    name = args['name'] as String;
    id = args['id'] as int;
    adminId = args['adminId'] as int;

  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _addMemberBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add member in '),
        ),
        body: BlocBuilder<AddMemberBloc, AddMemberState>(
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
                        labelText: 'member email',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a member  email name';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        context.read<AddMemberBloc>().add(MemberNameChanged(add_member_name:value));
                      },
                      onEditingComplete: () {
                        // Optionally, you can do something when the editing is complete
                        FocusScope.of(context).unfocus(); // Unfocus the field
                      },
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AddMemberBloc>().add(GroupIdChanged(group_id: id));
                          context.read<AddMemberBloc>().add(AddmemberApi());

                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Add memberer'),
                    ),
                    BlocBuilder<AddMemberBloc, AddMemberState>(
                      builder: (context, state) {
                        if (state.addMemberStatus ==
                            AddMemberStatus.loading) {
                          return const CircularProgressIndicator();
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
