import 'package:AthaPyar/database.dart';
import 'package:AthaPyar/datatbase/model/tbl_profile.dart';
import 'package:AthaPyar/helper/style.dart';

class SettingService{
  static Future<void> saveProfile(TBLProfile profile)async{
    final database =
    await $FloorAppDatabase.databaseBuilder(dbName).build();
    await database.tblProfileDao.insert(profile);
    print("ProfileSelect UserName: ${profile.user_name}");
    var list= await SettingService.getProfile(profile.createdBy);
    print("ProfileSelect List: ${list.length}");
  }
  static Future<List<TBLProfile>> getProfile(String createdBy)async{
    final database =
    await $FloorAppDatabase.databaseBuilder(dbName).build();
   var list= await database.tblProfileDao.selectByProfileId(createdBy);
    print('Profile List: ${list.length}');
    return list;
  }
}