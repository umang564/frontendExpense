part of 'group_details_bloc.dart';

@immutable
sealed class GroupDetailsEvent extends Equatable {}

class FetchDetails extends GroupDetailsEvent {
   FetchDetails({required this.group_id});

  final int group_id;

  @override
  List<Object> get props => [group_id];
}
