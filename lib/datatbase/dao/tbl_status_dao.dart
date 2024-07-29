import 'package:AthaPyar/datatbase/model/tbl_status.dart';
import 'package:floor/floor.dart';

@dao
abstract class TBLStatusDao{
  @Insert(onConflict:OnConflictStrategy.replace)
  Future<void> insert(TBLStatus status);

  @Query("SELECT * FROM TBLStatus")
  Future<List<TBLStatus>> selectAll();

  @Query("SELECT * FROM TBLStatus WHERE type=:type and createdBy=:createdBy and monthYear=:monthYear")
  Future<List<TBLStatus>> selectByType(String type,String createdBy,String monthYear);

  @Query('DELETE FROM TBLStatus WHERE id=:id')
  Future<void> deleteById(String id);

}