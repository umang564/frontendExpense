import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/feature/AddMember/add_member_bloc.dart';
import 'package:flutterproject/feature/utils/enums.dart';
import 'package:flutterproject/feature/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutterproject/feature/constant.dart';
import 'package:flutterproject/feature/model/UserSuggestion.dart';

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
  List<UserSuggestion> _suggestions = [];

  Timer? _debounce; // For debouncing

  @override
  void initState() {
    super.initState();
    _addMemberBloc = AddMemberBloc();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Safely parse arguments to avoid type errors
    name = args['name'] as String;
    id = args['id'] as int;
    adminId = args['adminId'] as int;

    // Debugging logs
    print('Name: $name, ID: $id, AdminID: $adminId');
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _focusNode.dispose();
    _debounce?.cancel(); // Cancel the debounce timer if the widget is disposed
    super.dispose();
  }

  Future<void> _fetchSuggestions(String query) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      final api = Api();
      if (query.isEmpty) {
        setState(() {
          _suggestions = [];
        });
        return;
      }

      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');

      if (token == null) {
        print("Token not found");
        return;
      }

      try {
        final response = await api.dio.get(
          "$BASE_URL/user/like",
          queryParameters: {"Namelike": query},
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ),
        );

        print("Response Data: ${response.data}"); // Log the entire response data

        if (response.statusCode == 200) {
          final member = response.data;
          if (member == null) {
            setState(() {
              _suggestions = [];
            });
          } else {
            setState(() {
              print("this is my error");
              _suggestions = (member as List)
                  .map((x) => UserSuggestion.fromJson(x))
                  .toList();
            });
            print("this is my error 2");
          }

          print("Suggested list: $_suggestions");
        } else {
          throw Exception('Failed to load suggestions');
        }
      } catch (e) {
        print('Error: $e'); // Log the error
      }
    });
  }

  late String name;
  late int id;
  late int adminId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _addMemberBloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          elevation: 4.0,
          title: const Text(
            'Add member',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: BlocListener<AddMemberBloc, AddMemberState>(
          listenWhen: (previous, current) => current.addMemberStatus != previous.addMemberStatus,
          listener: (context, state) {
            if (state.addMemberStatus == AddMemberStatus.error) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
            }

            if (state.addMemberStatus == AddMemberStatus.success) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Member Added Successfully')),
                );
              Navigator.pop(context);
            }
          },
          child: BlocBuilder<AddMemberBloc, AddMemberState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _groupNameController,
                          focusNode: _focusNode,
                          decoration: const InputDecoration(
                            labelText: 'Member Email',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a member email';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _fetchSuggestions(value);
                            context.read<AddMemberBloc>().add(MemberNameChanged(add_member_name: value));
                          },
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                        const SizedBox(height: 8.0),
                        if (_suggestions.isNotEmpty)
                          Container(
                            constraints: BoxConstraints(maxHeight: 200.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _suggestions.length,
                              itemBuilder: (context, index) {
                                final suggestion = _suggestions[index];
                                return ListTile(
                                  title: Text(suggestion.name ?? ''),
                                  subtitle: Text(suggestion.email ?? ''),
                                  onTap: () {
                                    setState(() {
                                      _groupNameController.text = suggestion.email ?? '';
                                      _suggestions = []; // Clear suggestions on selection
                                    });
                                    context.read<AddMemberBloc>().add(MemberNameChanged(add_member_name: suggestion.email ?? ''));
                                  },
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AddMemberBloc>().add(GroupIdChanged(group_id: id));
                              context.read<AddMemberBloc>().add(AddmemberApi());
                            }
                          },
                          child: const Text('Add Member'),
                        ),
                        BlocBuilder<AddMemberBloc, AddMemberState>(
                          builder: (context, state) {
                            if (state.addMemberStatus == AddMemberStatus.loading) {
                              return const CircularProgressIndicator();
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
