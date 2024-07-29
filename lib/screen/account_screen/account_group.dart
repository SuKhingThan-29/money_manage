import 'dart:io';
import 'package:AthaPyar/controller/account_group_controller.dart';
import 'package:AthaPyar/datatbase/model/tbl_account_group.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/screen/account_screen/account.dart';
import 'package:AthaPyar/screen/account_screen/account_group_detail.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AccountGroup extends StatefulWidget{
  List<TBLAccountGroup> accountGroupList;
  String accountGroupDetailRoute;
  String accountScreen;
  AccountGroup({required this.accountGroupList,required this.accountGroupDetailRoute,required this.accountScreen});
  @override
  _AccountGroup createState() => _AccountGroup(accountGroupList:accountGroupList,accountGroupDetailRoute:accountGroupDetailRoute,accountScreen:accountScreen);
}


class _AccountGroup extends State<AccountGroup>{
  List<TBLAccountGroup> accountGroupList;
  String accountGroupDetailRoute;
  String accountScreen;
  var accountGroupId='';
  _AccountGroup({required this.accountGroupList,required this.accountGroupDetailRoute,required this.accountScreen});
  AccountGroupController _accountGroupController = Get.put(AccountGroupController());
  bool isAccountGroup=false;
  String filePath2 =
      'file:///android_asset/flutter_assets/assets/files/filePath2.html';
  late WebViewController _webViewController;

  @override
  void initState(){
    super.initState();

    init();

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
  void init()async{
    if(accountGroupList.length>0){
      accountGroupId=accountGroupList[0].id;
      _accountGroupController.accountTypeController.text=accountGroupList[0].name;
    }else{
      accountGroupId=Uuid().v1();
      _accountGroupController.accountTypeController.clear();

    }

  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor:ConstantUtils.isDarkMode?dark_background_color:Colors.white ,
      appBar: AppBar(
        toolbarHeight: app_bar_height,
        automaticallyImplyLeading: false,
          backgroundColor: ConstantUtils.isDarkMode?dark_nav_color:themeColor, centerTitle: true,
          title: Text(
            'Add Account Group'.tr,
            style: TextStyle(color: Colors.white,fontSize: app_bar_title),
          ),
          leading: IconButton(onPressed: (){
            if(accountGroupDetailRoute=='accountGroupDetailRoute'){
              Get.off(()=>AccountGroupDetail(accountScreen: '',));

            }else{
              Get.off(()=>AccountScreen(accountList: [],transaction: '',));
            }

          }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,),),

      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 20, left: 20),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                        'Account Group Name'.tr,
                        style: TextStyle(color: Colors.grey),
                      ),

                  )),
              Padding(
                padding: EdgeInsets.all(20),
                child:Container(
                    width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        style: TextStyle(color: ConstantUtils.isDarkMode?dark_font_grey_color:Colors.black),
                        //inputFormatters: [
                         // LengthLimitingTextInputFormatter(15),
                        //   FilteringTextInputFormatter.allow(
                        //       RegExp("[a-zA-Z ]")),
                        //   FilteringTextInputFormatter.deny(RegExp(r'^\s')),
                         //],
                        onChanged: (groupValue) {
                          setState(() {
                            if (groupValue.isNotEmpty) {
                              isAccountGroup = false;
                            }
                          });
                        },
                        controller:
                        _accountGroupController.accountTypeController,
                        decoration: InputDecoration(
                            errorText: isAccountGroup
                                ? 'Account Group Name is empty!'
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
                child: Container(
                  width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: TextButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.all(3)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                ConstantUtils.isDarkMode?dark_nav_color:Colors.white
                            ),
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

                              if(_accountGroupController.accountTypeController.text.isEmpty){
                                isAccountGroup=true;
                              }else{
                                bool isSave=true;
                                isAccountGroup=false;
                                if(_accountGroupController.accountGroupList.length>0){
                                  for(var accGroup in _accountGroupController.accountGroupList){
                                    if(accGroup.name==_accountGroupController.accountTypeController.text && accGroup.isActive=='1'){
                                      accountGroupId=accGroup.id;
                                      isSave=false;
                                    }
                                  }
                                }
                                if(isSave){
                                  _accountGroupController.saveAccountGroup(accountGroupId,_accountGroupController.accountTypeController.text,accountScreen);
                                }else{
                                  ConstantUtils.showToast("Account Group Name is duplicate so cannot create.");
                                }

                              }
                              _sendAnalyticsEvent(account_group_btn);

                            },
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.all(3),
                            child: Text('Save'.tr,style: TextStyle(color: themeColor),),
                          ),
                        ),

                ),
              ),

            ],
          ),
        )
      ),
    );
  }
  Widget _widgetAdsType(BuildContext context) {
    return GetBuilder<AccountGroupController>(
        init: AccountGroupController(),
        builder: (value) {
          if (value.allTodos.length > 0) {
            if (value.allTodos[0].options == 'custom') {
              var adsData = value.allTodos[0];
              if (value.mCount50 > 0) {
                if (Platform.isAndroid &&
                    value.allTodos[0].custom_advertisement_Android != '0') {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      value.isInternet?Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: WebView(
                          initialUrl: adsData.custom_advertisement_Android,
                          javascriptMode: JavascriptMode.unrestricted,
                          onWebViewCreated:
                              (WebViewController webViewController) {
                            _webViewController = _webViewController;
                            // _loadHtmlFromAssets(
                            //     adsData.custom_advertisement_Android);
                          },
                          javascriptChannels: <JavascriptChannel>[
                            JavascriptChannel(
                                name: 'MessageInvoker',
                                onMessageReceived: (s) {
                                  if (s.message !=null && s.message.isNotEmpty) {
                                    _launchURL(
                                        adsData.site_url);
                                  }

                                }),
                          ].toSet(),
                          gestureNavigationEnabled: true,
                        ),
                      ):Container()
                    ],
                  );
                } else if (Platform.isIOS &&
                    value.allTodos[0].custom_advertisement_IOS != '0') {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      value.isInternet? Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: WebView(
                          initialUrl: adsData.custom_advertisement_IOS,
                          javascriptMode: JavascriptMode.unrestricted,
                          onWebViewCreated:
                              (WebViewController webViewController) {
                            _webViewController = _webViewController;
                            // _loadHtmlFromAssets(
                            //     adsData.custom_advertisement_IOS);
                          },
                          javascriptChannels: <JavascriptChannel>[
                            JavascriptChannel(
                                name: 'MessageInvoker',
                                onMessageReceived: (s) {
                                  if (s.message !=null && s.message.isNotEmpty) {
                                    _launchURL(adsData.site_url);
                                  }
                                }),
                          ].toSet(),
                          gestureNavigationEnabled: true,
                        ),
                      ):Container()
                    ],
                  );
                } else {
                  return Container();
                }
              } else {
                return Container();
              }
            } else {
              return Positioned(
                  bottom: 0,
                  child: Container(
                    height: 50.0,
                    width: 320.0,
                    child: AdWidget(ad: myBanner),
                  ));
            }
          } else {
            return Container();
          }
        });
  }
  final BannerAd myBanner = BannerAd(
      adUnitId: Platform.isAndroid?bannerAndroid:bannerIOS,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener()
  );
  void _launchURL(String url) async {
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw 'Could not launch $url';
    }
  }
}