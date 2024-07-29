import 'package:AthaPyar/datatbase/model/tbl_account_group.dart';
import 'package:floor/floor.dart';

@dao
abstract class TBLAccountGroupDao{
  @Insert(onConflict:OnConflictStrategy.replace)
  Future<void> insert(TBLAccountGroup categoryGroup);

  @Query('SELECT * FROM TBLAccountGroup WHERE createdBy=:createdBy and isActive=:isActive')
  Future<List<TBLAccountGroup>> selectAll(String createdBy,String isActive);

  @Query('SELECT * FROM TBLAccountGroup WHERE createdBy=:createdBy')
  Future<List<TBLAccountGroup>> selectNoUpload(String createdBy);

  @Query('SELECT * FROM TBLAccountGroup WHERE id=:id and createdBy=:createdBy and isActive=:isActive')
  Future<List<TBLAccountGroup>> selectAccountGroupByName(String id,String createdBy,String isActive);

  @Query('UPDATE TBLAccountGroup set isActive=:isActive WHERE id=:id and createdBy=:createdBy')
  Future<void> deleteByAccountGroupId(String id,String createdBy,String isActive);

  @Query('UPDATE TBLAccountGroup set isUpload=:isUpload WHERE id=:id and createdBy=:createdBy')
  Future<void> deleteByAccountGroupIdUploaded(String id,String createdBy,String isUpload);
}