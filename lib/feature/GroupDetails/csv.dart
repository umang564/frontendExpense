import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutterproject/feature/dio.dart'; // Ensure this import is correct

class CsvGeneratorPage extends StatefulWidget {
  const CsvGeneratorPage({Key? key}) : super(key: key);

  @override
  _CsvGeneratorPageState createState() => _CsvGeneratorPageState();
}

class _CsvGeneratorPageState extends State<CsvGeneratorPage> {
  // Example data to be included in the CSV file
  // This will be replaced with data fetched from the backend

  Future<List<List<dynamic>>> _fetchDataFromBackend() async {
    final api = Api();
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null) {
      print("Token not found");
      return [];
    }

    print('Retrieved token: $token');
    int groupId = 21; // Update with the actual group ID
    final response = await api.dio.get(
      "http://10.0.2.2:8080/user/groupDetails?groupid=$groupId",
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("CSV Generator Example"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            String filePath = await _generateCsvAndSave();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('CSV saved at: $filePath')),
            );
          },
          child: const Text("Generate and Save CSV"),
        ),
      ),
    );
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
      await downloadDir.create(recursive: true); // Creates the directory if it doesn't exist
    }

    // Define the file path for saving the report.csv
    String filePath = '$downloadPath/report.csv';

    // Save the file
    File file = File(filePath);
    await file.writeAsBytes(csvData);

    return filePath;
  }
}
