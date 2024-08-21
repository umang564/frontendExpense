import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterproject/feature/dio.dart';
import 'package:flutterproject/feature/model/viewMemberModel.dart';
import 'package:flutterproject/feature/constant.dart';


final api = Api();

class ViewRepository{
Future<List<ViewMemberModel>> fetchMemberGroup({required int id}) async{
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'token');

  if (token == null) {
    throw Exception('Token not found');
  }

  print('Retrieved token: $token');

  try {
    final response = await api.dio.get(
      "$BASE_URL/user/viewmember?id=$id",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    print('Response data: ${response.data}');

    if (response.statusCode == 200) {
      try {
        // Check if 'group_users' is null and return an empty list if it is
        final groupUsers = response.data['group_users'];
        if (groupUsers == null) {
          return [];
        }
        return (groupUsers as List)
            .map((x) => ViewMemberModel.fromJson(x))
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







