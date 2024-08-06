import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterproject/feature/dio.dart';
import 'package:flutterproject/feature/model/groupModel.dart';
import 'package:cookie_jar/cookie_jar.dart';

final api = Api();

class GroupRepository {
  Future<List<GroupModel>> fetchGroupName() async {
    final storage = FlutterSecureStorage();

    final token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token not found');
    }
    print('CookieJar initialized: ${api.cookieJar}');


    print('Retrieved token: $token');

    // Set the cookie in CookieJar
    api.cookieJar.saveFromResponse(
      Uri.parse("http://10.0.2.2:8080/user/getgroupname"),
      [Cookie('Authorization', token)],
    );

    try {
      final response = await api.dio.get(
        "http://10.0.2.2:8080/user/getgroupname",
        options: Options(
          contentType: 'application/json',
        ),
      );

      // Debugging line
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        try {
          return (response.data['group_users'] as List)
              .map((x) => GroupModel.fromJson(x))
              .toList();
        } catch (e) {
          print('Error parsing data: $e');
          throw FormatException('Error parsing data');
        }
      } else {
        throw Exception('Error while fetching group name: ${response.statusCode}');
      }
    } catch (e) {
      print('DioException: $e');
      throw Exception('Failed to fetch group name');
    }
  }
}

