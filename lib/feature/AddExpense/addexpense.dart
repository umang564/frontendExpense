import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/feature/AddExpense/add_expense_bloc.dart';
import 'package:flutterproject/feature/utils/enums.dart';
import 'package:multiselect/multiselect.dart';
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
        title: Text('Expense in $name'),
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
                          const SnackBar(content: Text('Expense added successfully')),
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
                        current.givenBy != previous.givenBy,
                        builder: (context, state) {
                          return TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            focusNode: emailFocusNode,
                            decoration: const InputDecoration(
                              hintText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              context
                                  .read<AddExpenseBloc>()
                                  .add(GivenByChanged(GivenByEmail: value));
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter email';
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
                            decoration: const InputDecoration(
                              hintText: 'Description',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              context
                                  .read<AddExpenseBloc>()
                                  .add(DescriptionChanged(Description: value));
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter description';
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
                            decoration: const InputDecoration(
                              hintText: 'Category',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              context
                                  .read<AddExpenseBloc>()
                                  .add(CategoryChanged(Category: value));
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter category';
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
                            decoration: const InputDecoration(
                              hintText: 'Amount',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              context
                                  .read<AddExpenseBloc>()
                                  .add(AmountChanged(Amount: int.parse(value)));
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Amount';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),
















                      BlocBuilder<AddExpenseBloc, AddExpenseState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              // Add Members button


                              // Show the CircularProgressIndicator or member list based on state
                              if (state.addExpenseStatus == AddExpenseStatus.loading)
                                const CircularProgressIndicator(),
                              if (state.addExpenseStatus == AddExpenseStatus.initial && state.memberlist.isNotEmpty)
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
                                      return state.memberlist.firstWhere((member) => member.name == name).iD!;
                                    }).toList();

                                    // Dispatch an event to update the Bloc state
                                    context.read<AddExpenseBloc>().add(
                                      MembersSelected(selectedMemberIds: selectedIds),
                                    );
                                  },
                                  hint: Text("selected member"),

                                ),
                              if (state.addExpenseStatus == AddExpenseStatus.error)
                                const Text('No members available'),
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
                            child: state.addExpenseStatus == AddExpenseStatus.loading
                                ? const CircularProgressIndicator()
                                : const Text('Add expense'),
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
}
