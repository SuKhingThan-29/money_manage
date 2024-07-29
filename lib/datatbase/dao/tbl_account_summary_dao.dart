import 'package:AthaPyar/datatbase/model/tbl_account_summary.dart';
import 'package:floor/floor.dart';

@dao
abstract class TBLAccountSummaryDao{
  @Insert(onConflict:OnConflictStrategy.replace)
  Future<void> insert(TBLAccountSummary summary);

  @Query('SELECT * FROM TBLAccountSummary WHERE createdBy=:createdBy and isActive=:isActive')
  Future<List<TBLAccountSummary>> selectAll(String createdBy,String isActive);
}