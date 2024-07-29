import 'package:AthaPyar/athabyar_api/AthaByarApi.dart';
import 'package:AthaPyar/athabyar_api/request_response_api.dart';
import 'package:AthaPyar/athabyar_api/request_response_model.dart';
import 'package:AthaPyar/datatbase/model/tbl_account.dart';
import 'package:AthaPyar/datatbase/model/tbl_account_group.dart';
import 'package:AthaPyar/datatbase/model/tbl_account_summary.dart';
import 'package:AthaPyar/datatbase/model/tbl_category.dart';
import 'package:AthaPyar/datatbase/model/tbl_monthly_summary.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/services/account_service.dart';
import 'package:AthaPyar/services/category_service.dart';
import 'package:AthaPyar/services/setting_service.dart';
import 'package:flutter/material.dart';

class DownloadUploadAll{
  static var isLoading=false;

  static Future<void> uploadAll()async{
    await RequestResponseApi.uploadAllApi();

  }

  static Future<bool> downloadProfile()async{
    var profile=await RequestResponseApi.getProfileResponse();

    if(profile!=null){
      await SettingService.saveProfile(profile);
      return true;
    }else {
      return false;
    }
  }
  static Future<bool> downloadDaily()async{
  var isDaily= await RequestResponseApi.getDailyResponse();
  return isDaily;
  }
  static Future<bool> downloadAccountGroup(String code)async{
    var isAccountGroup=await RequestResponseApi.getAccountGroupResponse(code);
    return isAccountGroup;

  }
  static Future<bool> downloadAccount(String code)async{
   var isAccount= await RequestResponseApi.getAccountResponse(code);
   return isAccount;
  }
  static Future<bool> downloadCategory()async{
   var isCategory= await RequestResponseApi.getCategoryResponse();
   return isCategory;
  }



  static Future<bool> downloadMonthlySummary()async{
   var isMonthlySummary= await RequestResponseApi.getMonthlySummaryResponse();
   return isMonthlySummary;
  }
 static Future<bool> downloadTermAndCondition()async{
  var isTerm= await RequestResponseApi.getTermAndConditionResponse();
  return isTerm;

 }
 static Future<void> downloadAboutUs()async{
    await RequestResponseApi.getAboutUsResponse();
 }

 static Future<void> downloadGold()async{
    await RequestResponseApi.getdownloadGoldResponse();
 }
 static Future<void> downloadZip()async{

 }

  static Future<void> uploadDaily(List<Daily> dailyModelList)async{
    var isUpload=false;
    isUpload=await RequestResponseApi.requestDaily(dailyModelList);
    ('Daily Upload: $isUpload');
    if(isUpload){
      //  Utils.showToast('Daily Upload is Fail!');

    }else{
    //  Utils.showToast('Daily Upload is Fail!');
    }
  }
  static Future<void> uploadAccountGroup(List<TBLAccountGroup> accountGroupList,String code)async{
    var isUpload=false;
    isUpload=await RequestResponseApi.requestAccountGroup(accountGroupList,code);
    if(isUpload){
      //ConstantUtils.showToast('Account Group Upload is Success');
    }else{
     // ConstantUtils.showToast('Account Group Upload is fail');
    }
  }
  static Future<void> uploadAccount(List<TBLAccount> accountList,code)async{
    var isUpload=false;
    isUpload=await RequestResponseApi.requestAccount(accountList,code);
    if(isUpload){
      AccountService.updateUploadAccount(accountList);
     // ConstantUtils.showToast('Account  Upload is Success');
    }else{
      //ConstantUtils.showToast('Account  Upload is fail');
    }
  }
  static Future<void> uploadCategory(List<TBLCategory> categoryList)async{
    var isUpload=false;
    isUpload=await RequestResponseApi.requestCategory(categoryList);
    if(isUpload){
      CategoryService.updateUploadCategory(categoryList);
     // ConstantUtils.showToast('Category  Upload is Success');
    }else{
      //ConstantUtils.showToast('Category  Upload is fail');
    }
  }

  static Future<void> uploadAccountSummary(List<TBLAccountSummary> accountSummaryList)async{
    var isUpload=false;
    isUpload=await RequestResponseApi.requestAccountSummary(accountSummaryList);
    if(isUpload){
   //   Utils.showToast('AccountSummary  Upload is Success');
    }else{
    //  Utils.showToast('AccountSummary  Upload is fail');
    }
  }

  static Future<void> uploadMonthlySummary(List<TBLMonthlySummary> monthlySummaryList)async{
    var isUpload=false;
    isUpload=await RequestResponseApi.requestMonthlySummary(monthlySummaryList);
    if(isUpload){
    //  Utils.showToast('MonthlySummary  Upload is Success');
    }else{
   //   Utils.showToast('MonthlySummary  Upload is fail');
    }
  }
}