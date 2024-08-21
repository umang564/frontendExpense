import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterproject/feature/model/moneyExchangeModel.dart';
import 'package:flutterproject/feature/utils/enums.dart';
import 'package:dio/dio.dart';
import 'package:flutterproject/feature/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterproject/feature/constant.dart';

part 'exchange_event.dart';
part 'exchange_state.dart';

class ExchangeBloc extends Bloc<ExchangeEvent, ExchangeState> {
  ExchangeBloc() : super(ExchangeState()) {
    on<GroupIdChanged>(_onGroupIdChanged);
    on<MemberNameChanged>(_onMemberNameChanged);
    on<MemberEmailChanged>(_onMemberEmailChanged);
    on<MemberIdChanged>(_onMemberIdChanged);
    on<FetchExchangeApi>(_onFetchExchangedApi);
    on<SettledApi>(_onSettledApi);
    on<WholeSettledApi>(_onWholeSettleApi);
    on<NotifyMember>(_onNotifyMember);

  }
 
  void _onGroupIdChanged(GroupIdChanged event, Emitter<ExchangeState> emit) {
    emit(state.copyWith(groupId: event.groupId));
  }

  void _onMemberNameChanged(MemberNameChanged event, Emitter<ExchangeState> emit) {
    emit(state.copyWith(memberName: event.memberName));
  }

  void _onMemberEmailChanged(MemberEmailChanged event, Emitter<ExchangeState> emit) {
    emit(state.copyWith(memberEmail: event.memberEmail));
  }

  void _onMemberIdChanged(MemberIdChanged event, Emitter<ExchangeState> emit) {
    emit(state.copyWith(memberId: event.memberId));
  }



Future<void>_onNotifyMember(NotifyMember event,Emitter<ExchangeState>emit)async{
  final api = Api();
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'token');

  if (token == null) {
    emit(state.copyWith(
      exchangeStatus: ExchangeStatus.error,
      message: "Token not found",
    ));
    return;
  }

  print('Retrieved token: $token');

  try {
    final response = await api.dio.post(
      "$BASE_URL/user/notify",
      data: {"Member_id":state.memberId,"Total_amount":state.totalAmount},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    print('Response data: ${response.data}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      emit(state.copyWith(
        exchangeStatus: ExchangeStatus.success,
        message: "Successfully notified",
      ));
    } else {
      emit(state.copyWith(
        exchangeStatus: ExchangeStatus.error,
        message: "Failed to notify: ${response.statusMessage}",
      ));
    }
  } catch (e) {
    emit(state.copyWith(
      exchangeStatus: ExchangeStatus.error,
      message: "Exception occurred while notify: ${e.toString()}",
    ));
  }

}


Future<void>_onWholeSettleApi(WholeSettledApi event ,Emitter<ExchangeState>emit)async{
  final api = Api();
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'token');

  if (token == null) {
    emit(state.copyWith(
      exchangeStatus: ExchangeStatus.error,
      message: "Token not found",
    ));
    return;
  }

  print('Retrieved token: $token');
  int groupid=state.groupId;
  int memberid=state.memberId;
  try {
    final response = await api.dio.delete(
      "$BASE_URL/user/allsettle?groupid=$groupid&memberid=$memberid",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    print('Response data: ${response.data}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      emit(state.copyWith(
        exchangeStatus: ExchangeStatus.success,
        message: "Successfully deleted debit entry",
      ));
    } else {
      emit(state.copyWith(
        exchangeStatus: ExchangeStatus.error,
        message: "Failed to delete debit entry: ${response.statusMessage}",
      ));
    }
  } catch (e) {
    emit(state.copyWith(
      exchangeStatus: ExchangeStatus.error,
      message: "Exception occurred while deleting debit entry: ${e.toString()}",
    ));
  }
}





  Future<void> _onSettledApi(SettledApi event, Emitter<ExchangeState> emit) async {
    emit(state.copyWith(exchangeStatus: ExchangeStatus.loading));
    final api = Api();
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null) {
      emit(state.copyWith(
        exchangeStatus: ExchangeStatus.error,
        message: "Token not found",
      ));
      return;
    }

    print('Retrieved token: $token');
    try {
      final response = await api.dio.delete(
        "$BASE_URL/user/settleddebit",
        data: {'DebitId': event.debitID, "MemberID": state.memberId},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(state.copyWith(
          exchangeStatus: ExchangeStatus.success,
          message: "Successfully deleted debit entry",
        ));
      } else {
        emit(state.copyWith(
          exchangeStatus: ExchangeStatus.error,
          message: "Failed to delete debit entry: ${response.statusMessage}",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        exchangeStatus: ExchangeStatus.error,
        message: "Exception occurred while deleting debit entry: ${e.toString()}",
      ));
    }
  }











  Future<void> _onFetchExchangedApi(FetchExchangeApi event, Emitter<ExchangeState> emit) async {
    emit(state.copyWith(exchangeStatus: ExchangeStatus.loading));

    final api = Api();
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null) {
      emit(state.copyWith(
        exchangeStatus: ExchangeStatus.error,
        message: 'Token not found',
      ));
      return;
    }

    print('Retrieved token: $token');
    try {
      final response = await api.dio.get(
        "$BASE_URL/user/exchange?member_id=${state.memberId}&group_id=${state.groupId}",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      

      if (response.statusCode == 200) {
        final totalAmount = response.data['data']["TotalAmount"] ?? 0;

        final exchanges = response.data['data']["Exchanges"];
        if (exchanges == null) {
          emit(state.copyWith(
            exchangeList: [],
            totalAmount: totalAmount,
            exchangeStatus: ExchangeStatus.success,
          ));
          return;
        }

        emit(state.copyWith(
          exchangeList: (exchanges as List)
              .map((x) => MoneyExchangeModel.fromJson(x))
              .toList(),
          totalAmount: totalAmount,
          exchangeStatus: ExchangeStatus.success,
        ));
      } else {
        emit(state.copyWith(
          exchangeStatus: ExchangeStatus.error,
          message: 'Error while fetching exchanges: ${response.statusCode}',
        ));
      }
    } catch (e) {
      print('DioException: $e');
      emit(state.copyWith(
        exchangeStatus: ExchangeStatus.error,
        message: 'Failed to fetch exchange list',
      ));
    }
  }
}
