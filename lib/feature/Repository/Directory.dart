import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterproject/feature/dio.dart';
import 'package:flutterproject/feature/model/moneyExchangeModel.dart';
import 'package:flutterproject/feature/constant.dart';


final api = Api();

class EXchangeRepository {
  Future<List<MoneyExchangeModel>> fetchExchangeList({
    required int member_id,
    required int group_id,
  }) async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null) {
      throw Exception('Token not found');
    }

    print('Retrieved token: $token');

    try {
      final response = await api.dio.get(
        "$BASE_URL/user/exchange?member_id=$member_id&group_id=$group_id",
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
          final exchanges = response.data['data']["Exchanges"];
          if (exchanges == null) {
            return [];
          }
          return (exchanges as List)
              .map((x) => MoneyExchangeModel.fromJson(x))
              .toList();
        } catch (e) {
          print('Error parsing data: $e');
          throw FormatException('Error parsing exchange data');
        }
      } else {
        throw Exception('Error while fetching exchanges: ${response.statusCode}');
      }
    } catch (e) {
      print('DioException: $e');
      throw Exception('Failed to fetch exchange list');
    }
  }
}
