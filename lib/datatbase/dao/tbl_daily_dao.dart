import 'package:AthaPyar/datatbase/model/tbl_daily.dart';
import 'package:floor/floor.dart';

@dao
abstract class TBLDailyDao{

  @Insert(onConflict:OnConflictStrategy.replace)
  Future<void> insert(TBL_Daily tbl_daily);

  @Query('SELECT * FROM TBL_Daily WHERE monthYear=:monthYear and createdBy=:createdBy and isActive=:isActive order by updatedAt desc')
  Future<List<TBL_Daily>> selectDailyByMonthYear(String monthYear,String createdBy,String isActive);

  @Query('SELECT * FROM TBL_Daily WHERE date=:date and createdBy=:createdBy and isActive=:isActive')
  Future<List<TBL_Daily>> selectDailyByDate(String date,String createdBy,String isActive);


  @Query('SELECT * FROM TBL_Daily WHERE id=:id and isActive=:isActive')
  Future<List<TBL_Daily>> selectById(String id,String isActive);

  @Query('SELECT * FROM TBL_Daily WHERE createdBy=:createdBy and isActive=:isActive order by updatedAt desc')
  Future<List<TBL_Daily>> selectDailyAll(String createdBy,String isActive);



}