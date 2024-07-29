import 'dart:math';

import 'package:AthaPyar/athabyar_api/download_upload_all.dart';
import 'package:AthaPyar/athabyar_api/request_response_model.dart';
import 'package:AthaPyar/database.dart';
import 'package:AthaPyar/datatbase/model/tbl_dailyDetail.dart';
import 'package:AthaPyar/datatbase/model/tbl_account.dart';
import 'package:AthaPyar/datatbase/model/tbl_daily.dart';
import 'package:AthaPyar/datatbase/model/tbl_monthly_summary.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../screen/home_screen/home.dart';

class TransactionService {
  static var uuid = Uuid();
  static Future<List<TBL_DailyDetail>> selectTransactionByDailyId(
      String dailyId) async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var createdBy=await preferences.getString(mProfileId);
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    var mList =
    await database.tblDailyDetailDao.selectByDailyId(dailyId,createdBy.toString(),'1');
    debugPrint('DatilyDetailList: ${mList.length}');
    return mList;
  }

  static Future<List<TBLMonthlySummary>> selectSummaryByMonth(String monthYear) async {
    print('Summary monthYear: $monthYear');
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var createdBy=await preferences.getString(mProfileId);
    var createdAt=DateTime.now();
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    var summaryIncomeResult = 0;
    var summaryExpenseResult = 0;
   var year=monthYear.split(' ')[1];
    var summaryTotal = 0;
    var summaryId;
    var dailyTotalList =
    await database.tblDailyDao.selectDailyByMonthYear(monthYear,createdBy.toString(),'1');
    print('DailySummaryList dailyTotalList: ${dailyTotalList.length}');

    if (dailyTotalList.length > 0) {
       summaryId=dailyTotalList[0].monthlySummaryID;
      for (var j in dailyTotalList) {
        summaryIncomeResult += int.parse(j.incomeAmount);
        summaryExpenseResult += int.parse(j.expenseAmount);
      }
       print('DailySummaryList income: ${summaryIncomeResult}');
       print('DailySummaryList expense: ${summaryExpenseResult}');

       summaryTotal = summaryIncomeResult - summaryExpenseResult;
       var summaryUpdate = TBLMonthlySummary(
           id: summaryId,
           monthYear: monthYear,
           year: year,
           incomeAmount: summaryIncomeResult.toString(),
           expenseAmount: summaryExpenseResult.toString(),
           total: summaryTotal.toString(),
           isUpload: 'false',
           isActive:'1',
           createdAt: createdAt.toString(),
           createdBy: createdBy.toString(),
           updatedAt: createdAt.toString(),
           updatedBy: createdBy.toString());
       await database.tblMonthlySummaryDao.insert(summaryUpdate);
    }
    var mList = await database.tblMonthlySummaryDao.selectByMonthYear(monthYear,createdBy.toString(),'1');
    print('DailySummaryList selected: ${mList.length}');
    for(var i in mList){
      print('DailySummaryListReturn id: ${i.id}');
      print('DailySummaryListReturn name: ${i.monthYear}');
      print('DailySummaryListReturn income: ${i.incomeAmount}');
      print('DailySummaryListReturn expense: ${i.expenseAmount}');
    }
    return mList;
  }
  static Future<List<TBL_DailyDetail>> updateTransaction(
      String id) async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var createdBy=await preferences.getString(mProfileId);
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    var transactionList =
    await database.tblDailyDetailDao.selectAllById(id,createdBy.toString(),'1');
    return transactionList;
  }

  static Future<String> selectTransactionById(
      String id, String date, String dailyID) async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var createdBy=await preferences.getString(mProfileId);
    String dailyId = dailyID;
    var summaryId=uuid.v1();
    var dailyIncomeResult = 0;
    var dailyExpenseResult = 0;
    var dailyTotalResult = 0;
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    debugPrint('MonthYear: selectByTransaction: $date');
    var list = await database.tblDailyDetailDao.selectAllById(id,createdBy.toString(),'1');
    await database.tblDailyDetailDao.deleteById(id,createdBy.toString(),'0');
    var dailyListByIdAndDate =
    await database.tblDailyDao.selectById(dailyID,'1');
    if (dailyListByIdAndDate.length > 0) {
      summaryId = dailyListByIdAndDate[0].monthlySummaryID;
      var transactionList = await database.tblDailyDetailDao
          .selectByDailyId(dailyId,createdBy.toString(),'1');
      if (transactionList.length > 0) {
        for (var i in transactionList) {
          if (i.type == IncomeType && i.categoryId.isNotEmpty) {
            dailyIncomeResult += int.parse(i.amount);
          }
          if (i.type == ExpenseType && i.categoryId.isNotEmpty) {
            dailyExpenseResult += int.parse(i.amount);
          }
        }
      } else {
        dailyIncomeResult = 0;
        dailyExpenseResult = 0;
      }
      dailyTotalResult = dailyIncomeResult - dailyExpenseResult;
      var dailyData = TBL_Daily(
          id: dailyId,
          monthlySummaryID: summaryId,
          date: dailyListByIdAndDate[0].date,
          monthYear: dailyListByIdAndDate[0].monthYear,
          incomeAmount: dailyIncomeResult.toString(),
          expenseAmount: dailyExpenseResult.toString(),
          totalAmount: dailyTotalResult.toString(),
          isUpload: 'false',
          isActive: '1',
          createdAt: dailyListByIdAndDate[0].createdAt,
          createdBy: dailyListByIdAndDate[0].createdBy,
          updatedAt: dailyListByIdAndDate[0].updatedAt,
          updatedBy: dailyListByIdAndDate[0].updatedBy);
      await database.tblDailyDao.insert(dailyData);
    }
    debugPrint('MonthlySummaryID: $summaryId');
    if (list.length > 0) {
      /**
       * Updated Date
       */
      var dailyIdByDate = await database.tblDailyDao.selectDailyByDate(date,createdBy.toString(),'1');
      if (dailyIdByDate.length > 0) {
        dailyId = dailyIdByDate[0].id;
      } else {
        dailyId = Uuid().v1();
      }
      var transactionListSelect = await database.tblDailyDetailDao
          .selectByDailyId(dailyId,createdBy.toString(),'1');
      if (transactionListSelect.length > 0) {
        for (var i in list) {
          if (i.type == IncomeType && i.categoryId.isNotEmpty) {
            dailyIncomeResult += int.parse(i.amount);
          }
          if (i.type == ExpenseType && i.categoryId.isNotEmpty) {
            dailyExpenseResult += int.parse(i.amount);
          }
        }
      } else {
        dailyIncomeResult = 0;
        dailyExpenseResult = 0;
      }

      var daily = TBL_Daily(
          id: dailyId,
          monthlySummaryID: summaryId,
          date: date,
          monthYear: dailyListByIdAndDate[0].monthYear,
          incomeAmount: dailyIncomeResult.toString(),
          expenseAmount: dailyExpenseResult.toString(),
          totalAmount: dailyTotalResult.toString(),
          isUpload: 'false',
          isActive: '1',
          createdAt: dailyListByIdAndDate[0].createdAt,
          createdBy: dailyListByIdAndDate[0].createdBy,
          updatedAt: dailyListByIdAndDate[0].updatedAt,
          updatedBy: dailyListByIdAndDate[0].updatedBy);
      await database.tblDailyDao.insert(daily);
    }
    return dailyId;
  }

  static Future<List<TBL_DailyDetail>> deleteTransaction(
      String id) async {
    SharedPreferences pref=await SharedPreferences.getInstance();
    var createdBy=pref.getString(mProfileId);
    var dailyIncomeResult = 0;
    var dailyExpenseResult = 0;
    var dailyTotalResult=0;
    var summaryIncomeResult = 0;
    var summaryExpenseResult = 0;
    var dailyId = '';
    var summaryId = '';
    var summaryTotal = 0;

    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    var transactionList =
    await database.tblDailyDetailDao.selectAllById(id,createdBy.toString(),'1');
    await database.tblDailyDetailDao.deleteById(id,createdBy.toString(),'0');
    await database.tblDailyDetailDao.deleteByIdUploaded(id,createdBy.toString(),'false');

    var deleted_transaction_list =
    await database.tblDailyDetailDao.selectAllById(id,createdBy.toString(),'0');
    if (transactionList.length > 0) {
      var subAmount=0;
      /**
       * Account Update
       */

      var accList=await database.tblAccountDao.selectAccountById(transactionList[0].accountId,'1');
      if(accList.length>0){
        var data=accList[0];
        if(deleted_transaction_list[0].type==IncomeType){
          subAmount = int.parse(data.subAmount)- int.parse(deleted_transaction_list[0].amount);
        }else{
          subAmount = int.parse(data.subAmount)+ int.parse(deleted_transaction_list[0].amount);
        }
        var account=TBLAccount(data.id, data.name, subAmount.toString(),subAmount.toString(),data.accountGroupId, data.note,'false','1',data.createdAt, data.createdBy, data.updatedAt, data.updatedBy);
        await database.tblAccountDao.insert(account);
      }
      if(transactionList[0].type==TransferType){
        var toAccList=await database.tblAccountDao.selectAccountById(transactionList[0].toAccountId, '1');
        if(toAccList.length>0){
          var todata=toAccList[0];
          subAmount = int.parse(todata.subAmount)- int.parse(deleted_transaction_list[0].amount);
          var account=TBLAccount(todata.id, todata.name, subAmount.toString(),subAmount.toString(),todata.accountGroupId, todata.note,'false','1',todata.createdAt, todata.createdBy, todata.updatedAt, todata.updatedBy);
          await database.tblAccountDao.insert(account);
        }
      }
      dailyId = transactionList[0].dailyId;
      if (dailyId.isNotEmpty) {
        var list = await database.tblDailyDetailDao
            .selectByDailyId(dailyId,createdBy.toString(),'1');
        if (list.length > 0) {
          for (var i in list) {
            if (i.type == IncomeType && i.categoryId.isNotEmpty) {
              dailyIncomeResult += int.parse(i.amount);
            }
            if (i.type == ExpenseType && i.categoryId.isNotEmpty) {
              dailyExpenseResult += int.parse(i.amount);
            }
          }
        } else {
          dailyIncomeResult = 0;
          dailyExpenseResult = 0;
        }
        print('Daily income: $dailyIncomeResult');
        print('Daily Expense: $dailyExpenseResult');
        print('Daily total: $dailyTotalResult');

        dailyTotalResult = dailyIncomeResult - dailyExpenseResult;
        var dailyList = await database.tblDailyDao.selectById(dailyId,'1');

        if (dailyList.length > 0) {
          summaryId = dailyList[0].monthlySummaryID;
          debugPrint('MonthlySummaryID: $summaryId');
          var dailyData = TBL_Daily(
              id: dailyId,
              monthlySummaryID: summaryId,
              date: dailyList[0].date,
              monthYear: dailyList[0].monthYear,
              incomeAmount: dailyIncomeResult.toString(),
              expenseAmount: dailyExpenseResult.toString(),
              totalAmount: dailyTotalResult.toString(),
              isUpload: 'false',
              isActive:'1',
              createdAt: dailyList[0].createdAt,
              createdBy: dailyList[0].createdBy,
              updatedAt: dailyList[0].updatedAt,
              updatedBy: dailyList[0].updatedBy);
          await database.tblDailyDao.insert(dailyData);

          var dailyTotalList =
          await database.tblDailyDao.selectDailyByMonthYear(dailyList[0].monthYear,createdBy.toString(),'1');
          if (dailyTotalList.length > 0) {
            for (var j in dailyTotalList) {
              summaryIncomeResult += int.parse(j.incomeAmount);
              summaryExpenseResult += int.parse(j.expenseAmount);
            }
            summaryTotal = summaryIncomeResult - summaryExpenseResult;
          } else {
            summaryIncomeResult = 0;
            summaryExpenseResult = 0;
            summaryTotal = 0;
          }
          var summaryListById =
          await database.tblMonthlySummaryDao.selectByMonthYear(dailyList[0].monthYear,createdBy.toString(),'1');
          if (summaryListById.length > 0) {
            var year=summaryListById[0].monthYear.split(' ')[1];
            var summaryUpdate = TBLMonthlySummary(
                id: summaryId,
                monthYear: summaryListById[0].monthYear,
                year: year,
                incomeAmount: summaryIncomeResult.toString(),
                expenseAmount: summaryExpenseResult.toString(),
                total: summaryTotal.toString(),
                isUpload:'false',
                isActive:'1',
                createdAt: summaryListById[0].createdAt,
                createdBy: summaryListById[0].createdBy,
                updatedAt: summaryListById[0].updatedAt,
                updatedBy: summaryListById[0].updatedBy);
            await database.tblMonthlySummaryDao.insert(summaryUpdate);

            ConstantUtils utils=ConstantUtils();
            var isInternet=await utils.isInternet();
            /**
             * for upload
             */
            if(isInternet){
              List<TBLMonthlySummary> monthlySummaryUpload=[];
              monthlySummaryUpload.clear();
              monthlySummaryUpload.add(summaryUpdate);
              await DownloadUploadAll.uploadMonthlySummary(monthlySummaryUpload);

              var mDaily=dailyList[0];
              Daily dailyUpload=Daily(id: mDaily.id, summaryId: mDaily.monthlySummaryID, date: mDaily.date, monthYear: mDaily.monthYear, incomeAmount: dailyIncomeResult.toString(), expenseAmount: dailyExpenseResult.toString(), totalAmount: dailyTotalResult.toString(), isActive: mDaily.isActive, createdAt: mDaily.createdAt, createdBy: mDaily.createdBy, updatedAt: mDaily.updatedAt, updatedBy: mDaily.updatedBy, daily_detail: deleted_transaction_list);
              List<Daily> dailyUploadList=[];
              dailyUploadList.add(dailyUpload);
              await DownloadUploadAll.uploadDaily(dailyUploadList);
            }
          }
        }

      }
    }
    var transactionListSelect =
    await database.tblDailyDetailDao.selectAllTransaction(createdBy.toString(),'1');
    debugPrint("DailyDetailUndeleted: ${transactionListSelect.length}");

    return transactionListSelect;
  }

  static Future<List<TBLMonthlySummary>> selectYearly(String year)async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var createdBy=await preferences.getString(mProfileId);
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    var yearlyList = await database.tblMonthlySummaryDao.selectByYear(year,createdBy.toString(),'1');
    if(yearlyList.length>0){
      debugPrint('MonthlySummaryByYear: ${yearlyList.length}');
    }
    return yearlyList;
  }

  static Future<List<TBL_Daily>> selectDaily(String month) async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var createdBy=await preferences.getString(mProfileId);
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    var dailyListSelect = await database.tblDailyDao.selectDailyByMonthYear(month,createdBy.toString(),'1');
    for (var i in dailyListSelect) {
      var incomeAmount=0;
      var expenseAmount=0;
      var _dailyDetailList =
      await TransactionService.selectTransactionByDailyId(i.id);
      for(var j in _dailyDetailList){
        if(j.type==IncomeType){
          incomeAmount +=int.parse(j.amount);
        }
        if(j.type==ExpenseType){
          expenseAmount += int.parse(j.amount);
        }
      }
      var dailyUpdate=TBL_Daily(id: i.id, monthlySummaryID: i.monthlySummaryID, date: i.date, monthYear: i.monthYear, incomeAmount: incomeAmount.toString(), expenseAmount: expenseAmount.toString(), totalAmount: i.totalAmount, isUpload: i.isUpload, isActive: i.isActive, createdAt: i.createdAt, createdBy: i.createdBy, updatedAt: i.updatedAt, updatedBy: i.updatedBy);
      await database.tblDailyDao.insert(dailyUpdate);
    }
    var dailyList = await database.tblDailyDao.selectDailyByMonthYear(month,createdBy.toString(),'1');
    return dailyList;
  }



  /**
   * Summary
   */
  static Future<String> selectSummaryByMonthYear(String date) async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var createdBy=await preferences.getString(mProfileId).toString();
    var summaryId;
    var _monthYear = ConstantUtils.monthFormatter.format(DateTime.parse(date));
    var _year=_monthYear.split(' ')[1];
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    var mSummaryList =
    await database.tblMonthlySummaryDao.selectByMonthYear(_monthYear,createdBy.toString(),'1');
    debugPrint("SummaryList: ${mSummaryList.length}");
    if (mSummaryList.length > 0) {
      summaryId = mSummaryList[0].id;
      debugPrint("Update summaryId: $summaryId");
      debugPrint("SummaryList summaryId: $summaryId");
      var summary = TBLMonthlySummary(
          id: summaryId,
          monthYear: _monthYear,
          year: _year,
          incomeAmount: '0',
          expenseAmount: '0',
          total: '0',
          isUpload: 'false',
          isActive:'1',
          createdAt: date,
          createdBy: createdBy,
          updatedAt: date,
          updatedBy: createdBy);
      await database.tblMonthlySummaryDao.insert(summary);
      ConstantUtils utils=ConstantUtils();
      var isInternet=await utils.isInternet();
      if(isInternet){
        List<TBLMonthlySummary> monthlySummaryUpload=[];
        monthlySummaryUpload.clear();
        monthlySummaryUpload.add(summary);
        await DownloadUploadAll.uploadMonthlySummary(monthlySummaryUpload);
      }
    } else{
      summaryId=uuid.v1();
      debugPrint("Update -save summaryId: $summaryId");

    }
    debugPrint("SummaryList return summaryId: $summaryId");

    return summaryId;
  }

  /**
   * Daily
   */
  static void selectDailyID(TBL_DailyDetail dailyDetail,
      List<TBL_DailyDetail> dailyDetailList,String createdBy) async {
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    var dailyIncomeResult = 0;
    var dailyExpenseResult = 0;
    var dailyTotalResult=0;
    var dailyIncomeTotal = 0;
    var dailyExpenseTotal = 0;
    var summaryTotal = 0;
    var _monthYear =
    ConstantUtils.monthFormatter.format(DateTime.parse(dailyDetail.date));
    var _year=_monthYear.split(' ')[1];
    if (dailyDetailList.length > 0) {
      for (var i in dailyDetailList) {
        if (i.type == IncomeType && i.categoryId.isNotEmpty) {
          dailyIncomeResult += int.parse(i.amount);
        }
        if (i.type == ExpenseType && i.categoryId.isNotEmpty) {
          dailyExpenseResult += int.parse(i.amount);
        }
      }
    } else {
      dailyIncomeResult = 0;
      dailyExpenseResult = 0;
    }
    print('SummaryId by dailyIncome: $dailyIncomeResult');
    print('SummaryId by dailyExpense: $dailyExpenseResult');

    /**
     * Summary ID
     */
   // String summaryId=uuid.v1();
     String summaryId = await selectSummaryByMonthYear(dailyDetail.date);
     print('SummaryId by date: $summaryId');
    dailyTotalResult = dailyIncomeResult - dailyExpenseResult;
    var dailyData = TBL_Daily(
        id: dailyDetail.dailyId,
        monthlySummaryID: summaryId,
        date: dailyDetail.date,
        monthYear: _monthYear,
        incomeAmount: dailyIncomeResult.toString(),
        expenseAmount: dailyExpenseResult.toString(),
        totalAmount: dailyTotalResult.toString(),
        isUpload: 'false',
        isActive:'1',
        createdAt: dailyDetail.date,
        createdBy: createdBy.toString(),
        updatedAt: dailyDetail.date,
        updatedBy: createdBy.toString());
    await database.tblDailyDao.insert(dailyData);

    var dailyTotalList =
    await database.tblDailyDao.selectDailyByMonthYear(_monthYear,createdBy.toString(),'1');

    if (dailyTotalList.length > 0) {
      for (var j in dailyTotalList) {
        print('SummaryId by dailyIncome: ${j.incomeAmount}');
        print('SummaryId by dailyExpense: ${j.expenseAmount}');
        print('SummaryId by dailyDate: ${j.date}');

        dailyIncomeTotal += int.parse(j.incomeAmount);
        dailyExpenseTotal += int.parse(j.expenseAmount);
      }
      summaryTotal = dailyIncomeTotal - dailyExpenseTotal;
    } else {
      dailyIncomeTotal = 0;
      dailyExpenseTotal = 0;
      summaryTotal = 0;
    }
    var summaryUpdate = TBLMonthlySummary(
        id: summaryId,
        monthYear: _monthYear,
        year: _year,
        incomeAmount: dailyIncomeTotal.toString(),
        expenseAmount: dailyExpenseTotal.toString(),
        total: summaryTotal.toString(),
        isUpload:'false',
        isActive:'1',
        createdAt: dailyDetail.date,
        createdBy: createdBy.toString(),
        updatedAt: dailyDetail.date,
        updatedBy: createdBy.toString());
    await database.tblMonthlySummaryDao.insert(summaryUpdate);

    ConstantUtils utils=ConstantUtils();
    var isInternet=await utils.isInternet();
    if(isInternet){
      List<TBLMonthlySummary> monthlySummaryUpload=[];
      monthlySummaryUpload.clear();
      monthlySummaryUpload.add(summaryUpdate);
      await DownloadUploadAll.uploadMonthlySummary(monthlySummaryUpload);
    }

    /**
     *
     */
    selectAccountCalculation();
    Get.off(() => HomeScreen(
        selectedMenu: 'calendar', showInterstitial: false
    ));
  }
  static Future<void> selectAccountCalculation()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var profileId = await preferences.getString(mProfileId).toString();
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    var data=await database.tblAccountDao.selectAll('1',profileId);

    if (data.length > 0) {
      for (var i in data) {
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
      for(var i in acc_list){
        var expenseAmount = 0;
        var incomeAmount = 0;
        var incomeTransferAmount = 0;
        var subAmountResult = 0;
        if(i.isActive=='1'){
          var dailyDetailFromAccountList = await database.tblDailyDetailDao
              .selectByAccountId(i.id,profileId,'1');
          var dailyDetailToAccountList = await database.tblDailyDetailDao.selectByToAccountId(i.id, profileId, '1');
          if (dailyDetailFromAccountList.length > 0) {
            for (var dailyDetail in dailyDetailFromAccountList) {
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
          subAmountResult=(incomeAmount+incomeTransferAmount)-expenseAmount;
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

  }
  static Future<String> dailyIDSelect(String id) async {
    String dailyId = id;
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    var dailyList = await database.tblDailyDao.selectById(dailyId,'1');
    if (dailyList.length > 0) {
      dailyId = dailyList[0].id;
    }
    return dailyId;
  }

  static Future<String> dailyIDSelectedByDate(String date) async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var createdBy=await preferences.getString(mProfileId);
    String dailyId = '';
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    var dailyList = await database.tblDailyDao.selectDailyByDate(date,createdBy.toString(),'1');
    if (dailyList.length > 0) {
      dailyId = dailyList[0].id;
    } else {
      dailyId = Uuid().v1();
    }
    return dailyId;
  }

  /**
   * Transaction
   */
  static Future<List<TBL_DailyDetail>> saveTransaction(
      TBL_DailyDetail dailyDetail) async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var createdBy=await preferences.getString(mProfileId).toString();
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    await database.tblDailyDetailDao.insert(dailyDetail);
    var dailyDetailList = await database.tblDailyDetailDao
        .selectByDate(dailyDetail.date,createdBy,'1');
    /**
     * Daily
     */
    selectDailyID(dailyDetail, dailyDetailList,createdBy);
    return dailyDetailList;
  }
}
