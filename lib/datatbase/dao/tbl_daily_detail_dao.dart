import 'package:AthaPyar/datatbase/model/tbl_dailyDetail.dart';
import 'package:floor/floor.dart';

@dao
abstract class TBLDailyDetailDao{
  @Insert(onConflict:OnConflictStrategy.replace)
  Future<void> insert(TBL_DailyDetail transaction);

  @Query('SELECT * FROM TBL_DailyDetail WHERE id=:id and createdBy=:createdBy and isActive=:isActive order by updatedAt desc')
  Future<List<TBL_DailyDetail>> selectAllById(String id,String createdBy,String isActive);

  @Query('SELECT * FROM TBL_DailyDetail WHERE dailyId=:dailyId and createdBy=:createdBy and isActive=:isActive order by updatedAt desc')
  Future<List<TBL_DailyDetail>> selectByDailyId(String dailyId,String createdBy,String isActive);

  @Query('SELECT * FROM TBL_DailyDetail WHERE accountId=:accountId and createdBy=:createdBy and isActive=:isActive')
  Future<List<TBL_DailyDetail>> selectByAccountId(String accountId,String createdBy,String isActive);

  @Query('SELECT * FROM TBL_DailyDetail WHERE toAccountId=:toAccountId and createdBy=:createdBy and isActive=:isActive')
  Future<List<TBL_DailyDetail>> selectByToAccountId(String toAccountId,String createdBy,String isActive);

  @Query('SELECT * FROM TBL_DailyDetail WHERE date=:date and createdBy=:createdBy and isActive=:isActive')
  Future<List<TBL_DailyDetail>> selectByDate(String date,String createdBy,String isActive);

  @Query('UPDATE TBL_DailyDetail set isActive=:isActive WHERE id=:id and createdBy=:createdBy')
  Future<void> deleteById(String id,String createdBy,String isActive);

  @Query('UPDATE TBL_DailyDetail set isUpload=:isUpload WHERE id=:id and createdBy=:createdBy')
  Future<void> deleteByIdUploaded(String id,String createdBy,String isUpload);

  @Query('SELECT * FROM TBL_DailyDetail WHERE createdBy=:createdBy and isActive=:isActive')
  Future<List<TBL_DailyDetail>> selectAllTransaction(String createdBy,String isActive);

  @Query('SELECT * FROM TBL_DailyDetail WHERE createdBy=:createdBy and categoryId=:categoryId and isActive=:isActive and monthYear=:monthYear ')
  Future<List<TBL_DailyDetail>> selectDailyDetailByCategoryMonthYear(String createdBy,String categoryId,String isActive,String monthYear);
}