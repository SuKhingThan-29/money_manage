import 'dart:io';
import 'package:AthaPyar/controller/search_controller.dart';
import 'package:AthaPyar/controller/transaction_controller.dart';
import 'package:AthaPyar/datatbase/model/tbl_dailyDetail.dart';
import 'package:AthaPyar/helper/size_config.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/screen/home_screen/home.dart';
import 'package:AthaPyar/screen/transaction_screen/transaction.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import '../../../../componenets/custom_ads.dart';

class SearchPage extends StatefulWidget {
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  SearchController _transactionController = Get.put(
      SearchController());
  List<TBL_DailyDetail> _searchList=[];


  @override
  void initState() {
    myBanner.load();
    _transactionController.onInit();
    _sendAnalyticsEvent(search_screen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: ConstantUtils.isDarkMode?dark_background_color:light_background_color,
      //backgroundColor: ConstantUtils.isDarkMode?dark_nav_color:themeColor,
      body: GetBuilder<SearchController>(
        init: SearchController(),
        builder: (value) {
          return SafeArea(child: Stack(
            children: [
            Column(
              children: [
                Container(
                  color:  ConstantUtils.isDarkMode?dark_nav_color:themeColor,
                  height: getProportionateScreenHeight(50),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Get.off(() => HomePageScreen(selectedMenu: 'calendar', showInterstitial: false,));
                          });
                        },
                        child: Container(
                            width: 25,
                            height: 25,
                            child: SvgPicture.asset('assets/settings/on_back.svg')),
                      ),
                      Spacer(),
                      Text(
                        'Search'.tr,
                        style: TextStyle(color: Colors.white),
                      ),
                      Spacer()
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(15),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Flexible(
                          child: FractionallySizedBox(
                              widthFactor: 1.0,
                              child:TextField(
                                style: TextStyle(color: ConstantUtils.isDarkMode?dark_font_grey_color:Colors.black),

                                controller: value.searchController,
                                onChanged: onSearchTextChanged,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.search,color: ConstantUtils.isDarkMode?Colors.white:Colors.grey,),

                                    fillColor: ConstantUtils.isDarkMode?dark_nav_color:lightGreyBackgroundColor,
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: lightGrey, width: 3.0),
                                        borderRadius: BorderRadius.circular(35)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1.0),
                                        borderRadius: BorderRadius.circular(35))),
                              )

                          ),
                        ),
                        SizedBox(width: 5,),
                        GestureDetector(
                          onTap: (){
                            setState(() {

                              onSearchTextChanged('');

                            });

                          },
                          child: Text('Cancel'.tr, style: TextStyle(color: Colors.red),),
                        )

                      ],
                    )
                ),
                _searchList.length>0?Divider(
                  thickness: 1,
                  color: themeColor,
                ):Container(),
                _searchList.length>0?_dailyDetail(_searchList):Container(),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
               // _widgetAdsType
            child: CustomAds(height: 50,myBanner: 'myBanner',),)

          ],));
        },
      )
    );
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

  final BannerAd myBanner = BannerAd(
      adUnitId: Platform.isAndroid?bannerAndroid:bannerIOS,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener()
  );


  Widget _dailyDetail(List<TBL_DailyDetail> dailyDetailList){
    var numberFormat = new NumberFormat("#,##0.00", "en_US");
    return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          physics: PageScrollPhysics(),
          shrinkWrap: true,
          itemCount: dailyDetailList.length,
          itemBuilder: (BuildContext context, int index) {
            return (dailyDetailList[index].categoryId.isEmpty && dailyDetailList[index].type!=TransferType)?Container():InkWell(
                onTap: () {
                  Get.off(() => TransactionScreen(
                      transactionId: dailyDetailList[index].id,
                      dailyId: dailyDetailList[index].dailyId));
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1.0,
                              color: ConstantUtils.isDarkMode
                                  ? dark_border_color
                                  : light_border_color))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      dailyDetailList[index].type == TransferType
                          ? Expanded(
                          child: FractionallySizedBox(
                            widthFactor: 0.8,
                            child: Text(
                              'Transfer'.tr,
                              style:
                              TextStyle(color: fontGreyColor),
                              textAlign: TextAlign.start,
                            ),
                          ))
                          : Expanded(
                          child: FractionallySizedBox(
                            widthFactor: 0.8,
                            child: Text(
                              dailyDetailList[index].categoryName,
                              style: TextStyle(
                                  color: dailyDetailList[index]
                                      .type ==
                                      IncomeType
                                      ? Colors.blue
                                      : Colors.red),
                              textAlign: TextAlign.start,
                            ),
                          )),
                      Expanded(
                          child: FractionallySizedBox(
                              widthFactor: 1.0,
                              child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    dailyDetailList[index].note
                                        .isNotEmpty
                                        ? Text(dailyDetailList[index].note,style: TextStyle(
                                        color: fontGreyColor
                                    ),)
                                        : Container(),
                                    dailyDetailList[index].type ==
                                        TransferType
                                        ? Row(
                                      children: [
                                        Flexible(
                                          child: FractionallySizedBox(
                                            widthFactor: 1.0,
                                            child: Text(
                                              dailyDetailList[
                                              index]
                                                  .accountName,
                                              textAlign:
                                              TextAlign.start,
                                              style: TextStyle(
                                                  color:
                                                  fontGreyColor),
                                            ),
                                          ),),
                                        Container(
                                          padding:
                                          EdgeInsets.all(2),
                                          child: Icon(
                                            Icons.arrow_forward,
                                            size: 14.0,
                                            color:
                                            fontGreyColor,
                                          ),
                                        ),
                                        Flexible(
                                            child: FractionallySizedBox(
                                              widthFactor: 1.0,
                                              child:
                                              Text(
                                                dailyDetailList[
                                                index]
                                                    .toAccountName,
                                                textAlign:
                                                TextAlign.start,
                                                style: TextStyle(
                                                    color:
                                                    fontGreyColor),
                                              ),
                                            ))
                                      ],
                                    )
                                        : Text(
                                      dailyDetailList[index]
                                          .accountName,
                                      textAlign:
                                      TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.blue),
                                    )
                                  ]))),

                      Expanded(
                          child: FractionallySizedBox(
                              widthFactor: 1,
                              child: Text(
                                numberFormat.format(double.parse(
                                    dailyDetailList[index]
                                        .amount)),
                                textAlign: TextAlign.end,
                                style: TextStyle(color:dailyDetailList[index].type==IncomeType?Colors.blue:Colors.red),
                              ))),
                      Text(
                        ConstantUtils.isUSDolllar?mDollar:'K'.tr +
                            ' ' ,
                        textAlign: TextAlign.end,
                        style: TextStyle(color:dailyDetailList[index].type==IncomeType?Colors.blue:Colors.red),
                      )
                    ],
                  ),
                ));
          }),
    );
  }

  onSearchTextChanged(String text) async {
      if (text.isEmpty) {
        _searchList.clear();
        _transactionController.searchController.text='';
        setState(() {
        });
        return;
      }
      List<TBL_DailyDetail> _dailyDetailLists=[];
      ('Daily Search list: ${_transactionController.dailyModelList.length}');
      if(_transactionController.dailyModelList.length>0){
        _transactionController.dailyModelList.forEach((daily) {
          daily.daily_detail.forEach((detail){
            if(detail.categoryName.toLowerCase().contains(text) || detail.categoryName.toUpperCase().contains(text) || detail.accountName.toLowerCase().contains(text) || detail.accountName.toUpperCase().contains(text) || detail.toAccountName.toLowerCase().contains(text) || detail.toAccountName.toUpperCase().contains(text)){
              _dailyDetailLists.add(detail);
            }
          });
        });
      }
      _searchList=_dailyDetailLists;
      setState(() {});
    }
}
