import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/feature/AddExpense/add_expense_bloc.dart';
import 'package:flutterproject/feature/utils/enums.dart';



class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailFocusNode = FocusNode();
  final descriptionFocusNode =FocusNode();
  final amountFocusNode=FocusNode();
  final categoryFocusNode=FocusNode();

late AddExpenseBloc _addExpenseBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addExpenseBloc = AddExpenseBloc();
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
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                      Navigator.pushNamed(context, '/home');
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<AddExpenseBloc, AddExpenseState>(
                          buildWhen: (current, previous) =>
                          current.givenBy != previous.givenBy,
                          builder: (context, state) {
                            return TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              focusNode: emailFocusNode,
                              decoration: const InputDecoration(
                                  hintText: 'Email', border: OutlineInputBorder()),
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
                              onFieldSubmitted: (value) {},
                            );
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocBuilder<AddExpenseBloc, AddExpenseState>(
                          buildWhen: (current, previous) =>
                          current.description != previous.description,
                          builder: (context, state) {
                            return TextFormField(
                              keyboardType: TextInputType.text,
                              focusNode: descriptionFocusNode,
                              decoration: const InputDecoration(
                                  hintText: 'Description', border: OutlineInputBorder()),
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
                              onFieldSubmitted: (value) {},
                            );
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocBuilder<AddExpenseBloc, AddExpenseState>(
                          buildWhen: (current, previous) =>
                          current.category != previous.category,
                          builder: (context, state) {
                            return TextFormField(
                              keyboardType: TextInputType.text,
                              focusNode: categoryFocusNode,
                              decoration: const InputDecoration(
                                  hintText: 'Category', border: OutlineInputBorder()),
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
                              onFieldSubmitted: (value) {},
                            );
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocBuilder<AddExpenseBloc, AddExpenseState>(
                          buildWhen: (current, previous) =>
                          current.amount != previous.amount,
                          builder: (context, state) {
                            return TextFormField(
                              keyboardType: TextInputType.number,
                              focusNode: amountFocusNode,
                              decoration: const InputDecoration(
                                  hintText: 'Amount', border: OutlineInputBorder()),
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
                              onFieldSubmitted: (value) {},
                            );
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocBuilder<AddExpenseBloc, AddExpenseState>(
                          buildWhen: (current, previous) =>
                          current.addExpenseStatus != previous.addExpenseStatus,
                          builder: (context, state) {
                            return ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AddExpenseBloc>().add(GroupIdChanged(GroupId: id));
                                    context.read<AddExpenseBloc>().add(ExpenseApi());
                                  }
                                },
                                child: state.addExpenseStatus == AddExpenseStatus.loading
                                    ? const CircularProgressIndicator()
                                    : const Text('Add expense'));
                          }),
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
