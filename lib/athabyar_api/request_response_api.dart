import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:AthaPyar/athabyar_api/AthaByarApi.dart';
import 'package:AthaPyar/athabyar_api/download_upload_all.dart';
import 'package:AthaPyar/athabyar_api/request_response_model.dart';
import 'package:AthaPyar/database.dart';
import 'package:AthaPyar/datatbase/model/tbl_account.dart';
import 'package:AthaPyar/datatbase/model/tbl_account_group.dart';
import 'package:AthaPyar/datatbase/model/tbl_account_summary.dart';
import 'package:AthaPyar/datatbase/model/tbl_category.dart';
import 'package:AthaPyar/datatbase/model/tbl_daily.dart';
import 'package:AthaPyar/datatbase/model/tbl_dailyDetail.dart';
import 'package:AthaPyar/datatbase/model/tbl_gold.dart';
import 'package:AthaPyar/datatbase/model/tbl_monthly_summary.dart';
import 'package:AthaPyar/datatbase/model/tbl_profile.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/screen/login_screen/forgot_reset_password.dart';
import 'package:AthaPyar/screen/login_screen/forgot_password_otp_screen.dart';
import 'package:AthaPyar/screen/login_screen/login.dart';
import 'package:AthaPyar/screen/login_screen/signup_password_create.dart';
import 'package:AthaPyar/services/account_service.dart';
import 'package:AthaPyar/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/UserGuide.dart';

class RequestResponseApi {
  static Future<Map?> getExchangeRate(String date,String code) async {
    debugPrint('ExchangeDate code: $code');
    var mUrl=responseExchangeRateApi + date;
    if(code==cambodiaCode){
      mUrl=responseExchangeRateCambodiaApi;
    }
    var client = http.Client();
    var ratesMap = new Map();
    try {
      final response =
          await client.get(Uri.parse(mUrl));
      ratesMap.clear();
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);

        try {
          ratesMap = parsed['rates'];
        } catch (e) {
          print(e);
        }
      }
    } finally {
      client.close();
    }
    if (ratesMap == null) {
      return null;
    } else {
      return ratesMap;
    }
  }
  static Future<AdsData?> getAds50Response()async{
    AdsData? adsData;
    var client = http.Client();
    try{
      final response=await client.get(Uri.parse(requestAds50Api));
      if(response.statusCode==200){
        adsData=await AdsData.fromJson(jsonDecode(response.body));
        debugPrint('RequestResponse adsData50: $adsData');
        return adsData;
      }else{
        return null;
      }

    }finally{
      client.close();
    }
  }
  static Future<AdsData?> getAds250Response()async{
    AdsData? adsData;
    var client = http.Client();
    try{
      final response=await client.get(Uri.parse(requestAds250Api));
      if(response.statusCode==200){
        adsData=await AdsData.fromJson(jsonDecode(response.body));
        return adsData;
      }else{
        return null;
      }

    }finally{
      client.close();
    }
  }
  static Future<AdsData?> getAds480Response() async {
    AdsData? adsData;
    var client = http.Client();
    try {
      final response = await client.get(Uri.parse(requestAds480Api));
      if (response.statusCode == 200) {
        adsData = await AdsData.fromJson(jsonDecode(response.body));
        return adsData;
      } else {
        return null;
      }
    } finally {
      client.close();
    }
  }

  static Future<TBLProfile?> getProfileResponse() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var profileId = await preferences.getString(mProfileId).toString();
    var client = http.Client();
    TBLProfile profile;
    try {
      final response =
          await client.get(Uri.parse(responseProfileApi + profileId));
      if (response.statusCode == 200) {
        try {
          profile = await TBLProfile.fromJson(jsonDecode(response.body));
          if(profile!=null){
                    return profile;
                  }else{
                    return null;
                  }
        } catch (e) {
          return null;
        }
      }else{
        return null;
      }
    } finally {
      client.close();
    }
  }

  static Future<bool> getAccountGroupResponse(String code) async {
    AccountGroupRequest? accountGroupRequest;
    var mUrl=responseAccountGroupApi;
    if(code==cambodiaCode){
      mUrl=responseAccountGroup_cambodia_Api;
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var profileId = await preferences.getString(mProfileId).toString();
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    var client = http.Client();
    try {
      final response =
          await client.get(Uri.parse(mUrl + profileId));
      if (response.statusCode == 200) {
        accountGroupRequest =
            await AccountGroupRequest.fromJson(jsonDecode(response.body));
        if (accountGroupRequest.status == 'true') {
          if (accountGroupRequest.accountData.length > 0) {
            for (var i in accountGroupRequest.accountData) {
                var accountGroup = TBLAccountGroup(i.id, i.name, i.total,i.isUpload,i.isActive,
                    i.createdAt, profileId, i.updatedAt, profileId);
                await database.tblAccountGroupDao.insert(accountGroup);
            }
          }
          return true;
        }else{
          return false;
        }
      } else {
        return false;
      }
    } finally {
      client.close();
    }
  }

  static Future<bool> getAccountResponse(String code) async {
    AccountRequest? accountRequest;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var mUrl=responseAccountApi;
    if(code==cambodiaCode){
      mUrl=responseAccount_cambodia_Api;
    }
    var profileId = await preferences.getString(mProfileId).toString();
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    var client = http.Client();
    try {
      final response =
          await client.get(Uri.parse(mUrl + profileId));
      if (response.statusCode == 200) {
        accountRequest =
            await AccountRequest.fromJson(jsonDecode(response.body));
        if (accountRequest.status == 'true') {
          if (accountRequest.accountData.length > 0) {
           print (
                "AccountResponse list: ${accountRequest.accountData.length}");
            for (var i in accountRequest.accountData) {
              print (
                  "AccountResponse name: ${i.name} :isActive ${i.isActive} :Amount ${i.amount}");
                var account = TBLAccount(
                    i.id,
                    i.name,
                    '0',
                    '0',
                    i.accountGroupId,
                    i.note,
                    'false',
                    i.isActive,
                    i.createdAt,
                    profileId,
                    i.updatedAt,
                    profileId);
                await database.tblAccountDao.insert(account);
            }
            var acc_list=await database.tblAccountDao.selectAll('1',profileId);
            print('acc_list: ${acc_list.length}');
            for(var i in acc_list){
              var expenseAmount = 0;
              var incomeAmount = 0;
              var incomeTransferAmount = 0;
              var income=0;
              var subAmountResult = 0;
              print('acc_list: name ${i.name}');
              print('acc_list: id ${i.id}');
              if(i.isActive=='1'){
                print('AccountName: ${i.name}');

                var dailyDetailList = await database.tblDailyDetailDao
                    .selectByAccountId(i.id,profileId,'1');
                var dailyDetailToAccountList = await database.tblDailyDetailDao.selectByToAccountId(i.id, profileId, '1');
                if (dailyDetailList.length > 0) {
                  for (var dailyDetail in dailyDetailList) {
                    if (dailyDetail.type == ExpenseType || dailyDetail.type == TransferType) {
                      expenseAmount += int.parse(dailyDetail.amount);
                    }
                    if(dailyDetail.type==IncomeType){
                      incomeAmount +=int.parse(dailyDetail.amount);
                    }
                  }
                }
                if (dailyDetailToAccountList.length > 0) {
                  for (var dailyDetailTo in dailyDetailToAccountList) {
                    if(dailyDetailTo.type==TransferType){
                      incomeTransferAmount +=int.parse(dailyDetailTo.amount);
                    }
                  }
                }
                income=incomeAmount+incomeTransferAmount;
                subAmountResult=income-expenseAmount;
                print('Account result: $subAmountResult :AccountName: ${i.name}');
                var tblAccount = TBLAccount(
                    i.id,
                    i.name,
                    subAmountResult.toString(),
                    subAmountResult.toString(),
                    i.accountGroupId,
                    i.note,
                    'false',
                    '1',
                    i.createdAt,
                    profileId,
                    i.updatedAt,
                    profileId);
                await database.tblAccountDao.insert(tblAccount);

              }
            }
          }
          return true;
        }else{
          return false;
        }
      } else {
        return false;
      }
    } finally {
      client.close();
    }
  }

  static Future<List<UserGuide>> getUserGuideResponse()async{
    List<UserGuide> data=[];
    UserGuideRequest? userGuideRequest;
    var client = http.Client();
    try{
      final response=await client.get(Uri.parse(requestUserGuideApi));
      if(response.statusCode == 200){
        userGuideRequest = await UserGuideRequest.fromJson(jsonDecode(response.body));
        if(userGuideRequest.status== 'true'){
          if(userGuideRequest.userGuideList!=null && userGuideRequest.userGuideList.length>0){
            data=userGuideRequest.userGuideList;
            print('UserGuideRequest list: ${data.length}');
           // for(var i in data){
           //   try {
           //     // Saved with this method.
           //     var imageId = await ImageDownloader.downloadImage(i.image);
           //     if (imageId == null) {
           //     }
           //
           //     // Below is a method of obtaining saved image information.
           //     var fileName = await ImageDownloader.findName(imageId!);
           //     var path = await ImageDownloader.findPath(imageId);
           //     print('UserGuideRequest filePath: ${path}');
           //     print('UserGuideRequest fileName: ${fileName}');
           //
           //
           //     var size = await ImageDownloader.findByteSize(imageId);
           //
           //     var mimeType = await ImageDownloader.findMimeType(imageId);
           //   } on PlatformException catch (error) {
           //     print(error);
           //   }
           // }

          }
        }
      }
    }finally{
      client.close();
    }
    return data;
  }
  static Future<bool> getCategoryResponse() async {
    CategoryRequest? categoryRequest;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var profileId = await preferences.getString(mProfileId).toString();
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    var client = http.Client();
    try {
      final response =
          await client.get(Uri.parse(responseCategoryApi + profileId));
      if (response.statusCode == 200) {
        categoryRequest =
            await CategoryRequest.fromJson(jsonDecode(response.body));
        if (categoryRequest.status == 'true') {
          if (categoryRequest.categoryData.length > 0) {
            print(
                "CategoryResponse list: ${categoryRequest.categoryData.length}");
            for (var i in categoryRequest.categoryData) {
              var category = TBLCategory(
                  id: i.id,
                  name: i.name,
                  type: i.type,
                  color: i.color,
                  monthYear: i.monthYear,
                  isUpload: i.isUpload,
                  isActive: i.isActive,
                  createdAt: i.createdAt,
                  updatedAt: i.updatedAt,
                  createdBy: profileId,
                  updatedBy: profileId);
              await database.tblCategoryDao.insert(category);
            }
            var list = await database.tblCategoryDao.selectAll();
            print("Category length: ${list.length}");
          }
          return true;
        }else{
          return false;
        }
      } else {
        print("AccountGroupResponse statusCode: ${response.statusCode}");
        return false;
      }
    } finally {
      client.close();
    }
  }

  static Future<bool> getAccountSummaryResponse() async {
    AccountSummaryRequest? accountSummaryRequest;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var profileId = await preferences.getString(mProfileId).toString();
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    var client = http.Client();
    try {
      final response =
          await client.get(Uri.parse(responseAccountSummaryApi + profileId));
      if (response.statusCode == 200) {
        accountSummaryRequest =
            await AccountSummaryRequest.fromJson(jsonDecode(response.body));
        if (accountSummaryRequest.status == 'true') {
          if (accountSummaryRequest.accountSummaryData.length > 0) {
            (
                "accountSummaryRequest list: ${accountSummaryRequest.accountSummaryData.length}");
            for (var i in accountSummaryRequest.accountSummaryData) {
              var accountSummary = TBLAccountSummary(
                  id: i.id,
                  account: i.account,
                  liabilities: i.liabilities,
                  total: i.total,
                  isActive:i.isActive,
                  createdAt: i.createdAt,
                  createdBy: i.createdBy,
                  updatedAt: i.updatedAt,
                  updatedBy: i.updatedBy);
              await database.tblAccountSummaryDao.insert(accountSummary);
            }

          }
          return true;
        }else{
          return false;
        }

      } else {
        ("AccountGroupResponse statusCode: ${response.statusCode}");
        return false;
      }
    } finally {
      client.close();
    }
  }
  static Future<bool> getTermAndConditionResponse()async{
    var client = http.Client();
    TermAndConditionRequest termAndCondition;
    try{
      final response=await client.get(Uri.parse(responseTermAndConditionApi));
      if(response.statusCode==200){
        termAndCondition=await TermAndConditionRequest.fromJson(jsonDecode(response.body));
        if(termAndCondition!=null){
          SharedPreferences pref=await SharedPreferences.getInstance();
          pref.setString(termsAndCondition_eng, termAndCondition.data[0].terms);
          pref.setString(termsAndCondition_mm, termAndCondition.data[0].terms_mm);
          var term_eng=await pref.getString(termsAndCondition_eng).toString();
          var term_mm=await pref.getString(termsAndCondition_mm).toString();
          print("TermAndCondition eng: $term_eng");
          print("TermAndCondition mm: $term_mm");
          return true;
        }else{
          return false;
        }

      }else{
        return false;
      }
    }finally{
      client.close();

    }
  }

  static Future<void> getAboutUsResponse()async{
    var client = http.Client();
    AboutUsRequest aboutUsRequest;
    try{
      final response=await client.get(Uri.parse(responseAboutUsApi));
      if(response.statusCode==200){
        aboutUsRequest=await AboutUsRequest.fromJson(jsonDecode(response.body));
        SharedPreferences pref=await SharedPreferences.getInstance();
        pref.setString(about_us_eng, aboutUsRequest.about);
       pref.setString(about_us_mm, aboutUsRequest.about_mm);
        var term_eng=await pref.getString(about_us_eng).toString();
        ("AboutUs: $term_eng");

      }
    }finally{

    }
  }
  static Future<void> getdownloadGoldResponse()async{
    var client = http.Client();
    GoldRequest goldRequest;
    try{
      final response=await client.get(Uri.parse(responseGoldApi));
      if(response.statusCode==200){
        goldRequest=await GoldRequest.fromJson(jsonDecode(response.body));
        ("Gold API: ${goldRequest.data.length}");
        final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
        if(goldRequest.data.length>0){
          for(var i in goldRequest.data){
            ("Gold API id: ${i.id}");
            ("Gold API localprice: ${i.local_price}");
            ("Gold API date: ${i.date}");
            TBLGold tblGold= TBLGold(id: i.id, local_price: i.local_price, date:ConstantUtils.dayMonthYearFormat.format(DateTime.parse(i.date)));
             await database.tblGoldDao.insert(tblGold);
          }
          var list=await database.tblGoldDao.selectAll();
          ("Gold API: ${list.length}");
        }
      }
    }finally{
      client.close();

    }
  }
  static Future<bool> getMonthlySummaryResponse() async {
    MonthlySummaryRequest? summaryRequest;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var profileId = await preferences.getString(mProfileId).toString();
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    var client = http.Client();
    try {
      final response =
          await client.get(Uri.parse(responseMonthlySummaryApi + profileId));
      if (response.statusCode == 200) {
        summaryRequest =
            await MonthlySummaryRequest.fromJson(jsonDecode(response.body));
        if (summaryRequest.status == 'true') {
          if (summaryRequest.summaryData.length > 0) {
            (
                "MonthlySummaryRequest list: ${summaryRequest.summaryData.length}");
            for (var i in summaryRequest.summaryData) {
              var monthlySummary = TBLMonthlySummary(
                  id: i.id,
                  monthYear: i.monthYear,
                  year: i.year,
                  incomeAmount: '0',
                  expenseAmount: '0',
                  total: '0',
                  isUpload: 'false',
                  isActive:'1',
                  createdAt: i.createdAt,
                  createdBy: i.createdBy,
                  updatedAt: i.updatedAt,
                  updatedBy: i.updatedBy);
              await database.tblMonthlySummaryDao.insert(monthlySummary);
              print("MonthlySummary download income ${i.incomeAmount}");
              print("MonthlySummary download expense ${i.expenseAmount}");
              print("MonthlySummary download total ${i.total}");
              await TransactionService.selectSummaryByMonth(i.monthYear);

            }


          }
          return true;
        }else{
          return false;
        }
      } else {
        return false;
      }
    } finally {
      client.close();
    }
  }
  static Future<void> uploadAllApi()async{
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var profileId = await preferences.getString(mProfileId).toString();
      var code=myanmarCode;
      if(preferences.getString(selected_country)!=null){
        code=preferences.getString(selected_country)!;
      }
      final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
      var accountGroupList=await database.tblAccountGroupDao.selectNoUpload(profileId);
      if(accountGroupList.length>0){
            //ConstantUtils.showToast("Need to upload for account group: ${accountGroupList.length}");
            await DownloadUploadAll.uploadAccountGroup(accountGroupList,code);
          }else{
           // Utils.showToast("There is no upload for account group");
          }
      var accountList=await database.tblAccountDao.selectNoUpload(profileId, 'false');
      if(accountList.length>0){

            await DownloadUploadAll.uploadAccount(accountList,code);
          //  ConstantUtils.showToast("Need to upload for account: ${accountList.length}");
          }else{
      //  ConstantUtils.showToast("There is no upload for account ");
          }
      var categoryList=await database.tblCategoryDao.selectNoUpload(profileId,'false');
      if(categoryList.length>0){
            await DownloadUploadAll.uploadCategory(categoryList);
           // ConstantUtils.showToast("Need to upload for category: ${categoryList.length}");
          }else{
           // Utils.showToast("There is no upload for category ");
          }
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> getDailyResponse() async {
    DateTime updatedAt=DateTime.now();
    debugPrint('UpdatedAt: ${updatedAt.toString()}');
    DailyRequest dailyRequest;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var profileId = await preferences.getString(mProfileId).toString();
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    var client = http.Client();
    try {
      final response =
          await client.get(Uri.parse(responseDailyApi + profileId));
      print('DailyResponse status: ${response.statusCode}');
      if (response.statusCode == 200) {
        dailyRequest = await DailyRequest.fromJson(jsonDecode(response.body));
        if (dailyRequest.status == 'true') {
          print('DailyResponse length: ${dailyRequest.daily.length}');

          if (dailyRequest.daily.length > 0) {
            for (var i in dailyRequest.daily) {
              var dailyIncomeAmount=0;
              var dailyExpenseAmount=0;
              if (i.daily_detail.isNotEmpty && i.daily_detail.length > 0) {
                for (var j in i.daily_detail) {
                  var tblDailyDetail = TBL_DailyDetail(
                      id: j.id,
                      date: j.date,
                      monthYear: j.monthYear,
                      dailyId: j.dailyId,
                      accountName: j.accountName,
                      toAccountName: j.toAccountName,
                      categoryName: j.categoryName,
                      accountId: j.accountId,
                      categoryId: j.categoryId,
                      toAccountId: j.toAccountId,
                      amount: j.amount,
                      note: j.note,
                      other: j.other,
                      type: j.type,
                      bookmark: j.bookmark,
                      image: j.image,
                       isUpload: 'false',
                      isActive: j.isActive,
                      createdAt: j.createdAt,
                      createdBy: j.createdBy,
                      updatedAt: j.updatedAt,
                      updatedBy: j.updatedBy,);
                  await database.tblDailyDetailDao.insert(tblDailyDetail);
                  if(j.type==IncomeType && j.isActive=='1' && j.categoryId.isNotEmpty){
                    dailyIncomeAmount +=int.parse(j.amount);
                  }
                  if(j.type==ExpenseType && j.isActive=='1' && j.categoryId.isNotEmpty){
                    dailyExpenseAmount +=int.parse(j.amount);
                  }
                }
              }else{
                dailyIncomeAmount=0;
                dailyExpenseAmount=0;
              }
              print('DailyDate: ${i.date}');
              print('DailyIncomeResult: $dailyIncomeAmount');
              print('DailyExpenseResult: $dailyExpenseAmount');

              var tblDaily = TBL_Daily(
                  id: i.id,
                  monthlySummaryID: i.summaryId,
                  date: i.date,
                  monthYear: i.monthYear,
                  incomeAmount: dailyIncomeAmount.toString(),
                  expenseAmount: dailyExpenseAmount.toString(),
                  totalAmount: i.totalAmount,
                  isUpload:'false',
                  isActive:i.isActive,
                  createdAt: i.createdAt,
                  createdBy: i.createdBy,
                  updatedAt: i.updatedAt,
                  updatedBy: i.updatedBy);
              await database.tblDailyDao.insert(tblDaily);
            }
          } else {
            ("DailyResponse data: ${dailyRequest.daily.length}");
          }
        }
      } else {
        return false;
      }
    } finally {
      client.close();
    }
    return true;
  }
  static Future<bool> requestDaily(List<Daily> daily) async {
    var dailyRequest = DailyRequest(daily: daily, status: '');
    var jsonEncodedData = jsonEncode(dailyRequest.toJson());
    ('DailyUpload ResponseOBJ: ${jsonEncodedData}');

    var client = http.Client();
    try {
      var response = await http.post(Uri.parse(requestDailyApi),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(dailyRequest.toJson()));
      if (response.statusCode == 200) {
        ('Response Success: ${response.statusCode}');
        try {
          var responseStatus =
              ResponseStatus.fromJson(jsonDecode(response.body));
          if (responseStatus != null) {
            if (responseStatus.status == 'true') {
              ('Response status: ${responseStatus.status}');
              return true;
            } else {
              return false;
            }
          } else {
            return false;
          }
        } catch (e) {
          return false;
        }
      } else {
        ('Response Fail: ${response.statusCode}');
      }
    } finally {
      client.close();
    }
    return true;
  }

  static Future<bool> requestAccountGroup(List<TBLAccountGroup> list,String code) async {
    var mUrl=requestAccountGroupApi;
    if(code==cambodiaCode){
      mUrl=requestAccountGroup_cambodia_Api;
    }
    var client = http.Client();
    try {
      AccountGroupRequest? accountGroupRequest =
          AccountGroupRequest(accountData: list, status: '');
      debugPrint(
          'RequestAccountGroup json: ${jsonEncode(accountGroupRequest.toJson())}');

      var response = await http.post(Uri.parse(mUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(accountGroupRequest.toJson()));
      if (response.statusCode == 200) {
        ('Response Success: ${response.statusCode}');
        try {
          var responseStatus =
              ResponseStatus.fromJson(jsonDecode(response.body));
          if (responseStatus != null) {
            if (responseStatus.status == 'true') {
              (
                  'ResponseAccountGroup Status: ${responseStatus.status}');
              return true;
            } else {
              return false;
            }
          } else {
            return false;
          }
        } catch (e) {
          return false;
        }
      } else {
        ('Response Fail: ${response.statusCode}');
      }
    } finally {
      client.close();
    }
    return true;
  }

  static Future<bool> requestAccount(List<TBLAccount> list,String code) async {
    var mUrl=requestAccountApi;
    if(code==cambodiaCode){
      mUrl=requestAccount_cambodia_Api;
    }
    var client = http.Client();
    try {
      AccountRequest? accountGroupRequest =
          AccountRequest(accountData: list, status: '');
      print(
          'RequestAccount json: ${jsonEncode(accountGroupRequest.toJson())}');

      var response = await http.post(Uri.parse(mUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(accountGroupRequest.toJson()));
      if (response.statusCode == 200) {
        ('ResponseAccount Success: ${response.statusCode}');
        try {
          var responseStatus =
              ResponseStatus.fromJson(jsonDecode(response.body));
          if (responseStatus != null) {
            if (responseStatus.status == 'true') {
              ('ResponseAccount Status: ${responseStatus.status}');
              return true;
            } else {
              return false;
            }
          } else {
            return false;
          }
        } catch (e) {
          return false;
        }
      } else {
        ('Response Fail: ${response.statusCode}');
      }
    } finally {
      client.close();
    }
    return true;
  }

  static Future<bool> requestCategory(List<TBLCategory> list) async {
    var client = http.Client();
    try {
      CategoryRequest? categoryRequest =
          CategoryRequest(categoryData: list, status: '');
      (
          'ResponseCategory json: ${jsonEncode(categoryRequest.toJson())}');

      var response = await http.post(Uri.parse((requestCategoryApi)),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(categoryRequest.toJson()));
      if (response.statusCode == 200) {
        ('ResponseCategory Success: ${response.statusCode}');
        try {
          var responseStatus =
              ResponseStatus.fromJson(jsonDecode(response.body));
          if (responseStatus != null) {
            if (responseStatus.status == 'true') {
              ('ResponseCategory Status: ${responseStatus.status}');
              return true;
            } else {
              return false;
            }
          } else {
            return false;
          }
        } catch (e) {
          return false;
        }
      } else {
        ('Response Fail: ${response.statusCode}');
        return false;
      }
    } finally {
      client.close();
    }
    return true;
  }

  static Future<bool> requestAccountSummary(
      List<TBLAccountSummary> list) async {
    var client = http.Client();
    try {
      AccountSummaryRequest? accountSummaryRequest =
          AccountSummaryRequest(accountSummaryData: list, status: '');
      (
          'AccountSummary json: ${jsonEncode(accountSummaryRequest.toJson())}');

      var response = await http.post(Uri.parse((requestAccountSummaryApi)),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(accountSummaryRequest.toJson()));
      if (response.statusCode == 200) {
        ('accountSummaryRequest Success: ${response.statusCode}');
        try {
          var responseStatus =
              ResponseStatus.fromJson(jsonDecode(response.body));
          if (responseStatus != null) {
            if (responseStatus.status == 'true') {
              (
                  'accountSummaryRequest Status: ${responseStatus.status}');
              return true;
            } else {
              return false;
            }
          } else {
            return false;
          }
        } catch (e) {
          return false;
        }
      } else {
        ('Response Fail: ${response.statusCode}');
        return false;
      }
    } finally {
      client.close();
    }
    return true;
  }

  static Future<bool> requestMonthlySummary(
      List<TBLMonthlySummary> list) async {
    var client = http.Client();
    try {
      MonthlySummaryRequest? monthlySummaryRequest =
          MonthlySummaryRequest(summaryData: list, status: '');
      var response = await http.post(Uri.parse((requestMonthlySummaryApi)),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(monthlySummaryRequest.toJson()));
      if (response.statusCode == 200) {
        try {
          var responseStatus =
              ResponseStatus.fromJson(jsonDecode(response.body));
          if (responseStatus != null) {
            if (responseStatus.status == 'true') {
              return true;
            } else {
              return false;
            }
          } else {
            return false;
          }
        } catch (e) {
          return false;
        }
      } else {
        return false;
      }
    } finally {
      client.close();
    }
  }

  static Future<bool> requestLogin(String phoneNo, String password,BuildContext context,String deviceId,String code) async {
    bool isLogin=false;
    var mUrl = requestLoginApi;
    if(code==cambodiaCode){
      mUrl=requestLogin_Cambodia_Api;
    }
    print('Login response countrycode: ${mUrl}');

    var client = http.Client();
    ResponseData? responseData;
    RequestLoginByDeviceId requestLogin =
    RequestLoginByDeviceId(phone: code+phoneNo, password: password,deviceId: deviceId);
    // var response=http.post(Uri.parse(mUrl),
    //     headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //     },
    //     body: jsonEncode(requestLogin.toJson()));
    try {

               await http.post(Uri.parse(mUrl),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: jsonEncode(requestLogin.toJson())).timeout(Duration(seconds: 30),onTimeout: (){
                          return http.Response('Server Response Time out error',408);//Request Timeout response status code

               }).then((onResponse)async{
                SharedPreferences preferences = await SharedPreferences.getInstance();
                print('Login phoneNo: ${code+phoneNo}');
                print('Login response: ${onResponse.statusCode}');

                if (onResponse.statusCode == 200) {
                  try {
                    responseData =
                        await ResponseData.fromJson(jsonDecode(onResponse.body));
                    if (responseData != null) {
                      print('Login response profileID: ${responseData!.profileId}');
                      print('Login response status: ${responseData!.status}');
                      print('Login response register: ${responseData!.isRegister}');


                      if (responseData!.status == 'false' && responseData!.isRegister=='false') {
                        ConstantUtils.showAlertDialog(context, notRegisterMessage);
                        return isLogin;
                      } else  if (responseData!.profileId.isNotEmpty && responseData!.status == 'false' && responseData!.isRegister=='true') {
                        ConstantUtils.showAlertDialog(context, loginResponseMessage);
                        return isLogin;
                      } else if(responseData!.profileId.isNotEmpty && responseData!.status=='true' && responseData!.isRegister=='true'){
                        preferences.setString(mProfileId, responseData!.profileId);
                        preferences.setBool(LoginSuccess, true);
                        preferences.setString(mPhoneNumber, '${code+phoneNo}');
                        preferences.setString(mDeviceId, deviceId);
                        preferences.setString(selected_country, code);
                        isLogin=true;
                        print('Login response deviceID: ${preferences.getString(mDeviceId)}');

                        return isLogin;
                      }
                    }else{
                      return isLogin;
                    }

                  } catch (e) {
                    return isLogin;
                  }
                } else {
                  return isLogin;
                }
              }).catchError((onError)async{
                isLogin=false;
                return isLogin;
          });

    } catch (e) {
      ('LoginResponse catch: ${isLogin}');

      return isLogin;
    }finally{
      client.close();
    }
    print('LoginResponse finally: ${isLogin}');

    return isLogin;
  }

  static Future<void> forgetResetPassword(String phoneNo, String password,BuildContext context,String code) async {
    var mUrl = requestForgetPasswordResetApi;
    if(code==cambodiaCode){
      mUrl=requestForgetPasswordReset_Cambodia_Api;
    }
    var client = http.Client();
    ResponseData? responseData;
    try {
      RequestLogin requestLogin =
      RequestLogin(phone: phoneNo, password: password);
      var response = await http.post(Uri.parse(mUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(requestLogin.toJson()));

      if (response.statusCode == 200) {
        try {
          responseData =
          await ResponseData.fromJson(jsonDecode(response.body));
          if (responseData != null) {
            if (responseData.status == 'false' && responseData.isRegister=='false') {
              ConstantUtils.showAlertDialog(context, notRegisterMessage);

            } else  if (responseData.status == 'false' && responseData.isRegister=='true') {
              ConstantUtils.showAlertDialog(context, loginResponseMessage);

            }
            else if(responseData.status=='true' && responseData.isRegister=='true' && responseData.profileId !=null && responseData.profileId.isNotEmpty){
              ConstantUtils.showAlertDialog(context, successResetPassword);
              Get.off(()=> LoginScreen());

            }else{
              ConstantUtils.showAlertDialog(context, 'Fail Request');

            }
          }else{
            ConstantUtils.showAlertDialog(context, 'Fail Request');

          }

        } catch (e) {
        }
      } else {
        ConstantUtils.showAlertDialog(context, 'Fail Request');

      }
    } finally {
      client.close();
    }

  }

  static Future<void> signupResetPassword(String phoneNo, String password,BuildContext context,String code) async {
    var mUrl = requestSignupResetPassword;
    if(code==cambodiaCode){
      mUrl=requestSignupResetPassword_Cambodia;
    }
    var client = http.Client();
    ResponseData? responseData;
    try {
      RequestLogin requestLogin =
      RequestLogin(phone: phoneNo, password: password);
      var response = await http.post(Uri.parse(mUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(requestLogin.toJson()));

      if (response.statusCode == 200) {
        try {
          responseData =
          await ResponseData.fromJson(jsonDecode(response.body));
          if (responseData != null) {
            if (responseData.status == 'false' && responseData.isRegister=='false') {
              ConstantUtils.showAlertDialog(context, notRegisterMessage);

            } else  if (responseData.status == 'false' && responseData.isRegister=='true') {
              ConstantUtils.showAlertDialog(context, loginResponseMessage);

            }
            else if(responseData.status=='true' && responseData.isRegister=='true' && responseData.profileId !=null && responseData.profileId.isNotEmpty){
              SharedPreferences preferences = await SharedPreferences.getInstance();
              preferences.setString(mProfileId, responseData.profileId);
              preferences.setBool(LoginSuccess, true);
              Get.off(()=> LoginScreen());

            }else{
              ConstantUtils.showAlertDialog(context, 'Fail Request');

            }
          }else{
            ConstantUtils.showAlertDialog(context, 'Fail Request');

          }

        } catch (e) {
        }
      } else {
        ConstantUtils.showAlertDialog(context, 'Fail Request');

      }
    } finally {
      client.close();
    }

  }

  static Future<void> requestForgetPasswordSMS(String phoneNo,BuildContext context,String code) async {
    var client = http.Client();
    ResponseStatus? responseStatus;
    var mUrl=requestForgetPasswordSMSApi;
    if(code==cambodiaCode){
      mUrl=requestForgetPasswordSMS_Cambodia_Api;
    }
    try {
      RequestForgetPasswordSmsOTP request =
          RequestForgetPasswordSmsOTP(phone: code+phoneNo, forget_password: 'true');
      var response = await http.post(Uri.parse(mUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(request.toJson()));
      print('Forget code: ${code+phoneNo}');
      if (response.statusCode == 200) {
        try {
          responseStatus =
              await ResponseStatus.fromJson(jsonDecode(response.body));
          if (responseStatus != null) {
            if (responseStatus.status == 'true') {
              Get.off(()=> ForgotOTPScreen(phoneNo:code+phoneNo,code:code));
            } else {
              ConstantUtils.showAlertDialog(context,forgetPasswordMessage );

            }
          } else {
            ConstantUtils.showAlertDialog(context,'Fail Request' );
          }
        } catch (e) {


        }
      } else {
        ConstantUtils.showAlertDialog(context,'Fail Request' );
      }
    } finally {
      client.close();
    }
  }

  static Future<void> requestVerifyOTP(String otp,BuildContext context,String code) async {
    var client = http.Client();
    ResponseVerify? responseVerify;
    var mUrl = requestVerifyOtpApi;
    if(code==cambodiaCode){
      mUrl=requestVerifyOtp_Cambodia_Api;
    }

    try {
      RequestVerifyOtp request = RequestVerifyOtp(otp: otp);
      var response = await http.post(Uri.parse(mUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(request.toJson()));
      if (response.statusCode == 200) {
        responseVerify =
            await ResponseVerify.fromJson(jsonDecode(response.body));
        if (responseVerify != null) {
          if (responseVerify.status == 'false') {
            ConstantUtils.showAlertDialog(context, wrongOTP);

          } else  if (responseVerify.status == 'true' && responseVerify.ProfileID !=null && responseVerify.ProfileID.isNotEmpty && responseVerify.PhoneNo!=null && responseVerify.PhoneNo.isNotEmpty) {

            Get.off(()=> SignUpPasswordCreate(phoneNo: responseVerify!.PhoneNo,code:code));
            try {
              var isProfile= await DownloadUploadAll.downloadProfile();
            } catch (e) {
              print(e);
            }
            try {
              var isDaily=await DownloadUploadAll.downloadDaily();
            } catch (e) {
              print(e);
            }
            try {
              var isAccountGroup=await DownloadUploadAll.downloadAccountGroup(code);
            } catch (e) {
              print(e);
            }
            try {
              var isAccount=await DownloadUploadAll.downloadAccount(code);
            } catch (e) {
              print(e);
            }
            try {
              var isCategory=await DownloadUploadAll.downloadCategory();
            } catch (e) {
              print(e);
            }
            // try {
            //   var isAccountSummary=await DownloadUploadAll.downloadAccountSummary();
            //
            // } catch (e) {
            //   print(e);
            // }
            // try {
            //   var isMonthlySummary=await DownloadUploadAll.downloadMonthlySummary();
            // } catch (e) {
            //   print(e);
            // }
          }
          else {
            ConstantUtils.showAlertDialog(context, wrongOTP);
          }
        }else{
          ConstantUtils.showAlertDialog(context, wrongOTP);
        }
      } else {
        ConstantUtils.showAlertDialog(context, wrongOTP);
      }
    } finally {
      client.close();
    }
  }

  static Future<void> requestForgetPasswordVerifyOTP(String otp,String phoneNo,BuildContext context,String code) async {
    var client = http.Client();
    ResponseVerify? responseVerify;
    var mUrl = requestForgetPasswordVerifyOtpApi;
    if(code==cambodiaCode){
      mUrl=requestForgetPasswordVerifyOtp_Cambodia_Api;
    }

    try {
      RequestVerifyOtp request = RequestVerifyOtp(otp: otp);
      var response = await http.post(Uri.parse(mUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(request.toJson()));
      if (response.statusCode == 200) {
        try {
          responseVerify =
              await ResponseVerify.fromJson(jsonDecode(response.body));
          if (responseVerify.status == 'false') {
            ConstantUtils.showAlertDialog(context, wrongOTP);
          } else  if (responseVerify.status == 'true' && responseVerify.ProfileID!=null && responseVerify.ProfileID.isNotEmpty) {
            SharedPreferences preferences=await SharedPreferences.getInstance();
            preferences.setString(mProfileId, responseVerify.ProfileID);
            preferences.setBool(LoginSuccess, true);
            Get.off(()=> ForgotPasswordReset(phoneNo:phoneNo,code:code));

          }
          else {
            ConstantUtils.showAlertDialog(context, 'Response Fail');
          }
        } catch (e) {


        }
      } else {
        ConstantUtils.showAlertDialog(context, 'Response Fail');
      }
    } finally {
      client.close();
    }

  }
}
