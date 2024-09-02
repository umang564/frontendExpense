import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterproject/feature/constant.dart';
import 'package:flutterproject/feature/dio.dart';
import 'package:dio/dio.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name = ''; // Nullable variable for storing user name
  String? email = ''; // Nullable variable for storing user email
  String? profilePictureUrl = '';
  String? totaloweamount = '';
  String? totallentamount = '';
  String? Email = '';

  void getTotalAmount() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final api = Api();
    final response = await api.dio.get(
      "$BASE_URL/user/totalamount",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        totaloweamount = response.data["total_amount_owe"]?.toString() ?? "";
        totallentamount = response.data["total_amount_lend"]?.toString() ?? "";
        Email = response.data["userEmail"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    getTotalAmount();
  }

  Future<void> _loadUserProfile() async {
    final storage = FlutterSecureStorage();
    final storedName = await storage.read(key: 'name');
    final storedEmail = await storage.read(key: 'email');
    final storedProfilePictureUrl = await storage.read(key: 'profilePictureUrl');

    setState(() {
      name = storedName ?? 'Guest';
      email = Email ?? 'guest@example.com';
      profilePictureUrl = storedProfilePictureUrl ?? 'https://cdn.pixabay.com/photo/2014/04/03/10/32/user-310807_1280.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(profilePictureUrl ?? ''),
              ),
              const SizedBox(height: 20.0),
              Text(
                name ?? 'Guest',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                Email??'',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                'Total Amount owe: \Rs ${totaloweamount ?? '0.00'}',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Total Amount lent: \Rs ${totallentamount ?? '0.00'}',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  final storage = FlutterSecureStorage();
                  await storage.deleteAll(); // Clear user data
                  Navigator.pushReplacementNamed(context, '/login'); // Navigate to login page
                },
                child: const Text('Log Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
