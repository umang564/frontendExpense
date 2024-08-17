part of 'group_details_bloc.dart';

@immutable
class GroupDetailsState extends Equatable {
  final Details details;
  final List<DetailsModel> detaillist;
  final String message;

  const GroupDetailsState({
    this.details = Details.loading,
    this.detaillist = const <DetailsModel>[],
    this.message = '',
  });

  GroupDetailsState copyWith({
    Details? details,
    List<DetailsModel>? detaillist,
    String? message,
  }) {
    return GroupDetailsState(
      details: details ?? this.details,
      detaillist: detaillist ?? this.detaillist,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [details, detaillist, message];
}
