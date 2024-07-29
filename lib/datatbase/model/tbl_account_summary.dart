import 'package:floor/floor.dart';
@entity
class TBLAccountSummary{
  @primaryKey
  final String id;
  final String account;
  final String liabilities;
  final String total;
  final String isActive;
  final String createdAt;
  final String createdBy;
  final String updatedAt;
  final String updatedBy;
  TBLAccountSummary({required this.id,required this.account,required this.liabilities,required this.total,required this.isActive
  ,required this.createdAt,required this.createdBy,required this.updatedAt,required this.updatedBy});

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> requestData=Map<String,dynamic>();
    requestData['id']=this.id;
    requestData['account']=this.account;
    requestData['liabilities']=this.liabilities;
    requestData['total']=this.total;
    requestData['isActive']=this.isActive;
    requestData['createdBy']=this.createdBy;
    requestData['createdAt']=this.createdAt;
    requestData['updatedAt']=this.updatedAt;
    requestData['updatedBy']=this.updatedBy;
    return requestData;
  }
  factory TBLAccountSummary.fromJson(Map<String,dynamic> jsonData){
    return TBLAccountSummary(id: jsonData['id'], account: jsonData['account'], liabilities: jsonData['liabilities'], total: jsonData['total'], isActive: jsonData['isActive'],createdAt: jsonData['createdAt'], createdBy: jsonData['createdBy'], updatedAt: jsonData['updatedAt'], updatedBy: jsonData['updatedBy']);
  }
}
