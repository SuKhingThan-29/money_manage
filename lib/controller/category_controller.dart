import 'package:AthaPyar/athabyar_api/download_upload_all.dart';
import 'package:AthaPyar/athabyar_api/request_response_api.dart';
import 'package:AthaPyar/athabyar_api/request_response_model.dart';
import 'package:AthaPyar/datatbase/model/tbl_category.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/screen/category_screen/category.dart';
import 'package:AthaPyar/screen/category_screen/category_detail.dart';
import 'package:AthaPyar/screen/transaction_screen/transaction.dart';
import 'package:AthaPyar/services/category_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database.dart';

class CategoryController extends GetxController{
  TextEditingController categoryNameController = TextEditingController();

  bool validateName=true;
  late String accountName;
  late String categoryName;

  late String accountId='';
  late String toAccountId='';
  late String categoryId='';
  late String accountGroupId='';
  var numberFormat;

  bool isInternet=false;
  var adsLoading = true.obs;
  List<AdsData> allTodos=[];
  List<AdsData> allTodos250=[];
  List<TBLCategory> categoryList=[];
  List<TBLCategory> categoryListByProfileID=[];
  String categoryType='income';
  int mCount50=0;
  int mCount250=0;

  @override
  void onInit(){
    numberFormat = new NumberFormat("#,##0.00", "en_US");
    super.onInit();
    init();
  }
  void init()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    var createdBy=pref.getString(mProfileId).toString();
    final database =
    await $FloorAppDatabase.databaseBuilder(dbName).build();
    categoryListByProfileID =
    await database.tblCategoryDao.selectCategoryByCreatedBy(createdBy,'1');

  }
  void setCategoryType(String type)async{
    categoryType=type;
    categoryList.clear();
    categoryList =await CategoryService.getAllCategory(type);
    update();
  }

  Future getAllTodosAds250() async {
    adsLoading(true);
    ConstantUtils utils=ConstantUtils();
    isInternet=await utils.isInternet();
    try {
      AdsData? data=await RequestResponseApi.getAds250Response();
      allTodos250.clear();
      if(data!=null){
        allTodos250.add(data);
        SharedPreferences pref=await SharedPreferences.getInstance();
        int mFrequency = int.parse(data.frequency.toString());
        if (data.options == 'custom' && pref.getString('Count250') != null) {
          mCount250 = int.parse(pref.getString('Count250').toString());
          if (mCount250 == 0) {
            pref.setString('Count250', mFrequency.toString());
          }
          if (mCount250 > 0) {
            mCount250--;
            pref.setString('Count250', mCount250.toString());
            mCount250 = int.parse(pref.getString('Count250').toString());
          }
        } else {
          if (data.options == 'custom') {
            pref.setString('Count250', mFrequency.toString());
          }
        }
        mCount250 = int.parse(pref.getString('Count250').toString());
        debugPrint('WidgetAdmob 250: $mCount250');
      }
      update();
      return allTodos250;
    } catch (error) {
      adsLoading(false);
      update();
      throw error;
    }

  }
  void saveCategory(BuildContext context,String id,String name,String type,String transaction) async {
    categoryList.clear();

    categoryList = await CategoryService.saveCategory(id,name,type);
    if(transaction.isNotEmpty){
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>  TransactionScreen(transactionId: '',dailyId: '',)
        ),
      );
    }else{
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>  CategoryDetailPage(type:type)
        ),
      );
    }

    update();
  }

  @override
  void onClose(){
    super.onClose();

  }
  void updateCategoryById(String id)async{
    var list=await CategoryService.selectCategoryId(id);
    if(list.length>0){
      Get.off(()=>CategoryScreen(categoryList: list,type:list[0].type, transaction: '',));
    }
    update();
  }
  void deleteCategoryById(String id)async{
    await CategoryService.deleteCategoryById(id);
    categoryList.clear();
    categoryList=await CategoryService.getAllCategory(categoryType);
    if(categoryList.length>0){
      await DownloadUploadAll.uploadCategory(categoryList);
    }
    update();
  }
}