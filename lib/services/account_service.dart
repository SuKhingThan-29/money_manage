
import 'package:AthaPyar/athabyar_api/download_upload_all.dart';
import 'package:AthaPyar/database.dart';
import 'package:AthaPyar/datatbase/model/tbl_dailyDetail.dart';
import 'package:AthaPyar/datatbase/model/tbl_account.dart';
import 'package:AthaPyar/datatbase/model/tbl_account_group.dart';
import 'package:AthaPyar/datatbase/model/tbl_account_summary.dart';
import 'package:AthaPyar/datatbase/model/tbl_category.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/services/account_group_service.dart';
import 'package:AthaPyar/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AccountService{
  static var uuid = Uuid();
  static Future<void> updateUploadAccount(List<TBLAccount> accountListUploaded)async{
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    if(accountListUploaded.length>0){
      for(var i in accountListUploaded){
        await database.tblAccountDao.updateAccount(i.id, 'true');
       var list= await database.tblAccountDao.selectAccountById(i.id,'1');


      }
    }

  }

  static Future<List<TBLAccount>> selectAccountById(String id)async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    var createdBy=pref.getString(mProfileId);
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    var mList = await database.tblAccountDao.selectAccountById(id,'1');
    return mList;
  }
  static Future<List<TBLAccount>> selectAll()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    var createdBy=pref.getString(mProfileId);
    final database=await $FloorAppDatabase.databaseBuilder(dbName).build();
    var accountList=await database.tblAccountDao.selectAccountByName(createdBy.toString(),'1');
    return accountList;
  }
  static Future<List<TBLAccountSummary>> saveAccountSummary()async{

    SharedPreferences preferences=await SharedPreferences.getInstance();
    var createdBy=await preferences.getString(mProfileId).toString();
    var createdAt=DateTime.now();
    final database=await $FloorAppDatabase.databaseBuilder(dbName).build();
    var id='123456'+createdBy;
    var _liabilitiesAmount=0;
    var accountRemain=0;
    var accountTotal=0;
    var accountList=await database.tblAccountDao.selectAccountByName(createdBy,'1');
    if(accountList.length>0){
      for(var m in accountList){
        if(m.subAmount.contains('-')){
          _liabilitiesAmount+=int.parse(m.subAmount);
        }else{
            accountRemain +=int.parse(m.subAmount);
        }

        accountTotal=accountRemain + _liabilitiesAmount;
      }

    }

    var data=TBLAccountSummary(id: id, account: accountRemain.toString(), liabilities: _liabilitiesAmount.toString(), total: accountTotal.toString(),isActive: '1', createdAt: createdAt.toString(), createdBy: createdBy, updatedAt: createdAt.toString(), updatedBy: createdBy.toString());
    await database.tblAccountSummaryDao.insert(data);

    var list=await database.tblAccountSummaryDao.selectAll(createdBy,'1');
    return list;
  }

  static Future<List<TBLAccount>> saveAccount(String account_Id,String accountGroupId,String name,String amount,String note)async{
    String date = (DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day)).toString();
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var createdBy=await preferences.getString(mProfileId).toString();
    var createdAt=DateTime.now();
    var code=myanmarCode;
    if(preferences.getString(selected_country)!=null){
      code=preferences.getString(selected_country)!;
    }

    var monthYear = ConstantUtils.monthFormatter
        .format(DateTime.parse(date.split(' ')[0]));
    var accountId=account_Id;
    var dailyId;
    var categoryId='Uuid001'+createdBy;
    String _amount='';
    final database =
    await $FloorAppDatabase.databaseBuilder(dbName).build();
    if (amount.contains(',')) {
      _amount = amount.replaceAll(',', '');
    }else{
      _amount=amount;
    }
    var expenseAmount=0;
    var incomeAmount=0;
    var transactionAccount=await database.tblDailyDetailDao.selectByAccountId(accountId,createdBy,'1');
    if(transactionAccount.length>0){
     for(var t in transactionAccount){
       if(t.type==ExpenseType){
         expenseAmount+=int.parse(t.amount);
       }
       if(t.type==TransferType){
         expenseAmount+=int.parse(t.amount);
       }
       if(t.type==IncomeType){
         incomeAmount+=int.parse(t.amount);

       }
     }
    }
    var subAmount=0;
    subAmount = int.parse(_amount)-expenseAmount;
    print('AccountNameUpdate: $name');
    var account=TBLAccount(accountId, name, subAmount.toString(),subAmount.toString(),accountGroupId, note,'false','1', createdAt.toString(), createdBy, createdAt.toString(), createdBy);
    await database.tblAccountDao.insert(account);
    ConstantUtils utils=ConstantUtils();
    var isInternet=await utils.isInternet();
    if(isInternet){
      List<TBLAccount> accountListUpload=[];
      accountListUpload.add(account);
      DownloadUploadAll.uploadAccount(accountListUpload,code);
    }else{
      ConstantUtils.showToast('You are offline to upload account');
    }
    var dailyList=await database.tblDailyDao.selectDailyByDate(date,createdBy,'1');
    if(dailyList.length>0){
      dailyId=dailyList[0].id;
    }else{
      dailyId=Uuid().v1();
    }
    //var mColor=themeLightColor.value.toString();
    var mColor='285738238227';
    debugPrint('Category Color: $mColor');
    var category=TBLCategory(id: categoryId, name: 'Other',type: IncomeType,color:mColor,monthYear: monthYear,isUpload: 'false',isActive: '1', createdAt: date, updatedAt: date, createdBy: createdBy, updatedBy:createdBy);
    await database.tblCategoryDao.insert(category);

    if(isInternet){
      List<TBLCategory> categoryListUpload=[];
      categoryListUpload.add(category);
      DownloadUploadAll.uploadCategory(categoryListUpload);
    }else{
      ConstantUtils.showToast(internetConnectionStatus);
    }
    var transaction=TBL_DailyDetail(id: accountId, date: date, monthYear: monthYear, dailyId: dailyId, accountName: name, toAccountName: '', categoryName: 'Other', accountId: accountId, categoryId: categoryId, toAccountId: '', amount: _amount, note: note, type: IncomeType, bookmark: '', image: '',isUpload: 'false',isActive: '1', createdAt: date, createdBy: createdBy, updatedAt: date, updatedBy: createdBy, other: 'Other');
    await TransactionService.saveTransaction(transaction);
    var accountGroupList = await database.tblAccountGroupDao.selectAccountGroupByName(accountGroupId,createdBy.toString(),'1');
    if(accountGroupList.length>0){
      var i=accountGroupList[0];
      var accountList=await database.tblAccountDao.selectAccountByGroupId(i.id,createdBy,'1');
      var accountTotal=0;
      if(accountList.length>0){
        for(var j in accountList){
          accountTotal+=int.parse(j.subAmount);
        }
      }
      var group=TBLAccountGroup(i.id, i.name, accountTotal.toString(), 'false','1', i.createdAt,  i.createdBy,  i.updatedAt,  i.updatedBy);
      await AccountGroupService.updateAccountGroup(group);
    }
    var list = await database.tblAccountDao.selectAccountByName(createdBy,'1');
    return list;
  }
  static Future<List<TBLAccount>> getAllAccount(List<TBLAccountGroup> accountGroupList)async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    var createdBy=pref.getString(mProfileId);
    List<TBLAccount> accountList=[];
    final database =
    await $FloorAppDatabase.databaseBuilder(dbName).build();
    print('Account group list:${accountGroupList.length}');
    accountList=await database.tblAccountDao.selectAccountByName(createdBy.toString(), '1');
    print('Account select:${accountList.length}');
    return accountList;
  }

  static Future<List<TBLAccount>> getAllAccountByGroupId(String groupId)async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    var createdBy=pref.getString(mProfileId);
    final database =
    await $FloorAppDatabase.databaseBuilder(dbName).build();
    var mList = await database.tblAccountDao.selectAccountByGroupId(groupId,createdBy.toString(),'1');
    return mList;
  }
  static Future<void> deleteAccountById(String id)async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    var code=myanmarCode;
    if(pref.getString(selected_country)!=null){
      code=pref.getString(selected_country)!;
    }
    var createdBy=pref.getString(mProfileId);
    final database=await $FloorAppDatabase.databaseBuilder(dbName).build();
    await database.tblAccountDao.deleteByAccountId(id,createdBy.toString(),'0');
    await database.tblAccountDao.deleteByAccountIdUploaded(id,createdBy.toString(),'false');

    var list=await database.tblAccountDao.selectAccountById(id,'0');
    if(list.length>0){
      DownloadUploadAll.uploadAccount(list,code);
    }

  }

}