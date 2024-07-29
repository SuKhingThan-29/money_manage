import 'package:AthaPyar/athabyar_api/download_upload_all.dart';
import 'package:AthaPyar/athabyar_api/request_response_model.dart';
import 'package:AthaPyar/database.dart';
import 'package:AthaPyar/datatbase/model/tbl_account.dart';
import 'package:AthaPyar/datatbase/model/tbl_account_group.dart';
import 'package:AthaPyar/datatbase/model/tbl_account_summary.dart';
import 'package:AthaPyar/datatbase/model/tbl_dailyDetail.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/models/Accounts.dart';
import 'package:AthaPyar/screen/account_screen/account.dart';
import 'package:AthaPyar/screen/account_screen/account_group.dart';
import 'package:AthaPyar/screen/account_screen/account_group_detail.dart';
import 'package:AthaPyar/services/account_group_service.dart';
import 'package:AthaPyar/services/account_service.dart';
import 'package:AthaPyar/services/transaction_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../athabyar_api/request_response_api.dart';

class AccountGroupController extends GetxController {
  TextEditingController accountTypeController = TextEditingController();
  List<Accounts> accountModelList = [];
  List<TBLAccountSummary> accountSummaryList=[];
  List<TBLAccountGroup> accountGroupList=[];
  var adsLoading = true.obs;
  List<AdsData> allTodos = [];
  var numberFormat;
  late String name;
  late String groupId;
  bool isInternet=false;
  int mCount50=0;

  @override
  void onInit() {
    super.onInit();
    numberFormat = new NumberFormat("#,##0", "en_US");
    init();

  }
  void init()async{
    selectAccountGroupList();
    update();
  }


  @override
  void onClose() {
    super.onClose();
  }



  /**
   * All Account total in Account Group
   */
  void selectAccountGroupList() async {
    ConstantUtils util=ConstantUtils();
    bool isInternet=await util.isInternet();
    SharedPreferences pref=await SharedPreferences.getInstance();
    String code=myanmarCode;
    if(pref.getString(selected_country)!=null){
      code=(await pref.getString(selected_country))!;
    }
    if(isInternet){
      await RequestResponseApi.getAccountResponse(code);
     // await DownloadUploadAll.downloadAccount(code);
    }else{
      await TransactionService.selectAccountCalculation();

    }
    accountGroupList.clear();
    accountGroupList = await AccountGroupService.selectAccountGroupList();

    if (accountGroupList.length > 0) {
      for (var i in accountGroupList) {
        var total = 0;
        var accountList = await AccountService.getAllAccountByGroupId(i.id);
        if (accountList.length > 0) {
          for (var j in accountList) {
            total += int.parse(j.subAmount);
          }
        } else {
          total = 0;
          accountList.clear();
        }
        var tblAccountGroup = TBLAccountGroup(i.id, i.name, total.toString(),i.isUpload,i.isActive,
            i.createdAt, i.createdBy, i.updatedAt, i.updatedBy);
        await AccountGroupService.updateAccountGroup(tblAccountGroup);
      }
    }else {
      accountGroupList.clear();
    }
    /**
     * All AccountGroup total in AccountSummary
     */
    await updatedAccounts();
    update();
  }

  /**
   * All AccountGroup total in AccountSummary
   */
  Future<void> updatedAccounts()async{
    List<Accounts> _accountModelList=[];
    var updateAccountGroupList=await AccountGroupService.selectAccountGroupList();

    if(updateAccountGroupList.length>0){
      _accountModelList.clear();
      for(var k in updateAccountGroupList){
        var accountListUpdated = await AccountService.getAllAccountByGroupId(k.id);
        if (accountListUpdated.length > 0) {
        } else {
          accountListUpdated.clear();
        }
        var group = Accounts(k.id, k.name, k.total, k.createdAt, k.createdBy,
            k.updatedAt, k.updatedBy, accountListUpdated);
        _accountModelList.add(group);
      }
      accountSummaryList.clear();
      accountSummaryList=await AccountService.saveAccountSummary();
    }else {
      accountModelList.clear();
    }
    if (_accountModelList.length > 0) {
      accountModelList.clear();
      accountModelList = _accountModelList;

    }else{
      accountModelList.clear();
    }
    update();
  }

  void saveAccountGroup(String id,String text,String accountScreen) async {
    await AccountGroupService.insertAccountGroup(id,text);
    if(accountScreen==accountScreenRoute){
      Get.off(() => AccountScreen(accountList: [], transaction: '',));
    }else{
      Get.off(() => AccountGroupDetail(accountScreen: '',));

    }
    update();
  }

  Future<List<TBLAccountGroup>> selectAccountGroupId(String id,String createdBy)async{
   var list= await AccountGroupService.selectAccountGroupListByName(id,createdBy);
   update();
   return list;
  }
  void deleteAccountGroupId(String id,String createdBy)async{
    await AccountGroupService.deleteAccountGroupId(id,createdBy);
    await TransactionService.deleteTransaction(id);
     await updatedAccounts();
    update();
  }
  Future<void> updateAccountGroup(String id,String createdBy,String accountGroupDetailRoute)async{
    var list= await AccountGroupService.selectAccountGroupListByName(id,createdBy);

      Get.off(()=> AccountGroup(accountGroupList:list,accountGroupDetailRoute:accountGroupDetailRoute, accountScreen: '',));


    update();
  }
}
