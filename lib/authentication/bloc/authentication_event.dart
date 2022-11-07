part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStatusChanged extends AuthenticationEvent {
  const AuthenticationStatusChanged(this.status, this.username);

  final AuthenticationStatus status;
  final String? username;

  @override
  List<Object> get props => [status];
}

class AuthenticationLogOutRequested extends AuthenticationEvent {}
