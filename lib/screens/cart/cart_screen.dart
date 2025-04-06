import 'package:app/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: cartItems.isEmpty
            ? const Center(child: Text('Your cart is empty'))
            : ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final ticket = cartItems[index];
                  return ListTile(
                    title: Text(ticket.title),
                    subtitle: Text('Price: \$${ticket.price.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        ref.read(cartProvider.notifier).removeFromCart(ticket.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${ticket.title} removed from cart')),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: cartItems.isNotEmpty ? () {} : null, // Add checkout logic here
          child: Text('Checkout (\$${cartItems.fold(0.0, (total, ticket) => total + ticket.price).toStringAsFixed(2)})'),
        ),
      ),
    );
  }
}