part of 'currentuser_bloc.dart';

@immutable
class CurrentuserState extends Equatable {
 final String name;
 final int id;
 final String email;
 final CurrentUserStatus currentUserStatus;

 const CurrentuserState({
   this.name='',
  this.id=0,
  this.email ='',
 this.currentUserStatus =CurrentUserStatus.intial,
 });

 CurrentuserState copyWith({
  String? name,
  int? id,
  String? email,
  CurrentUserStatus? currentUserStatus,
 }) {
  return CurrentuserState(
   name: name ?? this.name,
   id: id ?? this.id,
   email: email ?? this.email,
   currentUserStatus: currentUserStatus ?? this.currentUserStatus,
  );
 }

 @override
 List<Object?> get props => [name, id, email, currentUserStatus];
}


