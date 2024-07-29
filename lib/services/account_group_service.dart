import 'package:AthaPyar/athabyar_api/download_upload_all.dart';
import 'package:AthaPyar/database.dart';
import 'package:AthaPyar/datatbase/model/tbl_account_group.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/services/account_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AccountGroupService{
  static var uuid = Uuid();
  static Future<List<TBLAccountGroup>> insertAccountGroup(String id,String text)async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var code=myanmarCode;
    if(preferences.getString(selected_country)!=null){
      code=preferences.getString(selected_country)!;
    }
    var createdBy=await preferences.getString(mProfileId);
    var createdAt=DateTime.now();
    ('Created By: $createdBy');
    ('Created At: $createdAt');
    var total=0;
    final database =
    await $FloorAppDatabase.databaseBuilder(dbName).build();
    var mList = await database.tblAccountGroupDao.selectAll(createdBy.toString(),'1');
    if(mList.length>0){
      for(var i in mList){
        if(i.name== text){
          var accountList=await AccountService.getAllAccountByGroupId(i.id);
          if(accountList.length>0){
            for(var j in accountList){
              total+=int.parse(j.subAmount);
            }
          }
          id= i.id;
        }
      }
    }
    TBLAccountGroup tblAccountGroup =TBLAccountGroup(id, text,total.toString(),'false','1', createdAt.toString(),createdBy.toString(),createdAt.toString(), createdBy.toString());
    await database.tblAccountGroupDao.insert(tblAccountGroup);
    List<TBLAccountGroup> accountGroupList=[];
    accountGroupList.add(tblAccountGroup);
    ConstantUtils utils=ConstantUtils();
    var isInternet=await utils.isInternet();
    if(isInternet){
      DownloadUploadAll.uploadAccountGroup(accountGroupList,code);
    }else{
      ConstantUtils.showToast('You are offline to upload account group');
      ('AccountGroup Internet Fail');

    }

    var mListSelect = await database.tblAccountGroupDao.selectAll(createdBy.toString(),'1');
    ('AccountGroupSelect: ${mListSelect.length}');
    if(mListSelect.length>0){
      ('AccountGroupSelect createdAt: ${mListSelect[0].createdAt}');
      ('AccountGroupSelect createdBy: ${mListSelect[0].createdBy}');
    }

    return mListSelect;
  }

  static Future<void> updateAccountGroup(TBLAccountGroup accountGroup)async{
    final database=await $FloorAppDatabase.databaseBuilder(dbName).build();
    await database.tblAccountGroupDao.insert(accountGroup);

  }
  static Future<List<TBLAccountGroup>> selectAccountGroupList()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    var createdBy=pref.getString(mProfileId);
    final database =
    await $FloorAppDatabase.databaseBuilder(dbName).build();
    var mList = await database.tblAccountGroupDao.selectAll(createdBy.toString(),'1');
    return mList;
  }
  static Future<List<TBLAccountGroup>> selectAccountGroupListByName(String id,String createdBy)async{
    final database =
    await $FloorAppDatabase.databaseBuilder(dbName).build();
    var mList = await database.tblAccountGroupDao.selectAccountGroupByName(id,createdBy,'1');
    return mList;
  }
  static Future<void> deleteAccountGroupId(String id,String createdBy)async{
    final database =
    await $FloorAppDatabase.databaseBuilder(dbName).build();
    var list=await database.tblAccountDao.selectAccountByGroupId(id,createdBy,'1');
    if(list.length>0){
      ConstantUtils.showToast('You cannot delete acccount group because there are many account');

      // for(var i in list){
      //   await database.tblAccountDao.deleteByAccountId(i.id,createdBy,'0','false');
      //
      // }
    }else{
      await database.tblAccountGroupDao.deleteByAccountGroupId(id,createdBy,'0');
      await database.tblAccountGroupDao.deleteByAccountGroupIdUploaded(id,createdBy,'false');
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var profileId = await preferences.getString(mProfileId).toString();
      print('AccountGroupUploaded profileID: ${profileId}');
      var code=myanmarCode;
      if(preferences.getString(selected_country)!=null){
        code=preferences.getString(selected_country)!;
      }
      var accountGroupList=await database.tblAccountGroupDao.selectNoUpload(profileId);
      print('AccountGroupUploaded: ${accountGroupList.length}');
      if(accountGroupList.length>0){

        //  ConstantUtils.showToast("Need to upload for account group: ${accountGroupList.length}");
        await DownloadUploadAll.uploadAccountGroup(accountGroupList,code);
      }else{
        // Utils.showToast("There is no upload for account group");
      }
    }
  }
}