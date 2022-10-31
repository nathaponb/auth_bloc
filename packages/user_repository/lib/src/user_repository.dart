import 'dart:async';

import 'package:user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class UserRepository {
  // User? _user is demonstrated to holding a User data from Database
  User? _user;

  Future<User?> getUser(String username) async {
    // why we null check here?
    // since this is just a DB mock up, data is on memery and therefore if there is one return it.
    if (_user != null) return _user;
    return Future.delayed(
      Duration(milliseconds: 300),
      () => _user = User(
        id: Uuid().v4(),
        username: 'nathapon',
        firstName: 'nathapon',
        lastName: 'dev',
      ),
    );
  }
}
