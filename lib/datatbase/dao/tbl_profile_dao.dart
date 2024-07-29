import 'package:AthaPyar/datatbase/model/tbl_profile.dart';
import 'package:floor/floor.dart';

@dao
abstract class TBLProfileDao{
  @Insert(onConflict:OnConflictStrategy.replace)
  Future<void> insert(TBLProfile profile);

  @Query('SELECT * FROM TBLProfile WHERE phone_no=:phoneNo')
  Future<List<TBLProfile>> selectByPhoneNo(String phoneNo);

  @Query('SELECT * FROM TBLProfile WHERE id=:profileId')
  Future<List<TBLProfile>> selectByProfileId(String profileId);
}