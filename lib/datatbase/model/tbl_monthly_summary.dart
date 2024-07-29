import 'package:floor/floor.dart';

@entity
class TBLMonthlySummary{
  @primaryKey
  final String id;
  final String monthYear;
  final String year;
  final String incomeAmount;
  final String expenseAmount;
  final String total;
  final String isUpload;
  final String isActive;
  final String createdAt;
  final String createdBy;
  final String updatedAt;
  final String updatedBy;

  TBLMonthlySummary({required this.id,required this.monthYear,required this.year,required this.incomeAmount,required this.expenseAmount,required this.total,required this.isUpload,required this.isActive,required this.createdAt,required this.createdBy,required this.updatedAt,required this.updatedBy});
  Map<String,dynamic> toJson(){
    final Map<String,dynamic> maps=Map<String,dynamic>();
    maps['id']=this.id;
    maps['monthYear']=this.monthYear;
    maps['year']=this.year;
    maps['incomeAmount']=this.incomeAmount;
    maps['expenseAmount']=this.expenseAmount;
    maps['total']=this.total;
    maps['isActive']=this.isActive;
    maps['createdAt']=this.createdAt;
    maps['createdBy']=this.createdBy;
    maps['updatedAt']=this.updatedAt;
    maps['updatedBy']=this.updatedBy;
    return maps;
  }
  factory TBLMonthlySummary.fromJson(Map<String,dynamic> jsonData){
    return TBLMonthlySummary(id: jsonData['id'], monthYear: jsonData['monthYear'], year: jsonData['year'], incomeAmount: jsonData['incomeAmount'], expenseAmount: jsonData['expenseAmount'], total: jsonData['total'],isUpload: '',isActive: jsonData['isActive'], createdAt: jsonData['createdAt'], createdBy: jsonData['createdBy'], updatedAt: jsonData['updatedAt'], updatedBy: jsonData['updatedBy']);
  }


}