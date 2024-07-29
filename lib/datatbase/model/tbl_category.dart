import 'package:floor/floor.dart';

@entity
class TBLCategory{
  @primaryKey
  final String id;
  final String name;
  final String type;
  final String color;
  final String monthYear;
  final String isUpload;
  final String isActive;
  final String createdAt;
  final String updatedAt;
  final String createdBy;
  final String updatedBy;
  TBLCategory({required this.id,required this.name,required this.type,required this.color,required this.monthYear,required this.isUpload,required this.isActive,required this.createdAt,required this.updatedAt,required this.createdBy,required this.updatedBy});

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> requestData=Map<String,dynamic>();
    requestData['id']=this.id;
    requestData['name']=this.name;
    requestData['type']=this.type;
    requestData['color']=this.color;
    requestData['monthYear']=this.monthYear;
    requestData['isActive']=this.isActive;
    requestData['createdAt']=this.createdAt;
    requestData['updatedAt']=this.updatedAt;
    requestData['createdBy']=this.createdBy;
    requestData['updatedBy']=this.updatedBy;
    return requestData;
  }

  factory TBLCategory.fromJson(Map<String,dynamic> jsonData){
    return TBLCategory(id: jsonData['id'], name: jsonData['name'], type: jsonData['type'], color: jsonData['color'], monthYear: jsonData['monthYear'],isUpload: '',isActive: jsonData['isActive'], createdAt: jsonData['createdAt'], updatedAt: jsonData['updatedAt'], createdBy: jsonData['createdBy'], updatedBy: jsonData['updatedBy']);
  }
}