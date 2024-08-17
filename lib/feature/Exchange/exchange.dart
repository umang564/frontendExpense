import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/feature/Exchange/exchange_bloc.dart';
import 'package:flutterproject/feature/utils/enums.dart';

class ExchangeScreen extends StatefulWidget {
  const ExchangeScreen({super.key});

  @override
  State<ExchangeScreen> createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> {
  late ExchangeBloc _exchangeBloc;
  late String member_name;
  late int member_id;
  late String member_email;
  late int Group_id;
  late int Admin_id;

  @override
  void initState() {
    super.initState();
    _exchangeBloc = ExchangeBloc();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    member_name = args['member_name'] as String;
    member_id = args['member_id'] as int;
    member_email = args['member_email'] as String;
    Group_id = args['Group_Id'] as int;
    Admin_id = args['Admin_Id'] as int;
    _exchangeBloc.add(MemberIdChanged(memberId: member_id));
    _exchangeBloc.add(GroupIdChanged(groupId: Group_id));
    _exchangeBloc.add(MemberEmailChanged(memberEmail: member_email));
    _exchangeBloc.add(FetchExchangeApi());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _exchangeBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Members & Exchange",
            style: TextStyle(
              fontSize: 14.0, // Set the font size to your desired value
            ),
          ),
        ),
        body: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0), // Add padding around the icon
                  child: Icon(Icons.balance),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0), // Add padding around the text
                  child: BlocBuilder<ExchangeBloc, ExchangeState>(
                    builder: (context, state) {
                      return Text("balance = ${state.totalAmount}");
                    },
                  ),
                ),
                Spacer(), // Pushes the button to the right
                
                  BlocBuilder<ExchangeBloc, ExchangeState>(
          builder: (context, state) {
            if(state.totalAmount>0) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                // Add padding around the button
                child: ElevatedButton(
                  onPressed: () {
                    context.read<ExchangeBloc>().add(NotifyMember());
                    // Add your button action here
                  },
                  child: const Text('Notify'),
                ),
              );
            }else if(state.totalAmount==0){
              return Padding(padding: const EdgeInsets.all(8.0),

              child: Text("all clear"),

              );
            }else{
              return Padding(padding: const EdgeInsets.all(8.0),

                child: ElevatedButton(
                  onPressed: () {
                    state.exchangeStatus=ExchangeStatus.loading;
                    context.read<ExchangeBloc>().add(WholeSettledApi());
                    context.read<ExchangeBloc>().stream.firstWhere((state) => state.exchangeStatus == ExchangeStatus.success).then((_) {
                      context.read<ExchangeBloc>().add(FetchExchangeApi());
                    });
                    // Add your button action here
                  },
                  child: const Text('settled'),
                ),

              );
            }
  },
),

              ],
            ),


            Expanded(
              child: BlocBuilder<ExchangeBloc, ExchangeState>(
                builder: (context, state) {
                  switch (state.exchangeStatus) {
                    case ExchangeStatus.loading:
                      return const Center(child: CircularProgressIndicator());
                    case ExchangeStatus.failure:
                      return Center(child: Text(state.message));
                    case ExchangeStatus.success:
                      return ListView.builder(
                        itemCount: state.exchangeList.length,
                        itemBuilder: (context, index) {
                          final item = state.exchangeList[index];
                          return ListTile(
                            title: Text(item.category.toString() +" Rs " +item.exchangeAmount.toString()),
                            subtitle: Text(item.description.toString()),
                            trailing: ElevatedButton(
                              onPressed: () {
                                state.exchangeStatus=ExchangeStatus.loading;
                                context.read<ExchangeBloc>().add(SettledApi(debitID: item.debitId ?? 0, Category: item.category.toString(), Amount: item.exchangeAmount ?? 0, Description: item.description ?? "", ExpenseID: item.expenseId ?? 0));


                                context.read<ExchangeBloc>().stream.firstWhere((state) => state.exchangeStatus == ExchangeStatus.success).then((_) {
                                  context.read<ExchangeBloc>().add(FetchExchangeApi());
                                });
                              },

                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.delete),
                                  SizedBox(width: 6),
                                  Text('Settle'),
                                ],
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
          ],
        ),
      ),
    );
  }
}
