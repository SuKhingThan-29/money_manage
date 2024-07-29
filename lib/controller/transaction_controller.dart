import 'package:AthaPyar/athabyar_api/download_upload_all.dart';
import 'package:AthaPyar/athabyar_api/request_response_api.dart';
import 'package:AthaPyar/athabyar_api/request_response_model.dart';
import 'package:AthaPyar/datatbase/model/tbl_dailyDetail.dart';
import 'package:AthaPyar/datatbase/model/tbl_category.dart';
import 'package:AthaPyar/datatbase/model/tbl_daily.dart';
import 'package:AthaPyar/datatbase/model/tbl_monthly_summary.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/models/YearlySummary.dart';
import 'package:AthaPyar/screen/home_screen/home.dart';
import 'package:AthaPyar/services/category_service.dart';
import 'package:AthaPyar/services/transaction_service.dart';
import 'package:cell_calendar/cell_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionController extends GetxController {
  TextEditingController searchController = TextEditingController();
  TextEditingController transactionAmountController = TextEditingController();
  TextEditingController transactionNoteController = TextEditingController();
  List<TBLCategory> categoryList = [];
  List<TBL_DailyDetail> incomeExpenseTransactionList = [];
  List<TBLMonthlySummary> dailySummaryList = [];
  List<TBLMonthlySummary> monthlySummaryList = [];
  List<TBLMonthlySummary> _monthlySummaryList = [];
  List<YearlySummary> yearlySummaryList = [];
  List<YearlySummary> _yearlySummaryList = [];
  List<TBL_Daily> dailyList = [];
  late String selectedMonthYear;
  int selectedMonth = (DateTime.now().month);
  late String currentDay;
  late String profile_Id;
  var numberFormat;
  late String dailyId;
  List<Daily> dailyModelList = [];
  late bool isMonthly = false;
  late bool isWeekly = false;
  //final cellCalendarPageController = CellCalendarPageController();
  var selectedDate;
  var categoryType;
  List<TBL_DailyDetail> searchResult = [];
  var isLoading = true.obs;
  var adsLoading = true.obs;
  bool isInternet=false;
  int mCount50=0;
  int mCount250=0;


  @override
  void onInit() {
    super.onInit();
    init();
  }
  void setCategoryType(String type) async {
    print('Type for category: $type');
    categoryType = type;
    categoryList.clear();
    categoryList = await CategoryService.getAllCategory(categoryType);
    print('CategoryList: ${categoryList.length}');

      update();
  }
  void setMonthlyTab(bool isMonthlyTab){
    isMonthly=isMonthlyTab;
    update();
  }

  Future<String> selectTransactionById(
      String transactionId, String date, String dailyID) async {
    var dailyId = await TransactionService.selectTransactionById(
        transactionId, date, dailyID);
    update();
    return dailyId;
  }


  void deleteTransaction(String id) async {
    incomeExpenseTransactionList.clear();
    incomeExpenseTransactionList =
        await TransactionService.deleteTransaction(id);
    Get.off(() => HomeScreen(
          selectedMenu: 'calendar', showInterstitial: false
        ));
    update();
  }

  void setYear(String year) async {
    int incomeAmount=0;
    int expenseAmount=0;
    int totalAmount=0;
    String createdAt='';
    String createdBy='';
    String id='1dfgsdfgd';
    _monthlySummaryList.clear();
    _monthlySummaryList =
        await TransactionService.selectYearly(year);
    if (_monthlySummaryList.length > 0) {
      monthlySummaryList.clear();
      monthlySummaryList = _monthlySummaryList;
      debugPrint("MonthlySummaryList: ${monthlySummaryList.length}");
      if(monthlySummaryList.length>0){
        _yearlySummaryList.clear();
        for(var i in monthlySummaryList){
          debugPrint("MonthlySummaryList id: ${i.id}");
          debugPrint("MonthlySummaryList month: ${i.monthYear}");
          debugPrint("MonthlySummaryList income: ${i.incomeAmount}");
          debugPrint("MonthlySummaryList expense: ${i.expenseAmount}");
          debugPrint("MonthlySummaryList total: ${i.total}");
          incomeAmount +=int.parse(i.incomeAmount);
          expenseAmount +=int.parse(i.expenseAmount);
          totalAmount +=int.parse(i.total);
          createdAt=i.createdAt;
          createdBy=i.createdBy.toString();
        }
        id=id+createdBy;
        var yearlySummary=YearlySummary(id, incomeAmount.toString(), expenseAmount.toString(), totalAmount.toString(), year, createdAt, createdBy, createdAt, createdBy);
        _yearlySummaryList.add(yearlySummary);
        yearlySummaryList=_yearlySummaryList;
        debugPrint("YearlySummaryList income: ${yearlySummaryList[0].income}");
        debugPrint("YearlySummaryList expense: ${yearlySummaryList[0].expense}");
        debugPrint("YearlySummaryList total: ${yearlySummaryList[0].total}");
      }
    } else {
      monthlySummaryList.clear();
      yearlySummaryList.clear();
    }
    update();
  }

  void setDate(DateTime date) {
    selectedDate = date;
    //update();
  }

  void sendMonthYear(String monthYear) async {
    print('dailyMonthYear : ${monthYear}');

    try {
      List<TBL_Daily> _dailyList = [];
      List<Daily> _dailyModelList = [];
      selectedMonthYear = monthYear;
      _dailyList = await TransactionService.selectDaily(selectedMonthYear);
      if(_dailyList.length>0){
        dailyList.clear();
        dailyList=_dailyList;
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
            daily_detail: _dailyDetailList.length>0?_dailyDetailList:[],
          );
          _dailyModelList.add(daily);

        }
        if (_dailyModelList.length > 0) {
          dailyModelList.clear();
          dailyModelList = _dailyModelList;
          for(var m in dailyModelList){
            print('DailyModel date: ${m.date}');
            print('DailyModel income: ${m.incomeAmount}');
            print('DailyModel expense: ${m.expenseAmount}');

          }
          ConstantUtils util = ConstantUtils();
          var _isInternet = await util.isInternet();
          if(_isInternet){
            DownloadUploadAll.uploadDaily(dailyModelList);
          }
        }else{
          dailyList.clear();
          dailyModelList.clear();
        }
      }else{
        dailyList.clear();
        dailyModelList.clear();
      }
      dailySummaryList.clear();
      dailySummaryList =
      await TransactionService.selectSummaryByMonth(selectedMonthYear);
    } catch(e) {

    }
    isLoading(false);
    update();
  }

  void init() async {
    var dateTimeSelection =
        DateTime(DateTime.now().year, selectedMonth, DateTime.now().day);
    currentDay = ConstantUtils.dayMonthFormatter.format(ConstantUtils.dateTime);
    var currentMonthYear = ConstantUtils.monthFormatter.format(dateTimeSelection);
    sendMonthYear(currentMonthYear);
    numberFormat = new NumberFormat("#,##0", "en_US");
    setDate(dateTimeSelection);
  }

  Future<List<TBL_DailyDetail>> updateTransaction(String transactionId) async {
    incomeExpenseTransactionList.clear();
    incomeExpenseTransactionList =
        await TransactionService.updateTransaction(transactionId);
    update();
    return incomeExpenseTransactionList;
  }

  @override
  void onClose() {
    super.onClose();
  }
  Future<String> selectDailyId(String id) async {
    dailyId = await TransactionService.dailyIDSelect(id);
    update();
    return dailyId;
  }

  Future<String> selectDailyByDate(String date) async {
    dailyId = '';
    dailyId = await TransactionService.dailyIDSelectedByDate(date);
    update();
    return dailyId;
  }

  void saveDailyDetail(TBL_DailyDetail dailyDetail,BuildContext context) async {
    incomeExpenseTransactionList.clear();
    incomeExpenseTransactionList =
        await TransactionService.saveTransaction(dailyDetail);

  }
}
