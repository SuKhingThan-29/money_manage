import 'package:AthaPyar/datatbase/model/tbl_account.dart';
import 'package:AthaPyar/datatbase/model/tbl_account_group.dart';
import 'package:AthaPyar/screen/account_screen/account.dart';
import 'package:AthaPyar/screen/account_screen/account_group.dart';
import 'package:AthaPyar/screen/home_screen/home.dart';
import 'package:AthaPyar/screen/transaction_screen/transaction.dart';
import 'package:AthaPyar/services/account_group_service.dart';
import 'package:AthaPyar/services/account_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../helper/utils.dart';


class AccountController extends GetxController{
  TextEditingController groupController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController amountController = TextEditingController();

  TextEditingController noteController = TextEditingController();

  TextEditingController accountController = TextEditingController();

  TextEditingController categoryController = TextEditingController();


  TextEditingController toController = TextEditingController();

  bool validateName=true;
  late String accountName;
  late String categoryName;
   late String accountId='';
   late String toAccountId='';
   late String categoryId='';
   late String accountGroupId='';
   var numberFormat;
  bool isInternet=false;
  var adsLoading = true.obs;
  List<TBLAccountGroup> mAccountGroupList=[];

  List<TBLAccount> accountList=[];
  int mCount250=0;

  @override
  void onInit(){
    numberFormat = new NumberFormat("#,##0.00", "en_US");
    super.onInit();
    init();
  }

  void onBackData(BuildContext context,String transaction){
    if(transaction=='transaction'){
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return TransactionScreen( dailyId: '', transactionId: '',);
        },
      ));
    }else{
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return  HomeScreen(selectedMenu: 'accounts', showInterstitial: false,);
        },
      ));
    }
  }
  void goToAccountGroup(String accountScreen){
    Get.off(()=>AccountGroup(accountGroupList: [], accountGroupDetailRoute: '',accountScreen:accountScreen));
  }
  void setAccountGroupId(String accountGroupId){
    this.accountGroupId=accountGroupId;
    ('AccountGroup id ${this.accountGroupId}');
    //update();
  }
  void setAccountId(String accountId){
    this.accountId=accountId;
    ('AccountListReturn accountId ${accountId}');
    update();
  }
  void setToAccountId(String accountId){
    this.toAccountId=accountId;
    ('AccountListReturn ToAccountId ${toAccountId}');
    update();
  }
  void setCategoryId(String categoryId){
    this.categoryId=categoryId;
    ('AccountListReturn categoryId ${categoryId}');
    update();
  }
  void init()async{
    accountList.clear();
    mAccountGroupList.clear();
    mAccountGroupList=await AccountGroupService.selectAccountGroupList();

    accountList =await AccountService.getAllAccount(mAccountGroupList);
    print('AccountList length ${accountList.length}');
    update();

  }
  @override
  void onClose(){
    super.onClose();

  }
  void saveAccount(String accountId)async{
   AccountService.saveAccount(accountId,accountGroupId,nameController.text, amountController.text, noteController.text);
   init();
  }

  void updateAccountById(String id)async{
    print('Update accountId: ${id}');
    var list=await AccountService.selectAccountById(id);
    print('Update accountLists: ${accountList.length}');
    if(list.length>0){
      print('AccountEdit amount: ${list[0].amount}');
      int subAmount=int.parse(list[0].subAmount);
      if(subAmount==0){
        Get.off(()=>AccountScreen(accountList:list,transaction: '',));
      }else{
        ConstantUtils.showToast('Cannot update account');
      }
    }
    update();
  }
  void deleteAccountById(String id)async{
    print('Deleted accountId: ${id}');
    print('Update accountId: ${id}');
    var list=await AccountService.selectAccountById(id);
    print('Update accountLists: ${accountList.length}');
    if(list.length>0){
      print('AccountEdit amount: ${list[0].subAmount}');
      int subAmount=int.parse(list[0].subAmount);
      if(subAmount==0){
        await AccountService.deleteAccountById(id);
      }else{
        ConstantUtils.showToast('Cannot delete account');
      }
    }
    init();
  }
}