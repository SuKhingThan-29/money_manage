import 'package:AthaPyar/datatbase/model/tbl_category.dart';
import 'package:floor/floor.dart';

@dao
abstract class TBLCategoryDao{
  @Insert(onConflict:OnConflictStrategy.replace)
  Future<void> insert(TBLCategory category);

  @Query('SELECT * FROM TBLCategory WHERE type=:type and createdBy=:createdBy and isActive=:isActive')
  Future<List<TBLCategory>> getAllCategory(String type,String createdBy,String isActive);

  @Query('SELECT * FROM TBLCategory WHERE id=:id and createdBy=:createdBy and isActive=:isActive')
  Future<List<TBLCategory>> selectByCategoryId(String id,String createdBy,String isActive);

  @Query('UPDATE TBLCategory set isActive=:isActive WHERE id=:id and createdBy=:createdBy')
  Future<void> deleteCategoryId(String id,String createdBy,String isActive);

  @Query('UPDATE TBLCategory set isUpload=:isUpload WHERE id=:id and createdBy=:createdBy')
  Future<void> deleteCategoryIdUploaded(String id,String createdBy,String isUpload);

  @Query('SELECT * FROM TBLCategory WHERE createdBy=:createdBy and isActive=:isActive')
  Future<List<TBLCategory>> selectCategoryByCreatedBy(String createdBy,String isActive);

  @Query('SELECT * FROM TBLCategory WHERE createdBy=:createdBy and isUpload=:isUpload')
  Future<List<TBLCategory>> selectNoUpload(String createdBy,String isUpload);

  @Query('SELECT * FROM TBLCategory')
  Future<List<TBLCategory>> selectAll();


}