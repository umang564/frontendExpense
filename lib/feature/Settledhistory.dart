import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterproject/feature/constant.dart';
import 'package:flutterproject/feature/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutterproject/feature/model/SettleModel.dart';

class Settledhistory extends StatefulWidget {
  const Settledhistory({super.key});

  @override
  State<Settledhistory> createState() => _SettledhistoryState();
}

class _SettledhistoryState extends State<Settledhistory> {
  late String name = '';
  late int id;
  late int adminId;
  List<SettleAmount> settlelist = [];

  Future<void> _fetchList() async {
    final api = Api();
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null) {
      print("Token not found");
      return;
    }

    try {
      final response = await api.dio.get(
        "$BASE_URL/user/settledexpense",
        queryParameters: {"group_id": id},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final expense = response.data;
        if (expense == null) {
          setState(() {
            settlelist = [];
          });
        } else {
          List<SettleAmount> fetchedList = (expense as List)
              .map((x) => SettleAmount.fromJson(x))
              .toList();

          // Sort the list in descending order by time
          fetchedList.sort((a, b) => b.time!.compareTo(a.time!));

          setState(() {
            settlelist = fetchedList;
          });
        }
        print("Settle list: $settlelist");
      } else {
        throw Exception('Failed to load settle data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Safely parse arguments to avoid type errors
    name = args['name'] as String;
    id = args['id'] as int;
    adminId = args['adminId'] as int;

    // Debugging logs
    print('Name: $name, ID: $id, AdminID: $adminId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent, // Set the background color of the header
        elevation: 4.0, // Add some shadow to the header
        title: Text(
          'Settle history of $name ', // Display the user's name or a default title
          style: TextStyle(
            fontSize: 20.0, // Set the font size
            fontWeight: FontWeight.bold, // Make the text bold
            color: Colors.white, // Text color
          ),
        ),
        // Hide the back button if needed
      ),
      body: settlelist.isEmpty
          ? Center(
        child: Text(
          'No settled expenses found',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: settlelist.length,
        itemBuilder: (context, index) {
          final item = settlelist[index];
          final displayTime = (item.time != null && item.time!.length >= 10)
              ? item.time!.substring(0, 10)
              : item.time ?? 'Unknown';

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.blue.shade50,
            elevation: 5,
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(
                '${item.ownByName} settled with ${item.givenByName}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                '${item.category} - $displayTime',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              trailing: Text(
                'Amount: \$${item.amount}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
