import '../models/user.dart';
import '../database/database.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthService {
  final Database _database;

  AuthService(this._database);

  // Hash password using SHA256 (better security)
  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // Sign up new user
  Future<bool> signUp(String email, String password, String role) async {
    final existingUser = await _database.getUserByEmail(email);
    if (existingUser != null) {
      return false; // Email already exists
    }

    final hashedPassword = _hashPassword(password);
    final newUser = User(email: email, password: hashedPassword, role: role);
    await _database.saveUser(newUser);
    return true; // Signup successful
  }

  // Login user
  Future<User?> login(String email, String password) async {
    final user = await _database.getUserByEmail(email);
    if (user != null && user.password == _hashPassword(password)) {
      return user; // Successful login
    }
    return null; // Login failed
  }

  // Check if user is an admin
  Future<bool> isAdmin(String email) async {
    final user = await _database.getUserByEmail(email);
    return user?.role == 'admin';
  }

  // Get authenticated user session
  Future<User?> getCurrentUser() async {
    return await _database.getUserByEmail('stored_email'); // Modify based on session storage
  }
}