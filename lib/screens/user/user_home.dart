import 'package:app/providers/cart_provider.dart';
import 'package:app/providers/ticket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class UserHomeScreen extends ConsumerWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tickets = ref.watch(ticketProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart_screen'); // Navigate to cart page
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: tickets.isEmpty
            ? const Center(child: Text('No tickets available'))
            : ListView.builder(
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  final ticket = tickets[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(ticket.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Price: \$${ticket.price.toStringAsFixed(2)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
                        onPressed: () {
                          cartNotifier.addToCart(ticket);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${ticket.title} added to cart')),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}