import 'package:AthaPyar/athabyar_api/request_response_api.dart';
import 'package:AthaPyar/athabyar_api/request_response_model.dart';
import 'package:AthaPyar/datatbase/model/tbl_daily.dart';
import 'package:AthaPyar/datatbase/model/tbl_monthly_summary.dart';
import 'package:AthaPyar/datatbase/model/tbl_status.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/services/status_service.dart';
import 'package:AthaPyar/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StatusController extends GetxController{
  List<TBLStatus> statusList=[];
  List<TBLMonthlySummary> _dailySummaryList = [];
  List<TBLMonthlySummary> dailySummaryList = [];
  List<TBL_Daily> dailyList = [];
  List<Daily> dailyModelList = [];
  List<Color> colorList=[];
   Map<String,double>? dataMap;
  var numberFormat;
  late String monthYear;
  var isLoading=true.obs;
  var adsLoading = true.obs;
 // List<AdsData> allTodos = [];
  bool isInternet=false;
  int mCount50=0;
  bool isIncomeClick=false;
  bool isExpenseClick=false;

  @override
  void onInit(){
    init();
    super.onInit();
  }
  void init()async{
    numberFormat = new NumberFormat("#,##0", "en_US");

    var dateTimeSelection=DateTime(
        DateTime.now().year,DateTime.now().month, DateTime.now().day);
    var currentDate=ConstantUtils.monthFormatter.format(dateTimeSelection);
   // await StatusService.insertData(currentDate,IncomeType);
   // update();
  }

  @override
  void dispose(){
    super.dispose();
  }
  void sendMonthYear(String mYear,String type) async {
    List<String> categoryNameList=[];
    List<double> dataList=[];
    List<Color> _colorList=[];
    monthYear=mYear;
    statusList.clear();
    debugPrint('StatusList: mYear $monthYear');
    statusList=await StatusService.insertData(monthYear,type);
    print('StatusListSlectByMonty: select ${statusList.length}');

    if(statusList.length>0){
      colorList.clear();
      debugPrint('DataMapList StatusList length: ${statusList.length}');
      if (statusList.length > 0) {
        for (var i in statusList) {
          _colorList.add(Color(int.parse(i.color)).withOpacity(1));
          double mPercent = double.parse(i.percent);
          categoryNameList.add(i.categoryName);
          dataList.add(mPercent);
        }
        colorList=_colorList;
      }
      Map<String,double> dataMapResult=new Map.fromIterables(categoryNameList, dataList);
      dataMap=dataMapResult;
      debugPrint('DataMapList: ${dataMap!.length}');
      debugPrint('DataMapList colorlist: ${colorList.length}');


    }else{
      statusList.clear();
    }
    _dailySummaryList.clear();
    _dailySummaryList =
    await TransactionService.selectSummaryByMonth(monthYear);
    if(_dailySummaryList.length>0){
      dailySummaryList.clear();
      dailySummaryList=_dailySummaryList;
    }else{
      dailySummaryList.clear();
    }
    update();
  }
}