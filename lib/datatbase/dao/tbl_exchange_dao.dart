import 'package:AthaPyar/datatbase/model/tbl_exchange.dart';
import 'package:floor/floor.dart';

@dao
abstract class TBLExchangeDao{
  @Insert(onConflict:OnConflictStrategy.replace)
  Future<void> insert(TBLExchange tblExchange);

  @Query('SELECT * FROM TBLExchange WHERE updatedAt=:updatedAt and createdBy=:createdBy')
  Future<List<TBLExchange>> selectByDate(String updatedAt,String createdBy);

  @Query('DELETE FROM TBLExchange WHERE id=:id')
  Future<void> deleteById(String id);

  @Query('DELETE FROM TBLExchange')
  Future<void> deleteAll();

}