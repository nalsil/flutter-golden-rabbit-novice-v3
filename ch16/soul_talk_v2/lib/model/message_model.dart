import 'package:isar/isar.dart';
// import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@collection
class MessageModel {
  Id id = Isar.autoIncrement;
  bool isMine;
  String message;
  int? point;
  DateTime date;

  MessageModel({
    required this.isMine,
    required this.message,
    required this.date,
    this.id = Isar.autoIncrement,
    required this.point,
  });
}
