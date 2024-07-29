import 'dart:io';
import 'package:AthaPyar/controller/account_controller.dart';
import 'package:AthaPyar/controller/account_group_controller.dart';
import 'package:AthaPyar/helper/size_config.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/screen/account_screen/account.dart';
import 'package:AthaPyar/screen/account_screen/account_summary/_account_summary.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../componenets/custom_ads.dart';

class AccountDetailPage extends StatefulWidget {
  String transaction;
    AccountDetailPage({required this.transaction});
  @override
  _AccountDetail createState() => _AccountDetail(transaction:transaction);
}

class _AccountDetail extends State<AccountDetailPage>
    with SingleTickerProviderStateMixin {
  String transaction;
  _AccountDetail({required this.transaction});

AccountGroupController _accountGroupController =
      Get.put(AccountGroupController());
  AccountController _accountController = Get.put(AccountController());
  bool isEditButtonClicked = false;
  bool isMinusButtonClicked = false;
  bool isClosedClicked = false;
  bool isDeleteButtonClicked = false;
  late AnimationController _animationController;
  late Animation _animation;
  bool isSlide=false;
  String filePath =
      'file:///android_asset/flutter_assets/assets/files/file_360_50.html';
  late BannerAd myBanner;
  bool isSlideShow=false;


  @override
  void initState() {
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    init();
    _accountGroupController.onInit();
    _animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    _animation = IntTween(begin: 100, end: 0).animate(_animationController);
    _animation.addListener(() => setState(() {}));
    super.initState();


  }
  void init()async{

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

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child:Container(
          color: ConstantUtils.isDarkMode
              ? ConstantUtils.darkMode.backgroundColor
              : ConstantUtils.lightMode.backgroundColor,
          child:  Stack(
            children: [
              Column(
                children: [
                  Container(
                    color: ConstantUtils.isDarkMode ? dark_nav_color : themeColor,
                    height: getProportionateScreenHeight(50),
                    child:   Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 10,),
                        IconButton(onPressed: (){
                          setState(() {
                            if(isSlideShow){
                              isSlideShow=false;
                            }else{
                              isSlideShow=true;
                            }
                          });

                        }, icon:isSlideShow? SvgPicture.asset('assets/icon/cancel.svg'): Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),iconSize: 30,),
                        Spacer(),
                        Text(
                          'Account'.tr,
                          style: TextStyle(color: Colors.white,fontSize: app_bar_title),
                        ),
                        Spacer(),
                        IconButton(onPressed: (){

                          setState(() {
                            _sendAnalyticsEvent(account_btn);
                            Get.off(() => AccountScreen(accountList: [],transaction: '',));
                          });

                        }, icon:  Icon(
                          Icons.add,
                          color: Colors.white,
                        ),iconSize: 35,),
                        SizedBox(width: 10,),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: AccountSummaryWidget(),
                  ),
                  GetBuilder<AccountGroupController>(
                      init: AccountGroupController(),
                      builder: (value) {
                        return value.accountModelList.length > 0
                            ?Expanded(child:  ListView.builder(
                            physics: PageScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: value.accountModelList.length,
                            itemBuilder:
                                (BuildContext buildContext, int index) {
                              return Column(
                                children: [
                                  Container(
                                    height:
                                    getProportionateScreenHeight(50),
                                    padding: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(

                                      border: Border(
                                        bottom: BorderSide(
                                            width: 1.0,
                                            color: ConstantUtils.isDarkMode?dark_border_color:light_border_color),
                                      ),
                                      color: ConstantUtils.isDarkMode?dark_nav_color:lightGrey,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(value
                                            .accountModelList[index].name,
                                          style: TextStyle(color: ConstantUtils.isDarkMode?dark_font_grey_color:ConstantUtils.lightMode.textColor),

                                        ),
                                        Text(
                                            '${value.numberFormat.format(
                                                double.parse(value
                                                    .accountModelList[index]
                                                    .total))}'+'${ConstantUtils.isUSDolllar?mDollar:'K'.tr}',
                                          style: TextStyle(
                                              color: Colors.blueAccent),
                                        )
                                      ],
                                    ),
                                  ),
                                  value.accountModelList[index].accountList
                                      .length >
                                      0
                                      ?ListView.builder(
                                      physics: PageScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: value
                                          .accountModelList[index]
                                          .accountList
                                          .length,
                                      itemBuilder:
                                          (BuildContext buildContext,
                                          int accountIndex) {
                                        var subAmount=int.parse( value
                                            .accountModelList[
                                        index]
                                            .accountList[
                                        accountIndex]
                                            .subAmount);
                                        return
                                          Slidable(
                                              enabled: true,
                                              actionPane:
                                              SlidableDrawerActionPane(),
                                              actions: <Widget>[

                                                IconSlideAction(
                                                    caption: 'Edit',
                                                    color:
                                                    subAmount==0?themeColor:unSelectedColor,
                                                    icon:
                                                    Icons.edit,
                                                    onTap: () {
                                                     setState(() {
                                                       doEdit(context, value.accountModelList[index].accountList[accountIndex].id);
                                                     });

                                                    }),
                                                IconSlideAction(
                                                    caption: 'Delete',
                                                    color:
                                                    subAmount==0?redColor:unSelectedColor,
                                                    foregroundColor: Colors.black,
                                                    icon:
                                                    Icons.delete,
                                                    onTap: () {
                                                      setState(() {
                                                        isSlide=true;
                                                        isDeleteButtonClicked=true;
                                                        doDelete(context, value.accountModelList[index].accountList[accountIndex].id);
                                                      });

                                                    })
                                              ],
                                              child: Container(

                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              width:
                                                              1.0,
                                                              color: ConstantUtils.isDarkMode?dark_border_color:light_border_color))),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(right: 6),
                                                        height:
                                                        getProportionateScreenHeight(
                                                            50),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          children: [

                                                            isSlideShow?Container(
                                                              decoration:
                                                              BoxDecoration(
                                                                color:
                                                                    subAmount==0?
                                                               redColor:unSelectedColor,
                                                              ),
                                                              width: getProportionateScreenWidth(30),
                                                              height:
                                                              getProportionateScreenHeight(
                                                                  50),
                                                            ): Container(),
                                                            SizedBox(width: 30,),
                                                            Text(value
                                                                .accountModelList[
                                                            index]
                                                                .accountList[
                                                            accountIndex]
                                                                .name,
                                                              style: TextStyle(color: ConstantUtils.isDarkMode?dark_font_grey_color:ConstantUtils.lightMode.textColor),
                                                            ),
                                                            Spacer(),
                                                            Text(
                                            '${(value.numberFormat.format(double.parse(value
                                                .accountModelList[
                                            index]
                                                .accountList[
                                            accountIndex]
                                                .subAmount)))}${ConstantUtils.isUSDolllar?mDollar:'K'.tr}'
                                            ,
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.blueAccent),
                                                            ),

                                                          ],
                                                        ),
                                                      )

                                                    ],
                                                  )));
                                      })
                                      : Container(),

                                ],
                              );
                            })
                        )
                            : Container();
                      }),
                  Container(height: 50,),
                ],
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: CustomAds(height: 50,myBanner: 'myBanner',),)
            ],
          ),
        )
    );
  }



  void doDelete(BuildContext context, String id) {
    _accountController.deleteAccountById(id);
    _accountGroupController.selectAccountGroupList();
  }
  void doEdit(BuildContext context, String id) {
    _accountController.updateAccountById(id);
  }
}
