import 'dart:math';
import 'package:AthaPyar/componenets/custom_ads.dart';
import 'package:AthaPyar/controller/category_controller.dart';
import 'package:AthaPyar/datatbase/model/tbl_category.dart';
import 'package:AthaPyar/helper/size_config.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/screen/transaction_screen/transaction.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class CategoryScreen extends StatefulWidget {
  List<TBLCategory> categoryList;
  String type;
  String transaction;

  CategoryScreen({required this.categoryList, required this.type,required this.transaction});

  @override
  _CategoryScreen createState() =>
      _CategoryScreen(categoryList: categoryList, type: type,transaction:transaction);
}

class _CategoryScreen extends State<CategoryScreen> {
  String type;
  List<TBLCategory> categoryList;
  late int mColor;
  String transaction;

  _CategoryScreen({required this.categoryList, required this.type,required this.transaction});

  var categoryId = '';
  bool isCategory = false;
  CategoryController _categoryController = Get.put(CategoryController());

  @override
  void initState() {
    super.initState();
    _categoryController.onInit();
    _categoryController.categoryNameController.clear();
   _categoryController.getAllTodosAds250();
    _sendAnalyticsEvent(category_screen);

    init();
  }
  @override
  void dispose(){
    super.dispose();
  }
  Future<void> _sendAnalyticsEvent(String eventName) async {
    print('Event Name: $eventName');
    await FirebaseAnalytics.instance.logEvent(
      name: eventName,
      parameters: <String, dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0,
        // Only strings and numbers (ints & doubles) are supported for GA custom event parameters:
        // https://developers.google.com/analytics/devguides/collection/analyticsjs/custom-dims-mets#overview
        'bool': true.toString(),
        'items': [itemCreator()]
      },
    );
    ConstantUtils.logEvent(eventName, ConstantUtils.eventValues);

  }
  AnalyticsEventItem itemCreator() {
    return AnalyticsEventItem(
      affiliation: 'affil',
      coupon: 'coup',
      creativeName: 'creativeName',
      creativeSlot: 'creativeSlot',
      discount: 2.22,
      index: 3,
      itemBrand: 'itemBrand',
      itemCategory: 'itemCategory',
      itemCategory2: 'itemCategory2',
      itemCategory3: 'itemCategory3',
      itemCategory4: 'itemCategory4',
      itemCategory5: 'itemCategory5',
      itemId: 'itemId',
      itemListId: 'itemListId',
      itemListName: 'itemListName',
      itemName: 'itemName',
      itemVariant: 'itemVariant',
      locationId: 'locationId',
      price: 9.99,
      currency: 'USD',
      promotionId: 'promotionId',
      promotionName: 'promotionName',
      quantity: 1,
    );
  }

  void init() async {
    if (categoryList.length > 0) {
      if (categoryList[0].type == type) {
        categoryId = categoryList[0].id;
        _categoryController.categoryNameController.text = categoryList[0].name;
      } else {
        categoryList.clear();
        categoryId = Uuid().v1();
        _categoryController.categoryNameController.clear();
      }
      _categoryController.setCategoryType(type);
    } else {
      categoryList.clear();
      categoryId = Uuid().v1();
      Color _randomColor =
          Colors.primaries[Random().nextInt(Colors.primaries.length)];
      mColor = int.parse(_randomColor.toString());
      _categoryController.categoryNameController.clear();
    }
  }



  Future hideStatusBar() => SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         backgroundColor:ConstantUtils.isDarkMode?dark_background_color:Colors.white ,
        body: SafeArea(

          child: GetBuilder<CategoryController>(
            init: CategoryController(),
            builder: (value) {
              return Padding(padding: EdgeInsets.all(0),child: SingleChildScrollView(child: Column(
                children: [
                 Container(
                      height: getProportionateScreenHeight(50),
                      color:ConstantUtils.isDarkMode?dark_nav_color:themeColor ,
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(onPressed: (){
                            Get.off(() => TransactionScreen(
                              transactionId: '',
                              dailyId: '',
                            ));                  }, icon:  Icon(Icons.arrow_back_ios,color: Colors.white,)),
                          Spacer(),
                          Center(child: Text(
                            'Add Category Name'.tr,
                            style: TextStyle(color: Colors.white),
                          ),),
                          Spacer(),
                        ],
                      ),
                    ),

                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20),
                    child: Container(
                        child: Text(
                          'Category Name'.tr,
                          style: TextStyle(color: Colors.grey),


                        )),),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                        child: TextFormField(
                          style: TextStyle(color: ConstantUtils.isDarkMode?dark_font_grey_color:Colors.black),
                          onChanged: (categoryValue) {
                            setState(() {
                              if (categoryValue.isNotEmpty) {
                                isCategory = false;
                              }
                            });
                          },
                          controller:
                          _categoryController.categoryNameController,
                          decoration: InputDecoration(
                              errorText: isCategory
                                  ? 'Category Name is empty!'
                                  : null,
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(15)),
                              fillColor: ConstantUtils.isDarkMode?dark_background_color:lightGreyBackgroundColor,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(15)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(15))),
                        )
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child:  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(3)),
                          foregroundColor:
                          MaterialStateProperty.all<Color>(
                              Colors.black),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(15.0),
                                  side: BorderSide(color: themeColor))),
                        ),
                        onPressed: () {
                          setState(() {
                            if (_categoryController
                                .categoryNameController.text.isEmpty) {
                              _categoryController
                                  .categoryNameController.text.isEmpty
                                  ? isCategory = true
                                  : isCategory = false;
                            } else {
                              _sendAnalyticsEvent(category_btn);
                              bool isSave=true;


                              if(_categoryController.categoryListByProfileID.length>0){
                                for(var category in _categoryController.categoryListByProfileID){
                                  if(category.name==_categoryController
                                      .categoryNameController.text && category.isActive=='1' && category.type==type){
                                    categoryId=category.id;
                                    isSave=false;
                                    print('CategoryID duplicate: $categoryId');
                                  }
                                }
                              }
                              if(isSave){
                                _categoryController.saveCategory(context,
                                    categoryId,
                                    _categoryController
                                        .categoryNameController.text,
                                    type,transaction);
                              }else{
                                ConstantUtils.showToast("Category Name is duplicate so cannot create.");

                              }

                            }
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(3),
                          child: Text('Save'.tr,style: TextStyle(color: themeColor),),
                        ),
                      ),

                    ),
                  ),
                  SizedBox(height: 50,),
                  CustomAds(height: 250,myBanner: 'myBanner',)

                ],
              )),);
            },
          ),
        ));

  }


}
