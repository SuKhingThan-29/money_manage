import 'package:AthaPyar/database.dart';
import 'package:AthaPyar/datatbase/model/tbl_weekly.dart';
import 'package:AthaPyar/datatbase/model/tbl_weekly_summary.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeeklyService{
  static Future<List<TBL_Weekly>> selectWeeklyByMonth(String monthYear)async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    var createdBy=pref.getString(mProfileId);
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    var list=await database.tblWeeklyDao.selectByMonthYear(monthYear,createdBy.toString());
    return list;
  }

  static Future<List<TBL_Weekly>> selectAll()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    var createdBy=pref.getString(mProfileId);
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    var list=await database.tblWeeklyDao.selectAll(createdBy.toString());
    return list;
  }

  static Future<List<TBLWeeklySummary>> selectWeeklySummaryByMonth(String monthYear)async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    var createdBy=pref.getString(mProfileId);
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    var list=await database.tblWeeklySummaryDao.selectByMonthYear(monthYear,createdBy.toString());
    return list;
  }
}