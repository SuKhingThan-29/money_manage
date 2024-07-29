import 'package:floor/floor.dart';

@entity
class TBL_DailyDetail{
  @primaryKey
  final String id;
  final String date;
  final String monthYear;
  final String dailyId;
  final String accountName;
  final String categoryName;
  final String toAccountName;
  final String accountId;
  final String categoryId;
  final String toAccountId;
  final String amount;
  final String note;
  final String other;
  final String type;
  final String bookmark;
  final String image;
  final String isUpload;
  final String isActive;
  final String createdBy;
  final String createdAt;
  final String updatedAt;
  final String updatedBy;
  TBL_DailyDetail({required this.id,required this.date,required this.monthYear,required this.dailyId,required this.accountName,required this.toAccountName,required this.categoryName,required this.accountId,required this.categoryId,required this.toAccountId,required this.amount,required this.note,required this.other,required this.type,required this.bookmark,required this.image,required this.isUpload,required this.isActive,required this.createdAt,required this.createdBy,required this.updatedAt,required this.updatedBy});

  Map<String,dynamic> toJson(){
   final Map<String,dynamic> data=Map<String,dynamic>();
   data['id']=this.id;
   data['date']=this.date;
   data['monthYear']=this.monthYear;
   data['dailyId']=this.dailyId;
   data['accountName']=this.accountName;
   data['categoryName']=this.categoryName;
   data['toAccountName']=this.toAccountName;
   data['accountId']=this.accountId;
   data['categoryId']=this.categoryId;
   data['toAccountId']=this.toAccountId;
   data['amount']=this.amount;
   data['note']=this.note;
   data['other']=this.other;
   data['type']=this.type;
   data['bookmark']=this.bookmark;
   data['image']=this.image;
   data['isActive']=this.isActive;
   data['createdBy']=this.createdBy;
   data['createdAt']=this.createdAt;
   data['updatedBy']=this.updatedBy;
   data['updatedAt']=this.updatedAt;
   return data;

  }
  factory TBL_DailyDetail.fromJson(Map<String,dynamic> jsonData){
    return TBL_DailyDetail(id: jsonData['id'], date: jsonData['date'], monthYear: jsonData['monthYear'], dailyId: jsonData['dailyId'], accountName: jsonData['accountName'], toAccountName: jsonData['toAccountName'], categoryName: jsonData['categoryName'], accountId: jsonData['accountId'], categoryId: jsonData['categoryId'], toAccountId: jsonData['toAccountId'], amount: jsonData['amount'], note: jsonData['note']??'', other: jsonData['other'], type: jsonData['type'], bookmark: jsonData['bookmark'], image: jsonData['image'],isUpload: '',isActive: jsonData['isActive'], createdAt: jsonData['createdAt'], createdBy: jsonData['createdBy'], updatedAt: jsonData['updatedAt'], updatedBy: jsonData['updatedBy']);
  }
}