enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class Authentication {
  Authentication({
    required this.status,
    this.username,
  });

  AuthenticationStatus status;
  String? username;
}
