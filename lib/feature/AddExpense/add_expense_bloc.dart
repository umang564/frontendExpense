import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutterproject/feature/utils/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutterproject/feature/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutterproject/feature/constant.dart';
import 'package:flutterproject/feature/Repository/viewMember.dart';
import 'package:flutterproject/feature/model/viewMemberModel.dart';

part 'add_expense_event.dart';
part 'add_expense_state.dart';

class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  AddExpenseBloc() : super(AddExpenseState()) {
    on<GivenByChanged>(_onGivenByChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<GroupIdChanged>(_onGroupIdChanged);
    on<AmountChanged>(_onAmountChanged);
    on<CategoryChanged>(_onCategoryChanged);
    on<ExpenseApi>(_onExpenseApi);
    on<MemberFetched>(_onMemberFetched);
    on<MembersSelected>(_onMemberSelected);
  }

  void _onGivenByChanged(GivenByChanged event ,Emitter<AddExpenseState>emit){
    emit(
state.copyWith(
  givenBy:event.GivenByEmail
));
  }
void _onMemberSelected(MembersSelected event,Emitter<AddExpenseState>emit){
emit(state.copyWith(selectedMemberIds:event.selectedMemberIds ));
}

  void _onDescriptionChanged(DescriptionChanged event,Emitter<AddExpenseState>emit){

    emit(
      state.copyWith(
        description: event.Description
      )
    );
  }


void _onGroupIdChanged( GroupIdChanged event ,Emitter<AddExpenseState>emit ){

   emit(
     state.copyWith(groupId: event.GroupId)
   );

}


  void _onAmountChanged( AmountChanged event ,Emitter<AddExpenseState>emit ){

    emit(
        state.copyWith(amount: event.Amount)
    );

  }




  void _onCategoryChanged( CategoryChanged event ,Emitter<AddExpenseState>emit ){

    emit(
        state.copyWith(category: event.Category)
    );

  }

Future<void>_onExpenseApi(ExpenseApi event ,Emitter<AddExpenseState>emit )async{
  emit(state.copyWith(addExpenseStatus: AddExpenseStatus.loading));
  final api = Api();
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'token');

  if (token == null) {
    emit(state.copyWith(
      addExpenseStatus: AddExpenseStatus.error,
      message: "Token not Found",
    ));
    return;
  }

  print('Retrieved token: $token');
   int id =state.groupId;
   print(state.selectedMemberIds);


  try {
    final response = await api.dio.post(
      "$BASE_URL/user/addmoney?id=$id",
      data: {'GivenByEmail': state.givenBy,'Amount':state.amount,'Category':state.category,'Description':state.description ,'MemberIDs':state.selectedMemberIds},
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
        addExpenseStatus: AddExpenseStatus.success,
        message: "Successfully Created Group",
      ));
    } else {
      emit(state.copyWith(
        addExpenseStatus: AddExpenseStatus.error,
        message: "Failed to Create Group: ${response.statusMessage}",
      ));
    }
  } catch (e) {
    if (e is DioException) {
      final errorMessage = e.response?.data['message'] ?? "An unexpected error occurred";

      emit(state.copyWith(
        addExpenseStatus: AddExpenseStatus.error,
        message: errorMessage,
      ));


    } else {
      // Handle other types of exceptions
      print('Error: $e');
      emit(state.copyWith(
        addExpenseStatus: AddExpenseStatus.error,
        message: e.toString(),
      ));
    }
  }

}
  Future<void>_onMemberFetched(MemberFetched event ,Emitter<AddExpenseState>emit)async{
    emit(state.copyWith(addExpenseStatus: AddExpenseStatus.loading));
    try {
      // Await the result of fetchGroupName
      final memberList = await ViewRepository().fetchMemberGroup(id: state.groupId);
      // Ensure that the emit is called after the future completes
      emit(state.copyWith(
        addExpenseStatus: AddExpenseStatus.initial,
        message: 'Successful Fetching Of Api',
        memberlist: memberList,
      ));
    } catch (e) {

      // Handle the error and emit the failure state
      if (e is DioException) {
        final errorMessage = e.response?.data['message'] ?? "An unexpected error occurred";

        emit(state.copyWith(
          addExpenseStatus: AddExpenseStatus.error,
          message: errorMessage,
        ));


      } else {
        // Handle other types of exceptions
        print('Error: $e');
        emit(state.copyWith(
          addExpenseStatus: AddExpenseStatus.error,
          message: e.toString(),
        ));
      }
    }
  }
}
