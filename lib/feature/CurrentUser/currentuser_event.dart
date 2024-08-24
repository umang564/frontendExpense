part of 'currentuser_bloc.dart';

@immutable
sealed class CurrentuserEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class FetchCurrentUserDetails extends CurrentuserEvent{}



