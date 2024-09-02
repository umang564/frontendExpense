import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterproject/feature/constant.dart';
import 'package:flutterproject/feature/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutterproject/feature/model/OneOne.dart';
import 'dart:async';
import 'package:flutterproject/feature/model/UserSuggestion.dart';

class Oneone extends StatefulWidget {
  const Oneone({super.key});

  @override
  State<Oneone> createState() => _OneoneState();
}

class _OneoneState extends State<Oneone> {
  List<Oneoneto> settlelist = [];
  int totallentamount = 0;
  int totaloweamount = 0;
  Timer? _debounce;
  List<UserSuggestion> _suggestions = [];
  String _selectedEmail = '';
  final TextEditingController _searchController = TextEditingController();

  Future<void> _fetchList(String email) async {
    final api = Api();
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null) {
      print("Token not found");
      return;
    }

    try {
      final response = await api.dio.get(
        "$BASE_URL/user/oneone",
        queryParameters: {"email": email},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final expense = response.data["overalls"];
        if (expense == null) {
          setState(() {
            settlelist = [];
          });
        } else {
          List<Oneoneto> fetchedList = (expense as List)
              .map((x) => Oneoneto.fromJson(x))
              .toList();

          // Sort the list in descending order by time
          fetchedList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

          setState(() {
            settlelist = fetchedList;
            _suggestions = []; // Clear the suggestions list
          });
        }

        setState(() {
          totallentamount = response.data["total_amount_lent"];
          totaloweamount = response.data["total_amount_owed"];
        });
        print("Settle list: $settlelist");
      } else {
        throw Exception('Failed to load settle data');
      }
    } catch (e) {
      print('Error: $e');
    }
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

        print("Response Data: ${response.data}");

        if (response.statusCode == 200) {
          final member = response.data;
          if (member == null) {
            setState(() {
              _suggestions = [];
            });
          } else {
            setState(() {
              _suggestions = (member as List)
                  .map((x) => UserSuggestion.fromJson(x))
                  .toList();
            });
          }

          print("Suggested list: $_suggestions");
        } else {
          throw Exception('Failed to load suggestions');
        }
      } catch (e) {
        print('Error: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent, // Set the background color of the header
        elevation: 4.0, // Add some shadow to the header
        title: Text(
          "One-to-One-Settlements", // Display the user's name or a default title
          style: TextStyle(
            fontSize: 20.0, // Set the font size
            fontWeight: FontWeight.bold, // Make the text bold
            color: Colors.white, // Text color
          ),
        ),
        // Hide the back button if needed
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Owe Amount:',
                      style: TextStyle(
                        fontSize: 18.0, // Increase the font size
                        fontWeight: FontWeight.bold, // Make the text bold
                        color: Colors.red, // Set the text color to red
                      ),
                    ),
                    Text(
                      '\$$totaloweamount', // Assuming it's a monetary value
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500, // Medium weight
                        color: Colors.black, // Set the text color to black
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Lent Amount:',
                      style: TextStyle(
                        fontSize: 18.0, // Increase the font size
                        fontWeight: FontWeight.bold, // Make the text bold
                        color: Colors.green, // Set the text color to green
                      ),
                    ),
                    Text(
                      '\$$totallentamount', // Assuming it's a monetary value
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500, // Medium weight
                        color: Colors.black, // Set the text color to black
                      ),
                    ),
                  ],
                ),
              ],
            ),

            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search user',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: _fetchSuggestions,
            ),
            Visibility(
              visible: _suggestions.isNotEmpty,
              child: Expanded(
                child: ListView.builder(
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = _suggestions[index];
                    return ListTile(
                      title: Text(suggestion.name ?? ''),
                      subtitle: Text(suggestion.email ?? ''),
                      onTap: () {
                        setState(() {
                          _selectedEmail = suggestion.email ?? '';
                          _searchController.text = suggestion.email ?? '';
                        });
                        // Fetch the list immediately after setting the selected email
                        _fetchList(_selectedEmail);
                      },
                    );
                  },
                ),
              ),
            ),
            Visibility(
              visible: settlelist.isNotEmpty,
              child: Expanded(
                child: ListView.builder(
                  itemCount: settlelist.length,
                  itemBuilder: (context, index) {
                    final item = settlelist[index];
                    return Card(
                      color: Colors.blue.shade50,
                      child: ListTile(
                        title: Text(item.description ?? ''),
                        subtitle: Text(
                          'Amount: ${item.amount}\n'
                              'Group Name: ${item.groupName}\n' 'Date of settlement :'
                              '${item.deletedAt == null ? 'Not settle'
                              '' : item.deletedAt!.substring(0, 10)}',
                        ),
                        trailing: Text(item.createdAt?.substring(0, 10) ?? ''),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
