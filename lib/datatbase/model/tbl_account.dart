import 'package:floor/floor.dart';

@entity
class TBLAccount{
  @primaryKey
  final String id;
  final String name;
  final String amount;
  final String subAmount;
  final String accountGroupId;
  final String note;
  final String isUpload;
  final String isActive;
  final String createdAt;
  final String createdBy;
  final String updatedAt;
  final String updatedBy;
  TBLAccount(this.id,this.name,this.amount,this.subAmount,this.accountGroupId,this.note,this.isUpload,this.isActive,this.createdAt,this.createdBy,this.updatedAt,this.updatedBy);

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> requestData=Map<String,dynamic>();
    requestData['id']=this.id;
    requestData['name']=this.name;
    requestData['amount']=this.amount;
    requestData['subAmount']=this.subAmount;
    requestData['accountGroup']=this.accountGroupId;
    requestData['note']=this.note;
    requestData['isActive']=this.isActive;
    requestData['createdAt']=this.createdAt;
    requestData['createdBy']=this.createdBy;
    requestData['updatedAt']=this.updatedAt;
    requestData['updatedBy']=this.updatedBy;
    return requestData;
  }

  factory TBLAccount.fromJson(Map<String,dynamic> jsonData){
    return TBLAccount(jsonData['id'], jsonData['name'], jsonData['amount'], jsonData['subAmount'], jsonData['accountGroup'], jsonData['note'],'true',jsonData['isActive'], jsonData['createdAt'], jsonData['createdBy'], jsonData['updatedAt'], jsonData['updatedBy']);
  }
}