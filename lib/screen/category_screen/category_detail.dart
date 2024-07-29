import 'dart:convert';
import 'dart:io';
import 'package:AthaPyar/controller/category_controller.dart';
import 'package:AthaPyar/helper/size_config.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/screen/transaction_screen/transaction.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../componenets/custom_ads.dart';

class CategoryDetailPage extends StatefulWidget {
  String type;
  CategoryDetailPage({required this.type});
  @override
  _CategoryDetailPage createState() => _CategoryDetailPage(type:type);
}

class _CategoryDetailPage extends State<CategoryDetailPage> {
  String type;
  _CategoryDetailPage({required this.type});
  CategoryController _categoryController = Get.put(CategoryController());
  String filePath2 =
      'file:///android_asset/flutter_assets/assets/files/file_360_50.html';
  late WebViewController _webViewController;
  _loadHtmlFromAssets(String filePath) async {
    String fileHtmlContents = await rootBundle.loadString(filePath);
    _webViewController.loadUrl(Uri.dataFromString(fileHtmlContents,
        mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  late BannerAd myBanner;
  bool _isBannerAdReady = false;

  void _myBanner(){
    myBanner = BannerAd(
      adUnitId: Platform.isAndroid ? bannerAndroid : bannerIOS,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
    myBanner.load();
  }
  @override
  void initState() {
    _myBanner();
    _categoryController.onInit();
    _categoryController.setCategoryType(type);
   // _categoryController.getAllTodosAds50();
    _sendAnalyticsEvent(category_detail_screen);

    super.initState();
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
  void dispose(){
    super.dispose();
    myBanner.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ConstantUtils.isDarkMode?dark_background_color:light_background_color,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor:   ConstantUtils.isDarkMode ? dark_nav_color : themeColor,
          leading: IconButton(onPressed: (){
            Get.off(() => TransactionScreen(transactionId: '', dailyId: '',));

          }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,),),
            title: Text(
            'Category Detail'.tr,
            style: TextStyle(color: Colors.white),
            ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Column(

                children: [
                  GetBuilder<CategoryController>(
                    init: CategoryController(),
                    builder: (value) {
                      return Expanded(child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: ScrollPhysics(),
                          itemCount:
                          _categoryController.categoryList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Slidable(
                                actionPane: SlidableDrawerActionPane(),
                                actions: <Widget>[
                                  IconSlideAction(
                                      caption: 'Edit',
                                      color: themeColor,
                                      icon: Icons.edit,
                                      onTap: () {
                                        setState(() {
                                          doEdit(
                                              context,
                                              _categoryController
                                                  .categoryList[index].id);
                                        });
                                      }),
                                  IconSlideAction(
                                      caption: 'Delete',
                                      color: redColor,
                                      icon: Icons.delete,
                                      onTap: () {
                                        setState(() {
                                          doDelete(
                                              context,
                                              _categoryController
                                                  .categoryList[index].id);
                                        });
                                      })
                                ],
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: ConstantUtils.isDarkMode?dark_nav_color:lightGrey,
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1.0, color: ConstantUtils.isDarkMode?dark_border_color:light_border_color))),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: redColor,
                                        ),
                                        width: 20,
                                        height: getProportionateScreenHeight(50),
                                        child: Center(
                                          child: Text(
                                            '',
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        child: Text(_categoryController
                                            .categoryList[index].name,
                                          style: TextStyle(color: ConstantUtils.isDarkMode?dark_font_grey_color:ConstantUtils.lightMode.textColor),

                                        ),
                                      )
                                    ],
                                  ),
                                ));
                          }));
                    },
                  ),

                ],
              ),
              Align(
                  alignment: FractionalOffset.bottomCenter,
                  // child:
                  // _widgetAdsType(context))
                child: CustomAds(height: 50,myBanner: 'myBanner',),)
            ],
          )
        ));
  }
  Widget _widgetAdsType(BuildContext context) {
    return GetBuilder<CategoryController>(
        init: CategoryController(),
        builder: (value) {
          if (value.allTodos.length > 0) {
            if (value.allTodos[0].options == 'custom') {
              var adsData = value.allTodos[0];
              if (value.mCount50 > 0) {
                if (Platform.isAndroid &&
                    value.allTodos[0].custom_advertisement_Android != '0') {
                  return
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
                      ):Container(

                  );
                } else if (Platform.isIOS &&
                    value.allTodos[0].custom_advertisement_IOS != '0') {
                  return
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
                   ;
                } else {
                  return Container();
                }
              } else {
                return Container();
              }
            } else {
              return _isBannerAdReady
                  ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 50.0,
                    width: 320.0,
                    child: AdWidget(ad: myBanner),
                  ))
                  : Container();
            }
          } else {
            return Container();
          }
        });
  }

  void _launchURL(String url) async {
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw 'Could not launch $url';
    }
  }
  void doDelete(BuildContext context, String id) {
    _categoryController.deleteCategoryById(id);
  }

  void doEdit(BuildContext context, String id) {
    _categoryController.updateCategoryById(id);
  }
}
