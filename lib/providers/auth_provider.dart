import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../database/database.dart';

// Provider for the Database instance
final databaseProvider = Provider<Database>((ref) => Database());

// StateNotifier to manage authentication state
final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  final database = ref.watch(databaseProvider);
  return AuthNotifier(database);
});

// Notifier to handle authentication logic
class AuthNotifier extends StateNotifier<User?> {
  final Database _database;

  AuthNotifier(this._database) : super(null);

  // Login method
  Future<bool> login(String email, String password) async {
    final user = await _database.getUserByEmail(email);
    if (user != null && user.password == password) {
      state = user; // Set the authenticated user state
      return true;  // Login successful
    }
    return false;   // Login failed
  }

  // Signup method
  Future<bool> signUp(String email, String password, String role) async {
    final existingUser = await _database.getUserByEmail(email);
    if (existingUser == null) {
      // Create a new user
      final newUser = User(email: email, password: password, role: role);
      await _database.saveUser(newUser);
      state = newUser; // Set the authenticated user state
      return true;     // Signup successful
    }
    return false;      // Email already in use
  }

  // Logout method
  void logout() {
    state = null; // Clear the authenticated user state
  }

  // Check if the current user is an admin
  bool isAdmin() {
    return state?.role == 'admin';
  }
}