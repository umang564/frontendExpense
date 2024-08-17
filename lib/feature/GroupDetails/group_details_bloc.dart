import 'package:bloc/bloc.dart';
import 'package:flutterproject/feature/model/DetailsModel.dart';
import 'package:flutterproject/feature/utils/enums.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterproject/feature/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

part 'group_details_event.dart';
part 'group_details_state.dart';

class GroupDetailsBloc extends Bloc<GroupDetailsEvent, GroupDetailsState> {
  GroupDetailsBloc() : super(GroupDetailsState()) {
    on<FetchDetails>(_onFetchDetails);
  }

  Future<void> _onFetchDetails(FetchDetails event, Emitter<GroupDetailsState> emit) async {
    emit(state.copyWith(details: Details.loading));

    final api = Api();
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null) {
      emit(state.copyWith(
        details: Details.error,
        message: 'Token not found',
      ));
      return;
    }

    print('Retrieved token: $token');
    try {
      final response = await api.dio.get(
        "http://10.0.2.2:8080/user/groupDetails?groupid=${event.group_id}",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );



      if (response.statusCode == 200) {


        final list = response.data['data'];
        if (list == null) {
          emit(state.copyWith(
           detaillist: [],
            details: Details.success,
              message: "successfully  fetched"
          ));
          return;
        }

        emit(state.copyWith(
          detaillist: (list as List)
              .map((x) => DetailsModel.fromJson(x))
              .toList(),
          details: Details.success,
        ));
      } else {
        emit(state.copyWith(
          details: Details.error,
          message: 'Error while fetching exchanges: ${response.statusCode}',
        ));
      }
    } catch (e) {
      print('DioException: $e');
      emit(state.copyWith(
        details: Details.error,
        message: 'Failed to fetch exchange list',
      ));
    }
  }

}
