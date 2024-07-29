import 'package:AthaPyar/datatbase/model/tbl_account.dart';
import 'package:floor/floor.dart';

@dao
abstract class TBLAccountDao{
  @Insert(onConflict:OnConflictStrategy.replace)
  Future<void> insert(TBLAccount categoryGroup);

  @Query('SELECT * FROM TBLAccount WHERE createdBy=:createdBy and isUpload=:isUpload')
  Future<List<TBLAccount>> selectNoUpload(String createdBy,String isUpload);


  @Query("SELECT * FROM TBLAccount WHERE createdBy=:createdBy and isActive=:isActive")
  Future<List<TBLAccount>> selectAccountByName(String createdBy,String isActive);

  @Query('SELECT * FROM TBLAccount WHERE id=:id and isActive=:isActive')
  Future<List<TBLAccount>> selectAccountById(String id,String isActive);

  @Query('SELECT * FROM TBLAccount WHERE accountGroupId=:accountGroupId and createdBy=:createdBy and isActive=:isActive')
  Future<List<TBLAccount>> selectAccountByGroupId(String accountGroupId,String createdBy,String isActive);

  @Query('UPDATE TBLAccount set isActive=:isActive where id=:id and createdBy=:createdBy')
  Future<void> deleteByAccountId(String id,String createdBy,String isActive);

  @Query('UPDATE TBLAccount set isUpload=:isUpload where id=:id and createdBy=:createdBy')
  Future<void> deleteByAccountIdUploaded(String id,String createdBy,String isUpload);

  @Query('UPDATE TBLAccount set isUpload=:isUpload where id=:id')
  Future<void> updateAccount(String id,String isUpload);

  @Query('SELECT * FROM TBLAccount WHERE isActive=:isActive and createdBy=:createdBy')
  Future<List<TBLAccount>> selectAll(String isActive,String createdBy);


}