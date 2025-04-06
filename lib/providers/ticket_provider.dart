import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ticket.dart';
import '../database/database.dart';

// Provider for the Database instance
final databaseProvider = Provider<Database>((ref) => Database());

// StateNotifierProvider for managing the ticket state
final ticketProvider = StateNotifierProvider<TicketNotifier, List<Ticket>>((ref) {
  final database = ref.watch(databaseProvider);
  return TicketNotifier(database);
});

// Notifier to handle ticket-related operations
class TicketNotifier extends StateNotifier<List<Ticket>> {
  final Database _database;

  TicketNotifier(this._database) : super([]) {
    _loadTickets(); // Load tickets when initialized
  }

  // Fetch all tickets from the database
  Future<void> _loadTickets() async {
    state = await _database.getAllTickets();
  }

  // Add a new ticket to the database
  Future<void> addTicket(Ticket ticket) async {
    await _database.saveTicket(ticket);
    state = [...state, ticket]; // Update the state with the new ticket
  }

  // Remove a ticket by ID from the database
  Future<void> removeTicketById(int id) async {
    await _database.deleteTicket(id);
    state = state.where((ticket) => ticket.id != id).toList(); // Update state without the removed ticket
  }

  // Filter tickets by category
  Future<void> filterTicketsByCategory(String category) async {
    if (category == 'All') {
      await _loadTickets(); // Reload all tickets
    } else {
      state = await _database.getTicketsByCategory(category); // Fetch filtered tickets
    }
  }
}