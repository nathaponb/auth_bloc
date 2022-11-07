import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:auth_bloc/authentication/authentication.dart';
import 'package:user_repository/user_repository.dart' hide User;

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(const AuthenticationState.unknown()) {
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationLogOutRequested>(_onAuthenticationLogOutRequested);

    // subscript to authentication stream and listen on its change
    // Stream<authentication> consists of 2 things status and username?
    // so we listen on it whenever it changed, we transfer it as an event of AuthenticationStatusChanged
    _authenticationSubscription = _authenticationRepository.status.listen(
      // bloc add(event)
      (auth) => add(
        AuthenticationStatusChanged(
          auth.status,
          auth.username,
        ),
      ),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  late StreamSubscription<Authentication> _authenticationSubscription;

  Future<void> _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthenticationStatus.authenticated:
        // when a user is authenticated, we got username streams back
        // if it is authenticated, we are sure username will come along from authentication_repository stream.
        final user = await _tryGetUser(event.username!);
        return emit(
          user != null
              ? AuthenticationState.authenticated(user)
              : const AuthenticationState.unauthenticated(),
        );
      case AuthenticationStatus.unknown:
        return emit(const AuthenticationState.unknown());
    }
  }

  void _onAuthenticationLogOutRequested(
    AuthenticationLogOutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    _authenticationRepository.logOut();
  }

  Future<User?> _tryGetUser(String username) async {
    // Note: User model of Bloc and User model of User_repository is inexchangeable eventhough it has the same exact signatures.
    // here, we retrieve User of User_repository and convert it to Bloc model User
    // It could be done by using User of User_repository directly, but that seems anti pattern to me (31/10/22)
    try {
      final user = await _userRepository
          .getUser(username); // this user type is User of User_repository
      return user != null
          ? User(
              id: user.id,
              username: user.username,
              firstName: user.firstName,
              lastName: user.lastName)
          : User
              .empty; // normally, if username is authenticated, this should't be the case to get invoked.
    } catch (_) {
      return null;
    }
  }

  // cancel Stream and release memory allocation.
  @override
  Future<void> close() {
    _authenticationSubscription.cancel();
    _authenticationRepository.dispose();
    return super.close();
  }
}
