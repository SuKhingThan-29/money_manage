import 'dart:async';
import 'package:AthaPyar/datatbase/dao/tbl_account_summary_dao.dart';
import 'package:AthaPyar/datatbase/dao/tbl_category_dao.dart';
import 'package:AthaPyar/datatbase/dao/tbl_daily_dao.dart';
import 'package:AthaPyar/datatbase/dao/tbl_daily_detail_dao.dart';
import 'package:AthaPyar/datatbase/dao/tbl_exchange_dao.dart';
import 'package:AthaPyar/datatbase/dao/tbl_monthly_summary_dao.dart';
import 'package:AthaPyar/datatbase/dao/tbl_profile_dao.dart';
import 'package:AthaPyar/datatbase/dao/tbl_status_dao.dart';
import 'package:AthaPyar/datatbase/dao/tbl_daily_for_week_dao.dart';
import 'package:AthaPyar/datatbase/dao/tbl_weekly_dao.dart';
import 'package:AthaPyar/datatbase/dao/tbl_weekly_summary_dao.dart';
import 'package:AthaPyar/datatbase/model/tbl_dailyDetail.dart';
import 'package:AthaPyar/datatbase/model/tbl_account_summary.dart';
import 'package:AthaPyar/datatbase/model/tbl_daily.dart';
import 'package:AthaPyar/datatbase/model/tbl_exchange.dart';
import 'package:AthaPyar/datatbase/model/tbl_monthly_summary.dart';
import 'package:AthaPyar/datatbase/model/tbl_daily_for_week.dart';
import 'package:AthaPyar/datatbase/model/tbl_profile.dart';
import 'package:AthaPyar/datatbase/model/tbl_status.dart';
import 'package:AthaPyar/datatbase/model/tbl_weekly.dart';
import 'package:AthaPyar/datatbase/model/tbl_weekly_summary.dart';
import 'package:floor/floor.dart';
import 'datatbase/dao/tbl_account_dao.dart';
import 'datatbase/dao/tbl_account_group_dao.dart';
import 'datatbase/dao/tbl_gold_dao.dart';
import 'datatbase/model/tbl_account_group.dart';
import 'datatbase/model/tbl_account.dart';
import 'datatbase/model/tbl_category.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'datatbase/model/tbl_gold.dart';
part 'database.g.dart'; //generate code!


@Database(version:1,entities:[
  TBLAccountGroup,
  TBLAccount,
  TBLCategory,
  TBL_DailyDetail,
  TBL_Daily,
  TBLMonthlySummary,
  TBL_Weekly,
  TBL_DailyForWeek,
  TBLAccountSummary,
  TBLWeeklySummary,
  TBLProfile,
  TBLStatus,
  TBLExchange,
  TBLGold,
])
abstract class AppDatabase extends FloorDatabase{
  TBLAccountGroupDao get tblAccountGroupDao;
  TBLAccountDao get tblAccountDao;
  TBLCategoryDao get tblCategoryDao;
  TBLDailyDetailDao get tblDailyDetailDao;
  TBLDailyDao get tblDailyDao;
  TBLMonthlySummaryDao get tblMonthlySummaryDao;
  TBLAccountSummaryDao get tblAccountSummaryDao;
  TBLWeeklyDao get tblWeeklyDao;
  TBLDailyForWeekDao get tblDailyForWeekDao;
  TBLWeeklySummaryDao get tblWeeklySummaryDao;
  TBLProfileDao get tblProfileDao;
  TBLStatusDao get tblStatusDao;
  TBLExchangeDao get tblExchangeDao;
  TBLGoldDao get tblGoldDao;
}
// // create migration
// final migration1to2 = Migration(1, 2, (database) async {
//   await database.execute('ALTER TABLE person ADD COLUMN nickname TEXT');
// });
//
// final database = await $FloorAppDatabase
//     .databaseBuilder('app_database.db')
// .addMigrations([migration1to2])
// .build();