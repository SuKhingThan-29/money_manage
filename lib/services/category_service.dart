import 'package:AthaPyar/athabyar_api/download_upload_all.dart';
import 'package:AthaPyar/database.dart';
import 'package:AthaPyar/datatbase/model/tbl_category.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CategoryService{
  static var uuid = Uuid();

  static Future<void> updateUploadCategory(List<TBLCategory> categoryList)async{
    final database =
    await $FloorAppDatabase.databaseBuilder(dbName).build();
    if(categoryList.length>0){
      for(var i in categoryList){

      }
    }
  }


  static Future<List<TBLCategory>> saveCategory(String id,String name,String type)async{
    var mColor=ConstantUtils.randomOpaqueColor().value.toString();

    SharedPreferences preferences=await SharedPreferences.getInstance();
    var createdBy=await preferences.getString(mProfileId);
    var createdAt=DateTime.now();
    final database =
        await $FloorAppDatabase.databaseBuilder(dbName).build();
    var monthYear=ConstantUtils.monthFormatter.format(createdAt);
    var category=TBLCategory(id: id, name: name,type:type,color:mColor.toString(),monthYear: monthYear.toString(), isUpload: 'false',isActive:'1',createdAt:createdAt.toString(), updatedAt: createdAt.toString(), createdBy: createdBy.toString(), updatedBy: createdBy.toString());
    await database.tblCategoryDao.insert(category);
    ConstantUtils utils=ConstantUtils();
    var isInternet=await utils.isInternet();
    if(isInternet){
      List<TBLCategory> categoryListUpload=[];
      categoryListUpload.add(category);
      DownloadUploadAll.uploadCategory(categoryListUpload);
    }else{
      ConstantUtils.showToast(internetConnectionStatus);
    }
    var list = await database.tblCategoryDao.getAllCategory(type,createdBy.toString(),'1');
    ('Category list: ${list.length}');
    return list;

  }
  static Future<List<TBLCategory>> getAllCategory(String categoryType)async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var createdBy=await preferences.getString(mProfileId);
    final database =
    await $FloorAppDatabase.databaseBuilder(dbName).build();
    var mList = await database.tblCategoryDao.getAllCategory(categoryType,createdBy.toString(),'1');
    return mList;
  }

  static Future<List<TBLCategory>> selectCategoryId(String id)async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var createdBy=await preferences.getString(mProfileId);
    final database =
    await $FloorAppDatabase.databaseBuilder(dbName).build();
    var mList = await database.tblCategoryDao.selectByCategoryId(id,createdBy.toString(),'1');
    return mList;
  }
  static Future<void> deleteCategoryById(String id)async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    var createdBy=await preferences.getString(mProfileId);
    final database =
    await $FloorAppDatabase.databaseBuilder(dbName).build();
    await database.tblCategoryDao.deleteCategoryId(id,createdBy.toString(),'0');
    await database.tblCategoryDao.deleteCategoryIdUploaded(id,createdBy.toString(),'false');

  }


}