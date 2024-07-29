import 'package:floor/floor.dart';
@entity
class TBLExchange {
  @primaryKey
  final String id;
  final String name;
  final String price;
  final String createdBy;
  final String updatedBy;
  final String createdAt;
  final String updatedAt;

  TBLExchange(
      {required this.id, required this.name, required this.price, required this.createdAt, required this.createdBy, required this.updatedAt, required this.updatedBy});
}
