import 'package:isar/isar.dart';

part 'user.g.dart';

@collection
class User {
  Id id = Isar.autoIncrement;
  late String email;
  late String password;
  late String role;

  User({required this.email, required this.password, required this.role});

  User copyWith({String? email, String? password, String? role}) {
    return User(
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }
}