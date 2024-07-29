import 'package:floor/floor.dart';

@entity
class TBL_Daily{
  @primaryKey
  final String id;
  final String monthlySummaryID;
  final String date;
  final String monthYear;
  final String incomeAmount;
  final String expenseAmount;
  final String totalAmount;
  final String isUpload;
  final String isActive;
  final String createdAt;
  final String createdBy;
  final String updatedAt;
  final String updatedBy;
  TBL_Daily({required this.id,required this.monthlySummaryID,required this.date,required this.monthYear,required this.incomeAmount,required this.expenseAmount,required this.totalAmount,required this.isUpload,required this.isActive,required this.createdAt,required this.createdBy,required this.updatedAt,required this.updatedBy});

}