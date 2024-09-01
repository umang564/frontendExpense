import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/feature/utils/enums.dart';
import 'package:flutterproject/feature/GroupDetails/group_details_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutterproject/feature/dio.dart';
import 'package:csv/csv.dart';
import 'package:flutterproject/feature/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class GroupdetailsScreen extends StatefulWidget {
  const GroupdetailsScreen({Key? key}) : super(key: key);

  @override
  State<GroupdetailsScreen> createState() => _GroupdetailsScreenState();
}

class _GroupdetailsScreenState extends State<GroupdetailsScreen> {
  late GroupDetailsBloc _groupDetailsBloc;
  late String name;
  late int id;
  late int adminId;

  @override
  void initState() {
    super.initState();
    _groupDetailsBloc = GroupDetailsBloc(); // Initialize and trigger the event
  }

  @override
  void dispose() {
    _groupDetailsBloc.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Extract arguments from the ModalRoute
    final Map<String, dynamic> args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    name = args['name'] as String;
    id = args['id'] as int;
    adminId = args['adminId'] as int;
    _groupDetailsBloc.add(FetchDetails(group_id: id));
    _groupDetailsBloc.add(GetCsvFile(group_id: id));
  }

  Future<String> _generateCsvAndSave() async {
    try {
      // Fetch data from backend
      List<List<dynamic>> data = await _fetchDataFromBackend();

      // Convert data to CSV format
      final String csvData = const ListToCsvConverter().convert(data);

      // Get the temporary directory
      Directory directory = await getTemporaryDirectory();
      String filePath = '${directory.path}/report.csv';

      // Write the CSV data to a file in the temporary directory
      File tempFile = File(filePath);
      await tempFile.writeAsString(csvData);

      // Read the file as bytes
      Uint8List fileBytes = await tempFile.readAsBytes();

      // Save the file to the Downloads folder
      String downloadPath = await _saveCsv(fileBytes);
      print(downloadPath);

      return downloadPath;
    } catch (e) {
      throw Exception("Error generating CSV: $e");
    }
  }

  Future<String> _saveCsv(Uint8List csvData) async {
    Directory? downloadsDirectory = await getExternalStorageDirectory();

    // Create the Download folder path
    String downloadPath = '${downloadsDirectory!.path}/Download';

    // Check if the Download directory exists, and create it if it doesn't
    Directory downloadDir = Directory(downloadPath);
    if (!await downloadDir.exists()) {
      await downloadDir.create(
          recursive: true); // Creates the directory if it doesn't exist
    }

    // Define the file path for saving the report.csv
    String filePath = '$downloadPath/report.csv';

    // Save the file
    File file = File(filePath);
    await file.writeAsBytes(csvData);

    return filePath;
  }

  Future<List<List<dynamic>>> _fetchDataFromBackend() async {
    final api = Api();
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null) {
      print("Token not found");
      return [];
    }

    print('Retrieved token: $token');
    int groupId = id; // Use the actual group ID passed as argument
    final response = await api.dio.get(
      "$BASE_URL/user/groupDetails?groupid=$groupId",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      // Convert the backend response to the required format
      // Assuming response.data is a List of Maps
      List<dynamic> responseData = response.data["data"];
      List<List<dynamic>> csvData = [];

      // Convert response data to CSV format
      if (responseData.isNotEmpty) {
        csvData.add(responseData[0].keys.toList()); // Add header row

        for (var item in responseData) {
          csvData.add(item.values.toList());
        }
      }

      return csvData;
    } else {
      print("Failed to fetch data");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _groupDetailsBloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent, // Set the background color of the header
          elevation: 4.0,
          title: Row(
            children: [
              Text(
                "Expense history",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              BlocBuilder<GroupDetailsBloc, GroupDetailsState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () async {
                      String url = state.url;

                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(
                          Uri.parse(url),
                          mode: LaunchMode
                              .externalApplication, // Launch in an external application
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not launch URL')),
                        );
                      }
                    },
                    child: Icon(Icons.download),
                  );
                },
              ),
            ],
          ),
        ),
        body: BlocBuilder<GroupDetailsBloc, GroupDetailsState>(
          builder: (context, state) {
            switch (state.details) {
              case Details.loading:
                return const Center(child: CircularProgressIndicator());
              case Details.error:
                return Center(child: Text(state.message));
              case Details.success:
              // Sort the list in descending order based on createdAt
                List<dynamic> sortedList = List.from(state.detaillist);
                sortedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

                return sortedList.isEmpty
                    ? const Center(child: Text('No details available'))
                    : GridView.builder(
                  padding: EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two cards per row
                    crossAxisSpacing: 16.0, // Space between columns
                    mainAxisSpacing: 16.0, // Space between rows
                    childAspectRatio: 0.8, // Aspect ratio for each card (adjust as needed)
                  ),
                  itemCount: sortedList.length,
                  itemBuilder: (context, index) {
                    final item = sortedList[index];
                    return Card(
                      color: Colors.blue.shade50, // Card color
                      elevation: 5, // Shadow effect
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.category.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Given by: ${item.givenByName}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Description: ${item.description}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Involve User: ${item.involveUser}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Created at: ${item.createdAt.substring(0, 10)}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "Total Amount: \Rs ${item.amount}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
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
    );
  }
}
