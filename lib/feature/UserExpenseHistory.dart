import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterproject/feature/constant.dart';
import 'package:flutterproject/feature/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutterproject/feature/model/UserSettleHistory.dart';

class UserExpenseHistory extends StatefulWidget {
  const UserExpenseHistory({super.key});

  @override
  State<UserExpenseHistory> createState() => _UserExpenseHistoryState();
}

class _UserExpenseHistoryState extends State<UserExpenseHistory> with SingleTickerProviderStateMixin {
  List<SettlementHistory> settlelist = [];
  final _duration = const Duration(milliseconds: 500);
  late AnimationController _animationController;
  late Animation<double> _animation;

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
        "$BASE_URL/user/overallexpense",
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
          setState(() {
            settlelist = (expense as List)
                .map((x) => SettlementHistory.fromJson(x))
                .toList();

            // Sorting the list by 'createdAt' in descending order (most recent first)
            settlelist.sort((a, b) {
              if (a.createdAt != null && b.createdAt != null) {
                return b.createdAt!.compareTo(a.createdAt!);
              } else {
                return 0;
              }
            });
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
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _fetchList();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent, // Set the background color of the header
        elevation: 4.0, // Add some shadow to the header
        title: Text(
          'User Expense History', // Display the user's name or a default title
          style: TextStyle(
            fontSize: 20.0, // Set the font size
            fontWeight: FontWeight.bold, // Make the text bold
            color: Colors.white, // Text color
          ),
        ),
        // Hide the back button if needed
      ),
      body: ListView.builder(
        itemCount: settlelist.length,
        itemBuilder: (context, index) {
          final item = settlelist[index];
          String status;
          int displayAmount;

          if (item.amount != null && item.amount! < 0) {
            status = 'Owe to ${item.oweOrLent}';
            displayAmount = item.amount!.abs();
          } else {
            status = 'Lend to  ${item.oweOrLent}';
            displayAmount = item.amount ?? 0;
          }

          return ScaleTransition(
            scale: _animation,
            child: AnimatedContainer(
              duration: _duration,
              curve: Curves.easeInOut,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  '$status - \$$displayAmount',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Category: ${item.category ?? "Unknown"}'),
                    Text('Created At: ${item.createdAt?.substring(0, 10) ?? "Unknown"}'),
                    if (item.deletedAt != null && item.deletedAt!.isNotEmpty)
                      Text('Settled At: ${item.deletedAt!.substring(0, 10)}')
                    else
                      Text('Not Settled'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
