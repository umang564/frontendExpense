import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiselect/multiselect.dart';
import 'package:flutterproject/feature/AddExpense/add_expense_bloc.dart';
import 'package:flutterproject/feature/utils/enums.dart';
import 'package:flutterproject/feature/model/viewMemberModel.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final amountFocusNode = FocusNode();
  final categoryFocusNode = FocusNode();

  late AddExpenseBloc _addExpenseBloc;
  String? selectedEmail; // To keep track of the selected email

  @override
  void initState() {
    super.initState();
    _addExpenseBloc = AddExpenseBloc();
  }

  late String name;
  late int id;
  late int adminId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    name = args['name'] as String;
    id = args['id'] as int;
    adminId = args['adminId'] as int;

    _addExpenseBloc.add(GroupIdChanged(GroupId: id));
    _addExpenseBloc.add(MemberFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent, // Set the background color of the header
        elevation: 4.0, // Add some shadow to the header
        title: Text(
          'Add Expense', // Display the user's name or a default title
          style: TextStyle(
            fontSize: 20.0, // Set the font size
            fontWeight: FontWeight.bold, // Make the text bold
            color: Colors.white, // Text color
          ),
        ),
        // Hide the back button if needed
      ),
      body: BlocProvider(
        create: (_) => _addExpenseBloc,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: BlocListener<AddExpenseBloc, AddExpenseState>(
                  listenWhen: (previous, current) =>
                  current.addExpenseStatus != previous.addExpenseStatus,
                  listener: (context, state) {
                    if (state.addExpenseStatus == AddExpenseStatus.error) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(content: Text(state.message.toString())),
                        );
                    }

                    if (state.addExpenseStatus == AddExpenseStatus.success) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(content: Text('Expense Added Successfully')),
                        );
                      Navigator.pop(context);
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<AddExpenseBloc, AddExpenseState>(
                        buildWhen: (previous, current) =>
                        current.memberlist != previous.memberlist,
                        builder: (context, state) {
                          return DropdownButtonFormField<String>(
                            value: selectedEmail,
                            items: state.memberlist.isEmpty
                                ? [
                              const DropdownMenuItem<String>(
                                value: '',
                                child: Text('No Members Available'),
                              )
                            ]
                                : state.memberlist
                                .map((member) => DropdownMenuItem<String>(
                              value: member.email,
                              child: Text(member.email ?? ''),
                            ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedEmail = value;
                                context.read<AddExpenseBloc>().add(
                                  GivenByChanged(GivenByEmail: selectedEmail ?? ''),
                                );
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Select Email',
                         // Set the background color
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue.shade50), // Border color
                                borderRadius: BorderRadius.circular(8.0), // Rounded corners
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Optional: Adjust padding
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Select an Email';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<AddExpenseBloc, AddExpenseState>(
                        buildWhen: (previous, current) =>
                        current.description != previous.description,
                        builder: (context, state) {
                          return TextFormField(
                            keyboardType: TextInputType.text,
                            focusNode: descriptionFocusNode,
                            decoration: InputDecoration(
                              hintText: 'Description',
                            // Set the background color
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue.shade50), // Border color
                                borderRadius: BorderRadius.circular(8.0), // Rounded corners
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),  // Optional: Adjust padding
                            ),
                            onChanged: (value) {
                              context
                                  .read<AddExpenseBloc>()
                                  .add(DescriptionChanged(Description: value));
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter Description';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<AddExpenseBloc, AddExpenseState>(
                        buildWhen: (previous, current) =>
                        current.category != previous.category,
                        builder: (context, state) {
                          return TextFormField(
                            keyboardType: TextInputType.text,
                            focusNode: categoryFocusNode,
                            decoration: InputDecoration(
                              hintText: 'Category',
                              // Set the background color
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue.shade50), // Border color
                                borderRadius: BorderRadius.circular(8.0), // Rounded corners
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),// Optional: Adjust padding
                            ),
                            onChanged: (value) {
                              context
                                  .read<AddExpenseBloc>()
                                  .add(CategoryChanged(Category: value));
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter Category';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<AddExpenseBloc, AddExpenseState>(
                        buildWhen: (previous, current) =>
                        current.amount != previous.amount,
                        builder: (context, state) {
                          return TextFormField(
                            keyboardType: TextInputType.number,
                            focusNode: amountFocusNode,
                            decoration: InputDecoration(
                              hintText: 'Amount',
                              // Enable background color
                              // Set the background color
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue.shade50), // Border color
                                borderRadius: BorderRadius.circular(8.0), // Rounded corners
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Optional: Adjust padding
                            ),
                            onChanged: (value) {
                              final amount = int.tryParse(value) ?? 0;
                              context
                                  .read<AddExpenseBloc>()
                                  .add(AmountChanged(Amount: amount));
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter Amount';
                              }

                              final amount = int.tryParse(value);
                              if (amount == null) {
                                return 'Enter a valid number';
                              }

                              if (amount < 0) {
                                return 'Amount should be positive';
                              }

                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<AddExpenseBloc, AddExpenseState>(
                        buildWhen: (previous, current) =>
                        previous.memberlist != current.memberlist ||
                            previous.selectedMemberIds != current.selectedMemberIds,
                        builder: (context, state) {
                          return Column(
                            children: [
                              if (state.memberlist.isNotEmpty)
                                DropDownMultiSelect(
                                  options: state.memberlist.map((member) => member.name ?? '').toList(),
                                  selectedValues: state.selectedMemberIds.map((id) {
                                    final member = state.memberlist.firstWhere(
                                          (member) => member.iD == id,
                                      orElse: () => ViewMemberModel(name: ''),
                                    );
                                    return member.name ?? '';
                                  }).where((name) => name.isNotEmpty).toList(),
                                  onChanged: (List<String> selectedNames) {
                                    final selectedIds = selectedNames.map((name) {
                                      return state.memberlist.firstWhere(
                                            (member) => member.name == name,
                                        orElse: () => ViewMemberModel(iD: null),
                                      ).iD!;
                                    }).toList();

                                    context.read<AddExpenseBloc>().add(
                                      MembersSelected(selectedMemberIds: selectedIds),
                                    );
                                  },
                                  hint: Text("Select Members"),
                                ),
                              if (state.memberlist.isEmpty)
                                const Text('No Members Available'),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<AddExpenseBloc, AddExpenseState>(
                        buildWhen: (previous, current) =>
                        current.addExpenseStatus != previous.addExpenseStatus,
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context
                                    .read<AddExpenseBloc>()
                                    .add(GroupIdChanged(GroupId: id));
                                context.read<AddExpenseBloc>().add(ExpenseApi());
                              }
                            },
                            child: const Text('Add Expense'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    descriptionFocusNode.dispose();
    amountFocusNode.dispose();
    categoryFocusNode.dispose();
    super.dispose();
  }
}
