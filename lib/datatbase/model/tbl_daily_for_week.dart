import 'package:floor/floor.dart';

@entity
class TBL_DailyForWeek{
  @primaryKey
  final String id;
  final String day;
  final String weeklyId;
  final String income;
  final String expense;
  final String createdAt;
  final String createdBy;
  final String updatedAt;
  final String updatedBy;
  TBL_DailyForWeek({required this.id,required this.day,required this.weeklyId,required this.income,required this.expense,required this.createdAt,required this.createdBy,required this.updatedAt,required this.updatedBy});
}