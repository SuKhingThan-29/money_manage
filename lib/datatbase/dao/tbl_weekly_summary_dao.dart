import 'package:AthaPyar/datatbase/model/tbl_weekly_summary.dart';
import 'package:floor/floor.dart';

@dao
abstract class TBLWeeklySummaryDao{
  @Insert(onConflict:OnConflictStrategy.replace)
  Future<void> insert(TBLWeeklySummary weeklySummary);

  @Query('SELECT * FROM TBLWeeklySummary WHERE monthYear=:monthYear and createdBy=:createdBy')
  Future<List<TBLWeeklySummary>> selectByMonthYear(String monthYear,String createdBy);
}