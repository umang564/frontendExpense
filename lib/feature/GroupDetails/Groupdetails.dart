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

  //umang////

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

  //hi

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _groupDetailsBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text("Expense history"),
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: BlocBuilder<GroupDetailsBloc, GroupDetailsState>(
                builder: (context, state) {
                  switch (state.details) {
                    case Details.loading:
                      return const Center(child: CircularProgressIndicator());
                    case Details.error:
                      return Center(child: Text(state.message));
                    case Details.success:
                      return state.detaillist.isEmpty
                          ? const Center(child: Text('No details available'))
                          : ListView.builder(
                        itemCount: state.detaillist.length,
                        itemBuilder: (context, index) {
                          final item = state.detaillist[index];
                          return ListTile(
                            title: Text(item.category.toString()),
                            subtitle: Text("Given by = " +
                                item.givenByName.toString() +
                                "\n" +
                                "Description = " +
                                item.description.toString()),
                            trailing: Text(item.amount.toString()),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(
                context, '/csv'); // Navigate to CSV-related screen or action
          },
          child: const Icon(Icons.add),
          tooltip: 'Add New Item',
        ),
      ),
    );
  }
}
