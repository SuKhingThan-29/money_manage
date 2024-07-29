import 'package:floor/floor.dart';

@entity
class TBLAccountGroup{
  @primaryKey
  final String id;
  final String name;
  final String total;
  final String isUpload;
  final String isActive;
  final String createdAt;
  final String createdBy;
  final String updatedAt;
  final String updatedBy;
  TBLAccountGroup(this.id,this.name,this.total,this.isUpload,this.isActive,this.createdAt,this.createdBy,this.updatedAt,this.updatedBy);

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> requestData=Map<String,dynamic>();
    requestData['id']=this.id;
    requestData['name']=this.name;
    requestData['total']=this.total;
    requestData['isActive']=this.isActive;
    requestData['createdAt']=this.createdAt;
    requestData['createdBy']=this.createdBy;
    requestData['updatedAt']=this.updatedAt;
    requestData['updatedBy']=this.updatedBy;
    return requestData;
  }
  factory TBLAccountGroup.fromJson(Map<String,dynamic> jsonData){
    return TBLAccountGroup(jsonData['id'], jsonData['name'], jsonData['total'],'' ,jsonData['isActive'],jsonData['createdAt'], jsonData['createdBy'], jsonData['updatedAt'], jsonData['updatedBy']);
  }
}