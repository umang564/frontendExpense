import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:file_saver/file_saver.dart';

class CsvApp extends StatefulWidget {
  const CsvApp({super.key});

  @override
  State<CsvApp> createState() => _CsvAppState();
}

class _CsvAppState extends State<CsvApp> {
  // Test CSV created just for demo.
  String csv = const ListToCsvConverter().convert(
    [
      ["Column1", "Column2"],
      ["Column1", "Column2"],
      ["Column1", "Column2"],
    ],
  );

  // Download and save CSV to your Device
  Future<void> downloadCSV(String file) async {
    // Convert your CSV string to a Uint8List for downloading.
    Uint8List bytes = Uint8List.fromList(utf8.encode(file));

    // This will download the file on the device.
    await FileSaver.instance.saveFile(
      name: 'document_name.csv', // you can give the CSV file name here.
      bytes: bytes,
      ext: 'csv',
      mimeType: MimeType.csv,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSV Download Example'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
            // When the download button is pressed, call `downloadCSV` function and pass the CSV string in it.
            await downloadCSV(csv);
          },
          child: const Text(
            'Download CSV',
          ),
        ),
      ),
    );
  }
}
