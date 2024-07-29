import 'package:floor/floor.dart';

@entity
class TBLWeeklySummary{
  @primaryKey
  final String id;
  final String income;
  final String expense;
  final String total;
  final String monthYear;
  final String createdAt;
  final String createdBy;
  final String updatedAt;
  final String updatedBy;
  TBLWeeklySummary({required this.id,required this.income,required this.expense,required this.total,required this.monthYear,required this.createdAt,required this.createdBy,required this.updatedAt,required this.updatedBy});

}