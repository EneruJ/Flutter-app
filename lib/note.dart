import 'package:hive/hive.dart';
part 'note.g.dart';

@HiveType(typeId: 1)
class Note extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String sBrut;

  @HiveField(2)
  final String statut;

  @HiveField(3)
  final String sNet;

  @HiveField(4)
  final String description;


  Note({
    required this.name,
    required this.sBrut,
    required this.statut,
    required this.sNet,
    required this.description,

  });
}