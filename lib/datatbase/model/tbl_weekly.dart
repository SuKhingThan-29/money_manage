import 'package:floor/floor.dart';

@entity
class TBL_Weekly {
  @primaryKey
  final String id;
  final String weekly;
  final String monthYear;
  final String income;
  final String expense;
  final String createdAt;
  final String createdBy;
  final String updatedAt;
  final String updatedBy;
  TBL_Weekly({required this.id,required this.weekly,required this.monthYear,required this.income,required this.expense,required this.createdAt,required this.createdBy,required this.updatedAt,required this.updatedBy});

}
