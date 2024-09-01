import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/feature/Exchange/exchange_bloc.dart';
import 'package:flutterproject/feature/utils/enums.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterproject/feature/constant.dart';
import 'package:flutterproject/feature/dio.dart';
import 'package:dio/dio.dart';
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
  String message="";

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



  Future<void> MemberDelete() async {
    final api = Api();
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null) {
      print("Token not found");
      return;
    }

    try {
      final response = await api.dio.delete(
        "$BASE_URL/user/deletemember",
        queryParameters: {"groupid": Group_id, "memberid": member_id},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      // Extract the message from the response
      final responseMessage = response.data['message'] ?? "An unexpected error occurred";

      // Show the appropriate message based on the status code
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(responseMessage)),
        );

      if (response.statusCode == 200) {
        Navigator.pop(context);
      }
    } catch (e) {
      // Handle DioException
      if (e is DioException) {
        final errorMessage = e.response?.data['message'] ?? "An unexpected error occurred";
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
      } else {
        // Handle other types of exceptions
        print('Error: $e');
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text("An error occurred: $e")),
          );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _exchangeBloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          elevation: 4.0,
          title: Row(
            children: [
              Text(
                'Member & Exchange',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              ElevatedButton(onPressed: (){
           MemberDelete();




              }, child: Text("Delete"))
            ],
          ),
        ),
        body: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.balance),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<ExchangeBloc, ExchangeState>(
                    builder: (context, state) {
                      return Text("balance = ${state.totalAmount}");
                    },
                  ),
                ),
                Spacer(),
                BlocBuilder<ExchangeBloc, ExchangeState>(
                  builder: (context, state) {
                    if (state.totalAmount > 0) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<ExchangeBloc>().add(NotifyMember());
                          },
                          child: const Text('Notify'),
                        ),
                      );
                    } else if (state.totalAmount == 0) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("all clear"),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            state.exchangeStatus = ExchangeStatus.loading;
                            context.read<ExchangeBloc>().add(WholeSettledApi());
                            context.read<ExchangeBloc>()
                                .stream
                                .firstWhere((state) =>
                            state.exchangeStatus ==
                                ExchangeStatus.success)
                                .then((_) {
                              context
                                  .read<ExchangeBloc>()
                                  .add(FetchExchangeApi());
                            });
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
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 4.0, // Elevation for card shadow
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16.0),
                                title: Text(
                                  "${item.category.toString()} Rs ${item.exchangeAmount.toString()}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                subtitle: Text(
                                  item.description.toString(),
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                leading: Icon(Icons.monetization_on,
                                    color: Colors.green),
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
