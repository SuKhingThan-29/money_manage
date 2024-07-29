import 'package:AthaPyar/database.dart';
import 'package:AthaPyar/datatbase/model/tbl_daily_for_week.dart';
import 'package:AthaPyar/datatbase/model/tbl_weekly.dart';
import 'package:AthaPyar/datatbase/model/tbl_weekly_summary.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/models/weekly.dart';
import 'package:AthaPyar/models/weeklySummary.dart';
import 'package:AthaPyar/services/weekly_service.dart';
import 'package:cell_calendar/src/date_extension.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class WeeklyController extends GetxController{
  List<TBL_Weekly> weeklyList=[];
  var selectedDate;
  List<Weekly> weeklyModelList=[];
  late String selectedMonthYear;
  List<WeeklySummary> weeklySummaryModelList = [];
  var numberFormat;

  @override
  void onInit(){
    numberFormat = new NumberFormat("#,##0", "en_US");

    super.onInit();
  }
  void setDate(DateTime date){
    selectedDate=date;
    getInit(selectedDate);
    update();
  }
  DateTime _getFirstDay(DateTime dateTime) {
    final firstDayOfTheMonth = DateTime(dateTime.year, dateTime.month, 1);
    update();
    return firstDayOfTheMonth.add(firstDayOfTheMonth.weekday.daysDuration);

  }
  List<DateTime> _getCurrentDays(DateTime dateTime) {
    final firstDay = _getFirstDay(dateTime);
    final List<DateTime> result = [];
    result.clear();
    result.add(firstDay);
    for (int i = 0; i + 1 < 42; i++) {
      result.add(firstDay.add(Duration(days: i + 1)));
    }
    update();
    return result;

  }
  Future<void> getInit(DateTime date) async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var createdBy=await preferences.getString(mProfileId);
    var createdAt=DateTime.now();
    ('weekly date: $date');
    var mMonth=ConstantUtils.monthFormatter.format(date);
    selectedMonthYear = mMonth;
    ('WeekDay montheYear: $selectedMonthYear');
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    var weeklyByMonthList=await database.tblWeeklyDao.selectByMonthYear(selectedMonthYear,createdBy.toString());
    ('WeekDay byMonthList first: ${weeklyByMonthList.length}');

    try {
      {
            final days = _getCurrentDays(date);
            String currentTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString();
            try {
              for (var k = 0; k < 7; k++) {
                var weekDayList = days.getRange(k * 7, (k + 1) * 7);
                var mMonthYear = ConstantUtils.monthFormatter.format(
                    DateTime.parse(days
                        .getRange(0, 7)
                        .last
                        .toString()));

                String weekDay = '${ConstantUtils.dayMonthFormatter.format(
                    DateTime.parse(weekDayList.first.toString()))}~${ConstantUtils.dayMonthFormatter.format(
                    DateTime.parse(weekDayList.last.toString()))}';
                var weeklyListSelectList=[];
                weeklyListSelectList.clear();
                ('WeekDay select: $weekDay');
                weeklyListSelectList = await database.tblWeeklyDao.selectByWeekDay(
                    weekDay,createdBy.toString());
                ('WeekDay length: ${weeklyListSelectList.length}');

                var weeklyId;
                if (weeklyListSelectList.length > 0) {
                  weeklyId = weeklyListSelectList[0].id;
                }else{
                  weeklyId = Uuid().v1();
                }
                for(var j in weekDayList){
                  var dailyDate=j.toString();
                  var dailySelect=[];
                  dailySelect.clear();
                  dailySelect = await database.tblDailyDao.selectDailyByDate(dailyDate,createdBy.toString(),'1');
                  var income = 0;
                  var expense = 0;
                  if (dailySelect.length > 0) {
                    income = int.parse(dailySelect[0].incomeAmount);
                    expense = int.parse(dailySelect[0].expenseAmount);
                  }else{
                    income=0;
                    expense=0;
                  }
                  var dailyID=Uuid().v1();
                  var dailyForWeekList=[];
                  dailyForWeekList.clear();
                  dailyForWeekList = await database.tblDailyForWeekDao.selectByDay(
                      dailyDate,createdBy.toString());

                  if(dailyForWeekList.length>0){
                    dailyID=dailyForWeekList[0].id;
                  }
                  var tblDaily=TBL_DailyForWeek(id: dailyID, day: dailyDate, weeklyId: weeklyId, income: income.toString(), expense: expense.toString(), createdAt: createdAt.toString(), createdBy: createdBy.toString(), updatedAt: createdAt.toString(), updatedBy: createdBy.toString());
                  await database.tblDailyForWeekDao.insert(tblDaily);
                }
                var weeklyList=[];
                weeklyList.clear();
                weeklyList = await database.tblDailyForWeekDao
                    .selectByWeeklySummaryId(weeklyId,createdBy.toString());
                var weekly_Income = 0;
                var weekly_Expense = 0;
                if(weeklyList.length>0){
                  for (var k in weeklyList) {
                    weekly_Income += int.parse(k.income);
                    weekly_Expense += int.parse(k.expense);
                  }
                }else{
                  weekly_Income = 0;
                  weekly_Expense = 0;
                }

                //*********************
                weeklyListSelectList.clear();
                weeklyListSelectList = await database.tblWeeklyDao.selectByWeekDay(
                    weekDay,createdBy.toString());
                ('WeeklyList weekday : ${weeklyListSelectList.length}');

                if (weeklyListSelectList.length > 0) {
                  weeklyId = weeklyListSelectList[0].id;
                  var tblWeekly = TBL_Weekly(
                      id: weeklyId,
                      weekly: weekDay,
                      monthYear: mMonthYear,
                      income: weekly_Income.toString(),
                      expense: weekly_Expense.toString(),
                      createdAt: currentTime,
                      createdBy: createdBy.toString(),
                      updatedAt: currentTime,
                      updatedBy: createdBy.toString());
                  await database.tblWeeklyDao.insert(tblWeekly);
                }else{
                  weeklyId = Uuid().v1();
                  var tblWeekly = TBL_Weekly(
                      id: weeklyId,
                      weekly: weekDay,
                      monthYear: mMonthYear,
                      income: weekly_Income.toString(),
                      expense: weekly_Expense.toString(),
                      createdAt: currentTime,
                      createdBy: createdBy.toString(),
                      updatedAt: currentTime,
                      updatedBy: createdBy.toString());
                  await database.tblWeeklyDao.insert(tblWeekly);
                }

                var tblWeeklySummaryList=[];
                tblWeeklySummaryList.clear();
                tblWeeklySummaryList=await database.tblWeeklySummaryDao.selectByMonthYear(mMonthYear,createdBy.toString());
                var mWeeklySummaryId=Uuid().v1();
                var weekly_Summary_Income = 0;
                var weekly_Summary_Expense = 0;
                var weekly_Total=0;
                if(tblWeeklySummaryList.length>0){
                  mWeeklySummaryId=tblWeeklySummaryList[0].id;
                }
                var mWeeklyList=[];
                mWeeklyList.clear();
                mWeeklyList=await database.tblWeeklyDao.selectByMonthYear(mMonthYear,createdBy.toString());
                if(mWeeklyList.length>0){
                  for(var m in mWeeklyList){
                    weekly_Summary_Income+=int.parse(m.income);
                    weekly_Summary_Expense+=int.parse(m.expense);
                  }
                  weekly_Total =weekly_Summary_Income - weekly_Summary_Expense;

                }else{
                  mWeeklyList.clear();
                  weekly_Summary_Income=0;
                  weekly_Summary_Expense=0;
                  weekly_Total=0;
                }

                var tblWeeklySummary=TBLWeeklySummary(id: mWeeklySummaryId, income: weekly_Summary_Income.toString(), expense: weekly_Summary_Expense.toString(), total: weekly_Total.toString(), monthYear: mMonthYear, createdAt: createdAt.toString(), createdBy: createdBy.toString(), updatedAt: createdAt.toString(), updatedBy: createdBy.toString());
                await database.tblWeeklySummaryDao.insert(tblWeeklySummary);

              }
            } catch (e) {
              print(e);
            }
          }
    } catch (e) {
      ('WeekDay trycatch ${e.toString()}');
    }
    List<Weekly> _weeklyList=[];
    List<WeeklySummary> _weeklySummaryModelList = [];
    List<TBLWeeklySummary> weeklySummaryList=[];
    weeklyList.clear();
    weeklyList=await database.tblWeeklyDao.selectByMonthYear(selectedMonthYear,createdBy.toString());
    ('MonthY byMonthList2: ${weeklyList.length}');
    // if(weeklyList!=null && weeklyList.length>0){
    //   for(var z in weeklyList){
    //     ('MonthY select weekly: ${z.weekly}');
    //     ('MonthY select month: ${z.monthYear}');
    //     ('MonthY select createdBy: ${z.createdBy}');
    //
    //   }
    // }
    weeklySummaryList.clear();
    weeklySummaryList=await WeeklyService.selectWeeklySummaryByMonth(selectedMonthYear);
    if(weeklyList.length>0){
      _weeklyList.clear();
      for(var k in weeklyList){
        var weekly=Weekly(id: k.id, weekly: k.weekly, monthYear: k.monthYear, income: k.income, expense: k.expense, createdAt: k.createdAt, createdBy: k.createdBy, updatedAt: k.updatedAt, updatedBy: k.updatedBy);
        _weeklyList.add(weekly);
      }
    }else{
      weeklyList.clear();
    }
    if(_weeklyList.length>0){
      weeklyModelList.clear();
      weeklyModelList=_weeklyList;
    }else{
      weeklyModelList.clear();
    }
    if(weeklySummaryList.length>0){
      _weeklySummaryModelList.clear();
      for(var w in weeklySummaryList){
        var weeklySummary=WeeklySummary(id: w.id, income: w.income, expense: w.expense, total: w.total, monthYear: w.monthYear, createdAt: w.createdAt, createdBy: w.createdBy, updatedAt: w.updatedAt, updatedBy: w.updatedBy);
        _weeklySummaryModelList.add(weeklySummary);
      }
    }else{
      _weeklySummaryModelList.clear();
    }
    if(_weeklySummaryModelList.length>0){
      weeklySummaryModelList.clear();
      weeklySummaryModelList=_weeklySummaryModelList;
    }else{
      weeklySummaryModelList.clear();
    }
    update();
  }
}