import 'package:isar/isar.dart';

part 'ticket.g.dart';

@collection
class Ticket {
  Id id = Isar.autoIncrement;
  late String title;
  late double price;
  late String category;

  Ticket({this.id = Isar.autoIncrement, required this.title, required this.price, required this.category});
}