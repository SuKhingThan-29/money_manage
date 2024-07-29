import 'package:AthaPyar/datatbase/model/tbl_weekly.dart';
import 'package:floor/floor.dart';

@dao
abstract class TBLWeeklyDao{
  @Insert(onConflict:OnConflictStrategy.replace)
  Future<void> insert(TBL_Weekly summary);

  @Query('SELECT * FROM TBL_Weekly WHERE monthYear=:monthYear and createdBy=:createdBy')
  Future<List<TBL_Weekly>> selectByMonthYear(String monthYear,String createdBy);

  @Query('SELECT * FROM TBL_Weekly WHERE createdBy=:createdBy')
  Future<List<TBL_Weekly>> selectAll(String createdBy);

  @Query('SELECT * FROM TBL_Weekly WHERE weekly=:weekly and createdBy=:createdBy')
  Future<List<TBL_Weekly>> selectByWeekDay(String weekly,String createdBy);



}