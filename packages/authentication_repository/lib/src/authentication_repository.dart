import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';

class AuthenticationRepository {
  final _controller = StreamController<Authentication>();
  static const _username = 'nathapon';
  static const _password = '12345';

  Stream<Authentication> get status async* {
    await Future<void>.delayed(Duration(seconds: 1));
    yield Authentication(status: AuthenticationStatus.unauthenticated);
    yield* _controller.stream;
  }

  // Doesn't actually implement authentication logic yet
  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    if (username != _username || password != _password) {
      _controller.add(
        Authentication(status: AuthenticationStatus.unauthenticated),
      );
      return;
    }
    // delayed => Duration duration, FutureOr<void> Function()?
    await Future<void>.delayed(
      Duration(microseconds: 300),
      () => _controller.add(
        Authentication(
          status: AuthenticationStatus.authenticated,
          username: username,
        ),
      ),
    );
  }

  void logOut() {
    _controller.add(Authentication(
      status: AuthenticationStatus.unauthenticated,
    ));
  }

  // release memory allocation in final stage.
  void dispose() => _controller.close();
}
