import 'package:app/models/ticket.dart';
import 'package:app/providers/ticket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageTicketsScreen extends ConsumerWidget {
  const ManageTicketsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tickets = ref.watch(ticketProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Tickets')),
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _editTicketDialog(context, ref, ticket);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              ref.read(ticketProvider.notifier).removeTicketById(ticket.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${ticket.title} removed')),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_new_movie');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _editTicketDialog(BuildContext context, WidgetRef ref, Ticket ticket) {
    final TextEditingController titleController = TextEditingController(text: ticket.title);
    final TextEditingController priceController = TextEditingController(text: ticket.price.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Ticket'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
              TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedTicket = Ticket(
                  id: ticket.id,
                  title: titleController.text.trim(),
                  price: double.parse(priceController.text.trim()),
                  category: ticket.category,
                );

                ref.read(ticketProvider.notifier).addTicket(updatedTicket);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ticket updated successfully!')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}