import 'package:AthaPyar/datatbase/model/tbl_monthly_summary.dart';
import 'package:floor/floor.dart';

@dao
abstract class TBLMonthlySummaryDao{
  @Insert(onConflict:OnConflictStrategy.replace)
  Future<void> insert(TBLMonthlySummary summary);

  @Query('SELECT * FROM TBLMonthlySummary WHERE monthYear=:monthYear and createdBy=:createdBy and isActive=:isActive')
  Future<List<TBLMonthlySummary>> selectByMonthYear(String monthYear,String createdBy,String isActive);

  @Query('SELECT * FROM TBLMonthlySummary WHERE year=:year and createdBy=:createdBy and isActive=:isActive')
  Future<List<TBLMonthlySummary>> selectByYear(String year,String createdBy,String isActive);



}