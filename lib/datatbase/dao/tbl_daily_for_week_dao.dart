import 'package:AthaPyar/datatbase/model/tbl_daily_for_week.dart';
import 'package:floor/floor.dart';

@dao
abstract class TBLDailyForWeekDao{
  @Insert(onConflict:OnConflictStrategy.replace)
  Future<void> insert(TBL_DailyForWeek weekly);

  @Query('SELECT * FROM TBL_DailyForWeek WHERE weeklyId=:weeklyId and createdBy=:createdBy')
  Future<List<TBL_DailyForWeek>> selectByWeeklySummaryId(String weeklyId,String createdBy);

  @Query('SELECT * FROM TBL_DailyForWeek WHERE day=:day and createdBy=:createdBy')
  Future<List<TBL_DailyForWeek>> selectByDay(String day,String createdBy);



}