import 'package:floor/floor.dart';

@entity
class Todo {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String title;
  final String type;
  final String date;
  final bool finished;
  final String? email;

  Todo({ this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.finished,
    this.email,});
}