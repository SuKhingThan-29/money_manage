import 'package:floor/floor.dart';

@entity
class TBLStatus{
  @primaryKey
  final String id;
  final String categoryName;
  final String type;
  final String amount;
  final String percent;
  final String color;
  final String monthYear;
  final String createdAt;
  final String createdBy;
  final String updatedAt;
  final String updatedBy;
  TBLStatus({required this.id,required this.categoryName,required this.type,required this.amount,required this.percent,required this.color,required this.monthYear,required this.createdAt,required this.createdBy,required this.updatedAt,required this.updatedBy});


}