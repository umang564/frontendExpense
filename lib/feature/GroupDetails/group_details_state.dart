part of 'group_details_bloc.dart';

@immutable
class GroupDetailsState extends Equatable {
  final Details details;
  final List<DetailsModel> detaillist;
  final String message;
  final String url;


  const GroupDetailsState({
    this.details = Details.loading,
    this.detaillist = const <DetailsModel>[],
    this.message = '',
    this.url =''
  });

  GroupDetailsState copyWith({
    Details? details,
    List<DetailsModel>? detaillist,
    String? message,
    String? url
  }) {
    return GroupDetailsState(
      details: details ?? this.details,
      detaillist: detaillist ?? this.detaillist,
      message: message ?? this.message,
      url: url ?? this.url
    );
  }

  @override
  List<Object?> get props => [details, detaillist, message,url];
}
