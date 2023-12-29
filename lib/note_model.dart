import 'package:hive/hive.dart';
part 'note_model.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String content;

  @HiveField(2)
  late String? date;

  Note({required this.title, required this.content, this.date});
}
