import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterproject/feature/home/home_bloc.dart';
import 'package:flutterproject/feature/utils/enums.dart';
import 'package:flutterproject/feature/constant.dart';
import 'package:flutterproject/feature/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutterproject/feature/Profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc _homeBloc;
  String? name = ''; // Nullable variable
  int totalAmount = 0;
  int _selectedIndex = 0;

  final List<String> _pages = [
    "/profile", // Page for School tab
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
    if (index == 0) {
      Navigator.pushNamed(context, _pages[index]);
    }
    if (index == 1) {
      Navigator.pushNamed(context, '/createGroup');
    }
    if (index == 2) {
      Navigator.pushNamed(context, '/expense');
    }
  }

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc()..add(GroupFetched());
    getUserName();
    getTotalAmount();
  }

  void getUserName() async {
    final storage = FlutterSecureStorage();
    final userName = await storage.read(key: 'name');
    setState(() {
      name = userName ?? ''; // Update the state with the retrieved name
    });
  }

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
        totalAmount = response.data["total_amount"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _homeBloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent, // Set the background color of the header
          elevation: 4.0, // Add some shadow to the header
          title: Row(
            children: [
              Icon(Icons.group, color: Colors.white), // Icon with color matching the theme
              const SizedBox(width: 8), // Spacing between the icon and the text
              Text(
                'Splito', // Display the user's name or a default title
                style: TextStyle(
                  fontSize: 20.0, // Set the font size
                  fontWeight: FontWeight.bold, // Make the text bold
                  color: Colors.white, // Text color
                ),
              ),
              Spacer(),
            ],
          ),
          automaticallyImplyLeading: false, // Hide the back button if needed
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.create),
              label: 'Create Group',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.currency_rupee),
              label: 'Expense Details',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped, // Call the function when a tab is tapped
        ),
        body: BlocBuilder<HomeBloc, GroupState>(
          builder: (context, state) {
            switch (state.groupStatus) {
              case GroupStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case GroupStatus.failure:
                return Center(child: Text(state.message));
              case GroupStatus.success:
                if (state.grouplist.isEmpty) {
                  getTotalAmount();
                  return const Center(
                    child: Text(
                      'You are not in any group',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return Column(
                  children: [
                    Expanded( // Ensure ListView.builder doesn't overflow
                      child: ListView.builder(
                        itemCount: state.grouplist.length,
                        itemBuilder: (context, index) {
                          final item = state.grouplist[index];
                          return Card(
                            color: Colors.blue.shade50, // Set the card background color to blue shade 50
                            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16.0),
                              title: Row(
                                children: [
                                  Icon(Icons.group),
                                  const SizedBox(width: 8),
                                  Text(item.name.toString()),
                                ],
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/group',
                                    arguments: {
                                      'name': item.name.toString(),
                                      'id': item.iD,
                                      'adminId': item.adminID,
                                    },
                                  );
                                },
                                child: const Text('View Details'),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              default:
                return const Center(child: Text('Unexpected state'));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Define the action to perform when the FAB is pressed
            Navigator.pushNamed(context, '/oneone');
          },
          child: Icon(Icons.currency_exchange_sharp),
          backgroundColor: Colors.blueAccent,
          tooltip: 'Add Group',
        ),
      ),
    );
  }
}
