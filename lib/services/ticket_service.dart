import '../models/ticket.dart';
import '../database/database.dart';

class TicketService {
  final Database _database;

  TicketService(this._database);

  // Add a new ticket
  Future<void> addTicket(Ticket ticket) async {
    await _database.saveTicket(ticket);
  }

  // Retrieve all tickets
  Future<List<Ticket>> getAllTickets() async {
    return await _database.getAllTickets();
  }

  // Get tickets by category
  Future<List<Ticket>> getTicketsByCategory(String category) async {
    return await _database.getTicketsByCategory(category);
  }

  // Delete a ticket
  Future<void> deleteTicket(int id) async {
    await _database.deleteTicket(id);
  }
}