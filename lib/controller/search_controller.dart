import 'package:AthaPyar/athabyar_api/request_response_model.dart';
import 'package:AthaPyar/database.dart';
import 'package:AthaPyar/datatbase/model/tbl_daily.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/services/transaction_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchController extends GetxController{
  TextEditingController searchController=TextEditingController();
  List<TBL_Daily> dailyList = [];
  List<Daily> dailyModelList = [];

  @override
  void onInit(){
    super.onInit();
    init();
  }
  void init()async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var createdBy=await preferences.getString(mProfileId).toString();
    List<TBL_Daily> _dailyList = [];
    List<Daily> _dailyModelList = [];
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    _dailyList = await database.tblDailyDao.selectDailyAll(createdBy, '1');
    if(_dailyList.length>0) {
      dailyList.clear();
      dailyList = _dailyList;
      for (var i in _dailyList) {
        var _dailyDetailList =
        await TransactionService.selectTransactionByDailyId(i.id);
        var daily = new Daily(
          id: i.id,
          summaryId: i.monthlySummaryID,
          date: i.date,
          monthYear: i.monthYear,
          incomeAmount: i.incomeAmount,
          expenseAmount: i.expenseAmount,
          totalAmount: i.totalAmount,
          isActive: i.isActive,
          createdAt: i.createdAt,
          createdBy: i.createdBy,
          updatedAt: i.updatedAt,
          updatedBy: i.updatedBy,
          daily_detail: _dailyDetailList.length > 0 ? _dailyDetailList : [],
        );
        _dailyModelList.add(daily);
      }
      if (_dailyModelList.length > 0) {
        dailyModelList.clear();
        dailyModelList = _dailyModelList;
      }
      update();
    }
  }
}