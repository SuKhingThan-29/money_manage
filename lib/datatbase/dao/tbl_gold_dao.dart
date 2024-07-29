import 'package:AthaPyar/datatbase/model/tbl_gold.dart';
import 'package:floor/floor.dart';

@dao
abstract class TBLGoldDao{
  @Insert(onConflict:OnConflictStrategy.replace)
  Future<void> insert(TBLGold categoryGroup);

  @Query('SELECT * FROM TBLGold WHERE date=:date')
  Future<List<TBLGold>> selectByDate(String date);

  @Query('SELECT * FROM TBLGold')
  Future<List<TBLGold>> selectAll();

}