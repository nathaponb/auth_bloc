import 'dart:async';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  // Doesn't actually implement authentication logic yet
  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    // delayed => Duration duration, FutureOr<void> Function()?
    await Future<void>.delayed(
      Duration(microseconds: 300),
      () => _controller.add(
        AuthenticationStatus.authenticated,
      ),
    );
  }

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  // release memory allocation in final stage.
  void dispose() => _controller.close();
}
