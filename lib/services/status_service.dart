import 'package:AthaPyar/datatbase/model/tbl_category.dart';
import 'package:AthaPyar/datatbase/model/tbl_status.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../database.dart';

class StatusService {
  static var uuid = Uuid();
  static Future<List<TBLStatus>> insertData(String monthYear,String type) async {
    List<TBLCategory> categoryList=[];
    var createdAt = DateTime.now().toString();
    SharedPreferences pref = await SharedPreferences.getInstance();
    var createdBy = pref.getString(mProfileId).toString();
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    categoryList.clear();
     categoryList =
        await database.tblCategoryDao.selectCategoryByCreatedBy(createdBy,'1');
    var _dailySummaryList =
    await TransactionService.selectSummaryByMonth(monthYear);

    if (categoryList.length > 0) {
      var amount;
      var incomeTotal;
      var expenseTotal;
      var incomePercentResult;
      var expensePercentResult;
      for (var i in categoryList) {
        var dailyDetailList = await database.tblDailyDetailDao
            .selectDailyDetailByCategoryMonthYear(
                createdBy, i.id,'1',monthYear);
        debugPrint('StatusList db dailyDetail: ${dailyDetailList.length}');

        amount = 0;
        incomeTotal=0;
        incomePercentResult=0.0;
        expensePercentResult=0.0;
        if (dailyDetailList.length > 0){
          for (var j in dailyDetailList) {
            amount += int.parse(j.amount);
          }
          if(_dailySummaryList.length>0){
            var dailyDetail=dailyDetailList[0];
            incomeTotal=int.parse(_dailySummaryList[0].incomeAmount);
            expenseTotal=int.parse(_dailySummaryList[0].expenseAmount);
            if(dailyDetail.type==IncomeType){
              incomeTotal=int.parse(_dailySummaryList[0].incomeAmount);
              incomePercentResult=(amount/incomeTotal)*100;
            }
            if(dailyDetail.type==ExpenseType){
              expensePercentResult=(amount/expenseTotal)*100;
            }
          }
          var percent=0.0;
          if(i.type==IncomeType){
            percent=incomePercentResult;
          }else if(i.type==ExpenseType){
            percent=expensePercentResult;
          }
          var status = TBLStatus(
              id: i.id,
              categoryName: i.name,
              type: i.type,
              amount: amount.toString(),
              percent: percent.toString(),
              color:i.color.toString(),
              monthYear: monthYear,
              createdAt: i.createdAt,
              createdBy: createdBy,
              updatedAt: createdAt,
              updatedBy: createdBy);
          debugPrint('StatusList categoryName: ${i.name}');
          debugPrint('StatusList amount: ${amount}');
          await database.tblStatusDao.insert(status);
        }else{
          await database.tblStatusDao.deleteById(i.id);
        }

      }
    }
    var list=await database.tblStatusDao.selectByType(type,createdBy, monthYear);
    debugPrint('StatusList db insert: ${list.length}');

    return list;
  }
  static Future<List<TBLStatus>> selectedData(String monthYear,String type)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var createdBy = pref.getString(mProfileId).toString();
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    var list=await database.tblStatusDao.selectByType(type,createdBy, monthYear);
    //var list=await database.tblStatusDao.selectAll();
    debugPrint('StatusList db: ${list.length}');

    return list;
  }
}
