import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
  });

  final String id;
  final String username;
  final String firstName;
  final String lastName;

  // for instantiate an empty User instance
  static const empty =
      User(id: '-', username: '-', firstName: '-', lastName: '-');

  @override
  List<Object?> get props => [id, username, firstName, lastName];
}
