import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'view_member_event.dart';
part 'view_member_state.dart';

class ViewMemberBloc extends Bloc<ViewMemberEvent, ViewMemberState> {
  ViewMemberBloc() : super(ViewMemberInitial()) {
    on<ViewMemberEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
