import 'package:floor/floor.dart';

@entity
class TBLProfile {
  @primaryKey
  String id;
  String full_name;
  String user_name;
  String password;
  String email_address;
  String phone_no;
  String image;
  String dob;
  String gender;
  String createdAt;
  String createdBy;
  String updatedAt;
  String updatedBy;

  TBLProfile(
      {required this.id,
      required this.full_name,
      required this.user_name,
      required this.password,
      required this.email_address,
      required this.phone_no,
      required this.image,
      required this.dob,
      required this.gender,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy});

  factory TBLProfile.fromJson(Map<String,dynamic> json){

    return TBLProfile(id: json['id'], full_name: json['full_name']!=null ? json['full_name']:'', user_name: json['username']!=null?json['username']:'', password: json['password']!=null?json['password']:'', email_address: json['email']!=null?json['email']:'', phone_no: json['phone'], image: json['image']!=null?json['image']:'', dob: json['dob']!=null?json['dob']:'', gender: json['gender']!=null?json['gender']:'', createdAt: json['created_at']!=null?json['created_at']:'', createdBy: json['created_by']!=null?json['created_by']:'', updatedAt: json['updated_at']!=null?json['updated_at']:'', updatedBy: json['updated_by']!=null?json['updated_by']:'');


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.full_name;
    data['username'] = this.user_name;
    data['password'] = this.password;
    data['email'] = this.email_address;
    data['phone'] = this.phone_no;
    data['image'] = this.image;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    return data;
  }
}
