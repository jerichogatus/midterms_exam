import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ticket.dart';

// StateNotifierProvider to manage cart state
final cartProvider = StateNotifierProvider<CartNotifier, List<Ticket>>((ref) {
  return CartNotifier();
});

// Notifier to handle cart-related logic
class CartNotifier extends StateNotifier<List<Ticket>> {
  CartNotifier() : super([]);

  // Add a ticket to the cart
  void addToCart(Ticket ticket) {
    if (!state.any((t) => t.id == ticket.id)) {
      state = [...state, ticket]; // Add the ticket if it doesn't already exist
    }
  }

  // Remove a ticket from the cart by ID
  void removeFromCart(int id) {
    state = state.where((ticket) => ticket.id != id).toList();
  }

  // Clear all items from the cart
  void clearCart() {
    state = [];
  }

  // Get the total price of all tickets in the cart
  double getTotalPrice() {
    return state.fold(0.0, (total, ticket) => total + ticket.price);
  }
}