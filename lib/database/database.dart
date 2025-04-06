import 'dart:convert';
import 'dart:developer' as developer;
import 'package:crypto/crypto.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/ticket.dart';
import '../models/user.dart';

class Database {
  static Isar? _isar;

  // Singleton pattern for Isar instance
  static Future<Isar> getInstance() async {
    if (_isar != null) {
      return _isar!;
    }

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [TicketSchema, UserSchema], // Register schemas
      directory: dir.path,
    );
    return _isar!;
  }

  // ----------- Ticket Operations -----------

  Future<void> saveTicket(Ticket ticket) async {
    try {
      final isar = await getInstance();
      await isar.writeTxn(() async {
        await isar.tickets.put(ticket); // Save ticket
      });
    } catch (e) {
      developer.log("Error saving ticket: $e", name: "Database");
    }
  }

  Future<List<Ticket>> getAllTickets() async {
    try {
      final isar = await getInstance();
      return await isar.tickets.where().findAll(); // Fetch all tickets
    } catch (e) {
      developer.log("Error fetching tickets: $e", name: "Database");
      return [];
    }
  }

  Future<List<Ticket>> getTicketsByCategory(String category) async {
    try {
      final isar = await getInstance();
      return await isar.tickets.filter().categoryEqualTo(category).findAll(); // Filter by category
    } catch (e) {
      developer.log("Error fetching tickets by category: $e", name: "Database");
      return [];
    }
  }

  Future<void> deleteTicket(int id) async {
    try {
      final isar = await getInstance();
      await isar.writeTxn(() async {
        await isar.tickets.delete(id); // Delete ticket
      });
    } catch (e) {
      developer.log("Error deleting ticket: $e", name: "Database");
    }
  }

  // ----------- User Operations -----------

  Future<void> saveUser(User user) async {
    try {
      final isar = await getInstance();
      await isar.writeTxn(() async {
        await isar.users.put(user); // Save user
      });
    } catch (e) {
      developer.log("Error saving user: $e", name: "Database");
    }
  }

  Future<User?> getUserByEmail(String email) async {
    try {
      final isar = await getInstance();
      return await isar.users.filter().emailEqualTo(email).findFirst(); // Find user by email
    } catch (e) {
      developer.log("Error fetching user by email: $e", name: "Database");
      return null;
    }
  }

  Future<bool> validateUser(String email, String password) async {
    try {
      final user = await getUserByEmail(email);
      if (user != null) {
        final hashedPassword = sha256.convert(utf8.encode(password)).toString();
        return user.password == hashedPassword; // Successful authentication
      }
    } catch (e) {
      developer.log("Error validating user: $e", name: "Database");
    }
    return false; // Invalid credentials
  }

  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }
}