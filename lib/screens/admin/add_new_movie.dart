import 'package:app/database/database.dart';
import 'package:app/models/ticket.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class AddNewMovie extends StatefulWidget {
  const AddNewMovie({super.key});

  @override
  State<AddNewMovie> createState() => _AddNewMovieState();
}

class _AddNewMovieState extends State<AddNewMovie> {
  final titleController = TextEditingController();
  final categoryController = TextEditingController();
  final priceController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    categoryController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isar = Isar.getInstance(); // Retrieve the Isar instance
    if (isar == null) {
      throw Exception("Isar instance not found. Initialize Isar in main.dart.");
    }

    final database = Database(); // Initialize the Database without arguments

    return Scaffold(
      appBar: AppBar(title: const Text("Add New Movie")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Movie Title"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: "Category"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                final category = categoryController.text.trim();
                final price = double.tryParse(priceController.text.trim());
                final messenger = ScaffoldMessenger.of(context);

                if (title.isEmpty || category.isEmpty || price == null) {
                  messenger.showSnackBar(
                    const SnackBar(content: Text("Please fill all fields correctly")),
                  );
                  return;
                }

                try {
                  final newTicket = Ticket(title: title, category: category, price: price);
                  await database.saveTicket(newTicket);

                  if (!mounted) return;

                  messenger.showSnackBar(
                    SnackBar(content: Text("Movie '$title' added successfully!")),
                  );

                  titleController.clear();
                  categoryController.clear();
                  priceController.clear();
                } catch (e) {
                  if (!mounted) return;

                  messenger.showSnackBar(
                    SnackBar(content: Text("Failed to add movie: $e")),
                  );
                }
              },
              child: const Text("Add Movie"),
            ),
          ],
        ),
      ),
    );
  }
}