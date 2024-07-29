
import 'package:AthaPyar/datatbase/model/tbl_account.dart';
import 'package:AthaPyar/datatbase/model/tbl_account_group.dart';
import 'package:AthaPyar/datatbase/model/tbl_account_summary.dart';
import 'package:AthaPyar/datatbase/model/tbl_category.dart';
import 'package:AthaPyar/datatbase/model/tbl_dailyDetail.dart';
import 'package:AthaPyar/datatbase/model/tbl_gold.dart';
import 'package:AthaPyar/datatbase/model/tbl_monthly_summary.dart';

import '../models/UserGuide.dart';

class ResponseSms {
  final String register;

  ResponseSms({required this.register});

  factory ResponseSms.fromJson(Map<String, dynamic> json) {
    return ResponseSms(register: json['register']);
  }
}



class RequestLogin {
  final String phone;
  final String password;

  RequestLogin({required this.phone, required this.password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['phone'] = this.phone;
    data['password'] = this.password;

    return data;
  }
}

class RequestLoginByDeviceId{
  final String phone;
  final String password;
  final String deviceId;

  RequestLoginByDeviceId({required this.phone, required this.password,required this.deviceId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['device_id'] = this.deviceId;
    return data;
  }
}

class RequestSmsOTP {
  String to;
  String message;
  String sender;

  RequestSmsOTP(
      {required this.to, required this.message, required this.sender});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['to'] = this.to;
    data['message'] = this.message;
    data['sender'] = this.sender;
    return data;
  }
}

class RequestForgetPasswordSmsOTP {
  String phone;
  String forget_password;

  RequestForgetPasswordSmsOTP(
      {required this.phone, required this.forget_password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['phone'] = this.phone;
    data['forget_password'] = this.forget_password;
    return data;
  }
}

class RequestVerifyOtp {
  String otp;

  RequestVerifyOtp({required this.otp});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['otp'] = this.otp;
    return data;
  }
}
class AccountGroupRequest{
  final List<TBLAccountGroup> accountData;
  final String status;

  AccountGroupRequest({required this.accountData,required this.status});
  Map<String,dynamic> toJson(){
    final Map<String,dynamic> requestData=Map<String,dynamic>();
    requestData['data']=List<dynamic>.from(accountData.map((e) => e));
    return requestData;
  }
  factory AccountGroupRequest.fromJson(Map<String,dynamic> jsonData){
    if(jsonData['data'] !=null){
      var _dataList=jsonData['data'] as List;
      List<TBLAccountGroup> dataList=_dataList.map((e) => TBLAccountGroup.fromJson(e)).toList();
      return AccountGroupRequest(accountData: dataList,
        status: jsonData['status']
      );
    }else{
      return AccountGroupRequest(accountData: [],
      status: jsonData['status']);
    }
  }
}
class AccountRequest{
  final List<TBLAccount> accountData;
  final String status;

  AccountRequest({required this.accountData,required this.status});
  Map<String,dynamic> toJson(){
    final Map<String,dynamic> requestData=Map<String,dynamic>();
    requestData['data']=List<dynamic>.from(accountData.map((e) => e));
    return requestData;
  }
  factory AccountRequest.fromJson(Map<String,dynamic> jsonData){
    if(jsonData['data'] !=null){
      var _dataList=jsonData['data'] as List;
      List<TBLAccount> dataList=_dataList.map((e) => TBLAccount.fromJson(e)).toList();
      return AccountRequest(accountData: dataList,
          status: jsonData['status']
      );
    }else{
      return AccountRequest(accountData: [],
          status: jsonData['status']);
    }
  }
}
class AdsData{
  final String id;
  final String custom_IOS_ONOFF;
  final String custom_Android_ONOFF;
  final String custom_advertisement_IOS;
  final String custom_advertisement_Android;
  final String admod_IOS_ONOFF;
  final String admod_Android_ONOFF;
  final String options;
  final String Frequency_ONOFF;
  final String frequency;
  final String duration;
  final String site_url;
  AdsData({required this.id,required this.custom_IOS_ONOFF,required this.custom_Android_ONOFF,required this.custom_advertisement_IOS,required this.custom_advertisement_Android,required this.admod_IOS_ONOFF,required this.admod_Android_ONOFF,required this.options,required this.Frequency_ONOFF,required this.frequency,required this.duration,required this.site_url});
  factory AdsData.fromJson(Map<String,dynamic> jsonData){
    return AdsData(id: jsonData['id'], custom_IOS_ONOFF: jsonData['custom_IOS_ONOFF'], custom_Android_ONOFF: jsonData['custom_Android_ONOFF'], custom_advertisement_IOS: jsonData['custom_advertisement_IOS'], custom_advertisement_Android: jsonData['custom_advertisement_Android'], admod_IOS_ONOFF: jsonData['admod_IOS_ONOFF'], admod_Android_ONOFF: jsonData['admod_Android_ONOFF'], options: jsonData['options'], Frequency_ONOFF: jsonData['Frequency_ONOFF'], frequency: jsonData['frequency'], duration: jsonData['duration'],site_url: jsonData['site_url']);
  }
}
class UserGuideRequest{
  final List<UserGuide> userGuideList;
  final String status;
  final String message;
  UserGuideRequest({required this.message,required this.status,required this.userGuideList});
  factory UserGuideRequest.fromJson(Map<String,dynamic> jsonData){
    if(jsonData['data']!=null){
      var _dataList=jsonData['data'] as List;
      List<UserGuide> dataList=_dataList.map((e) => UserGuide.fromJson(e)).toList();
      return UserGuideRequest(message: jsonData['message'], status: jsonData['status'], userGuideList: dataList);
    }else{
      return UserGuideRequest(message: jsonData['message'], status: jsonData['status'], userGuideList: []);
    }
  }
}
class CategoryRequest{
  final List<TBLCategory> categoryData;
  final String status;

  CategoryRequest({required this.categoryData,required this.status});
  Map<String,dynamic> toJson(){
    final Map<String,dynamic> requestData=Map<String,dynamic>();
    requestData['data']=List<dynamic>.from(categoryData.map((e) => e));
    return requestData;
  }
  factory CategoryRequest.fromJson(Map<String,dynamic> jsonData){
    if(jsonData['data'] !=null){
      var _dataList=jsonData['data'] as List;
      List<TBLCategory> dataList=_dataList.map((e) => TBLCategory.fromJson(e)).toList();
      return CategoryRequest(categoryData: dataList,
          status: jsonData['status']
      );
    }else{
      return CategoryRequest(categoryData: [],
          status: jsonData['status']);
    }
  }
}
class AccountSummaryRequest{
  final List<TBLAccountSummary> accountSummaryData;
  final String status;

  AccountSummaryRequest({required this.accountSummaryData,required this.status});
  Map<String,dynamic> toJson(){
    final Map<String,dynamic> requestData=Map<String,dynamic>();
    requestData['data']=List<dynamic>.from(accountSummaryData.map((e) => e));
    return requestData;
  }
  factory AccountSummaryRequest.fromJson(Map<String,dynamic> jsonData){
    if(jsonData['data'] !=null){
      var _dataList=jsonData['data'] as List;
      List<TBLAccountSummary> dataList=_dataList.map((e) => TBLAccountSummary.fromJson(e)).toList();
      return AccountSummaryRequest(accountSummaryData: dataList,
          status: jsonData['status']
      );
    }else{
      return AccountSummaryRequest(accountSummaryData: [],
          status: jsonData['status']);
    }
  }
}
class MonthlySummaryRequest{
  final List<TBLMonthlySummary> summaryData;
  final String status;

  MonthlySummaryRequest({required this.summaryData,required this.status});
  Map<String,dynamic> toJson(){
    final Map<String,dynamic> requestData=Map<String,dynamic>();
    requestData['data']=List<dynamic>.from(summaryData.map((e) => e));
    return requestData;
  }
  factory MonthlySummaryRequest.fromJson(Map<String,dynamic> jsonData){
    if(jsonData['data'] !=null){
      var _dataList=jsonData['data'] as List;
      List<TBLMonthlySummary> dataList=_dataList.map((e) => TBLMonthlySummary.fromJson(e)).toList();
      return MonthlySummaryRequest(summaryData: dataList,
          status: jsonData['status']
      );
    }else{
      return MonthlySummaryRequest(summaryData: [],
          status: jsonData['status']);
    }
  }
}
class TermAndConditionRequest{
  final List<TermAndCondition> data;
  final String status;
  TermAndConditionRequest({required this.data,required this.status});
  factory TermAndConditionRequest.fromJson(Map<String,dynamic> jsonData){
    var _dataList=jsonData['data'] as List;
    List<TermAndCondition> dataList=_dataList.map((e) => TermAndCondition.fromJson(e)).toList();
    return TermAndConditionRequest(data: dataList, status: jsonData['status']);
  }
}

class GoldRequest{
  final List<TBLGold> data;
  final String status;
  GoldRequest({required this.data,required this.status});
  factory GoldRequest.fromJson(Map<String,dynamic> jsonData){
    var _dataList=jsonData['data'] as List;
    List<TBLGold> dataList=_dataList.map((e) => TBLGold.fromJson(e)).toList();
    return GoldRequest(data: dataList, status: jsonData['status']);
  }
}
class TermAndCondition{
  final String id;
  final String terms;
  final String terms_mm;
  TermAndCondition({required this.id,required this.terms,required this.terms_mm});
  factory TermAndCondition.fromJson(Map<String,dynamic> jsonData){
    return TermAndCondition(id: jsonData['id'], terms: jsonData['terms'], terms_mm: jsonData['terms_mm']);
  }
}
class AboutUsRequest{
  final String id;
  final String about;
  final String about_mm;
  final String flag;
  AboutUsRequest({required this.id,required this.about,required this.about_mm,required this.flag});
  factory AboutUsRequest.fromJson(Map<String,dynamic> jsonData){
    return AboutUsRequest(id: jsonData['id'], about: jsonData['about'],about_mm: jsonData['about_mm'], flag: jsonData['flag']);
  }
}
class DailyRequest {
  final List<Daily> daily;
  final String status;
  DailyRequest({required this.daily,required this.status});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> requestData = Map<String, dynamic>();
    requestData['data'] = List<dynamic>.from(daily.map((x) => x));

    return requestData;
  }
  factory DailyRequest.fromJson(Map<String,dynamic> jsonData){
    if(jsonData['data'] !=null){
      var _dataList=jsonData['data'] as List;
      List<Daily> dataList=_dataList.map((e) => Daily.fromJson(e)).toList();
      return DailyRequest(daily: dataList,
          status: jsonData['status']);
    }else{
      return DailyRequest(daily: [],
          status: jsonData['status']);
    }

  }
}

class Daily {
  final String id;
  final String summaryId;
  final String date;
  final String monthYear;
  final String incomeAmount;
  final String expenseAmount;
  final String totalAmount;
  final String isActive;
  final String createdAt;
  final String createdBy;
  final String updatedAt;
  final String updatedBy;
  List<TBL_DailyDetail> daily_detail;

  Daily(
      {required this.id,
      required this.summaryId,
      required this.date,
      required this.monthYear,
      required this.incomeAmount,
      required this.expenseAmount,
      required this.totalAmount,
        required this.isActive,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      required this.daily_detail});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['summaryId'] = this.summaryId;
    data['date'] = this.date;
    data['monthYear'] = this.monthYear;
    data['incomeAmount'] = this.incomeAmount;
    data['expenseAmount'] = this.expenseAmount;
    data['totalAmount'] = this.totalAmount;
    data['isActive']=this.isActive;
    data['createdAt'] = this.createdAt;
    data['createdBy'] = this.createdBy;
    data['updatedAt'] = this.updatedAt;
    data['updatedBy'] = this.updatedBy;
    data['daily_detail'] = List<dynamic>.from(daily_detail.map((x) => x));
    return data;
  }
  factory Daily.fromJson(Map<String,dynamic> jsonData){
    var _dataList=jsonData['daily_detail'] as List;
    List<TBL_DailyDetail> dataList=_dataList.map((e) => TBL_DailyDetail.fromJson(e)).toList();
    return Daily(id: jsonData['id'], summaryId: jsonData['summaryId']==null?'':jsonData['summaryId'], date: jsonData['date'], monthYear: jsonData['monthYear'], incomeAmount: jsonData['incomeAmount'], expenseAmount: jsonData['expenseAmount'], totalAmount: jsonData['totalAmount'],isActive: jsonData['isActive'], createdAt: jsonData['createdAt'], createdBy: jsonData['createdBy'], updatedAt: jsonData['updatedAt'], updatedBy: jsonData['updatedBy'], daily_detail: jsonData['daily_detail']!=null && jsonData['daily_detail']!=''?dataList:[]);
  }
}

class ResponseData {
  final String profileId;
  final String status;
  final String isRegister;

  ResponseData({required this.profileId, required this.status,required this.isRegister});

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    if (json['ProfileID'] != null) {
      return ResponseData(
          profileId: json['ProfileID'], status: json['status'],isRegister:json['isRegister']);
    } else {
      return ResponseData(profileId: '', status: json['status'],isRegister:json['isRegister']);
    }
  }
}


class ResponseProfileID {
  final String profileId;
  final String status;

  ResponseProfileID({required this.profileId, required this.status});

  factory ResponseProfileID.fromJson(Map<String, dynamic> json) {
    if (json['ProfileID'] != null) {
      return ResponseProfileID(
          profileId: json['ProfileID'], status: json['status']);
    } else {
      return ResponseProfileID(profileId: '', status: json['status']);
    }
  }
}

class ResponseStatus {
  String status;

  ResponseStatus({required this.status});

  factory ResponseStatus.fromJson(Map<String, dynamic> json) {
    return ResponseStatus(status: json['status']);
  }
}

class ResponseVerify {
  final String ProfileID;
  final String PhoneNo;
  final String status;

  ResponseVerify(
      {required this.ProfileID, required this.PhoneNo, required this.status});

  factory ResponseVerify.fromJson(Map<String, dynamic> jsonData) {
    if (jsonData['status'] == 'false') {
      return ResponseVerify(
          ProfileID: '', PhoneNo: '', status: jsonData['status']);
    } else {
      return ResponseVerify(
          ProfileID: jsonData['ProfileID']!=null?jsonData['ProfileID']:'',
          PhoneNo: jsonData['PhoneNo']!=null ?jsonData['PhoneNo']:'',
          status: jsonData['status']!=null ? jsonData['status']: '');
    }
  }
}
