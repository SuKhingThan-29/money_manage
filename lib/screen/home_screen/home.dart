import 'dart:async';
import 'dart:io';
import 'package:AthaPyar/componenets/user_guide.dart';
import 'package:AthaPyar/controller/transaction_controller.dart';
import 'package:AthaPyar/helper/size_config.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/screen/account_screen/account_detail.dart';
import 'package:AthaPyar/screen/exchange_screen/exchange_screen.dart';
import 'package:AthaPyar/screen/home_screen/component/body.dart';
import 'package:AthaPyar/screen/status_screen/StatusScreenPage.dart';
import 'package:AthaPyar/screen/transaction_screen/transaction.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/localization_service.dart';

class HomeScreen extends StatelessWidget {
  String selectedMenu;
  bool showInterstitial;

   HomeScreen({Key? key,required this.selectedMenu,required this.showInterstitial}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return HomePageScreen(selectedMenu:selectedMenu,showInterstitial: showInterstitial);
  }
}

class HomePageScreen extends StatefulWidget {
  String selectedMenu;
  bool showInterstitial;

  HomePageScreen({required this.selectedMenu,required this.showInterstitial});
  @override
  _HomePageScreen createState() => _HomePageScreen(selectedMenu:selectedMenu,showInterstitial:showInterstitial);
}

class _HomePageScreen extends State<HomePageScreen> with WidgetsBindingObserver  {
  String selectedMenu;
  bool showInterstitial;
  _HomePageScreen({required this.selectedMenu,required this.showInterstitial});
  final Color inActiveIconColor = Colors.white;
  int _selectedIndex = 0;
  String currentDay = ConstantUtils.dayMonthFormatter.format(ConstantUtils.dateTime);
  final TransactionController _commonController =
      Get.put(TransactionController());
  String selectedDate = '';
  late String account='account';
  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);
  final List<Widget> _widgetOptions = <Widget>[
    Body(),
    StatusScreenPage(),
    AccountDetailPage(transaction: '',),
    ExchangePage(),
  ];
  bool loading = false;
  var allTodos = [];
  int freq=0;
  int dura=0;
  bool unShowInterstitialAdmob=true;

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
      hideStatusBar();
      init();
      isUserGuide();
      _sendAnalyticsEvent('HomePage');

    if(showInterstitial){
       // showCustomOrAdmob();
      }
    // Add the observer.
    WidgetsBinding.instance.addObserver(this);
  }

  void isUserGuide()async{
    bool isUserGuide=true;
    SharedPreferences pref=await SharedPreferences.getInstance();

    late String _selectedLang;
    _selectedLang = LocalizationService.langs.first;
    LocalizationService().changeLocale(_selectedLang);
    if(pref.getString(Lang)!=null){
      _selectedLang=await pref.getString(Lang)!;
    }
    LocalizationService().changeLocale(_selectedLang);
    pref.setString(Lang, _selectedLang);
    if(pref.getBool(isUserGuideWork) !=null){
      isUserGuide=pref.getBool(isUserGuideWork)!;
    }
    print('IsFirstImg userGuideWork $isUserGuide');
    if(isUserGuide){
      Navigator.of(context).push(UserGuideState(img:_selectedLang=='English'?'assets/icon/transaction/transactionClick-eng.svg':'assets/icon/transaction/transactionClick.svg',skipName:'transaction',onCountChange: (bool res) {
        setState(() {
          if(res){
            _sendAnalyticsEvent(transaction_screen_click);
            Get.off(() => TransactionScreen(
              transactionId: '',
              dailyId: '',
            ));
          }
        });
      },onSkipChange: (String name){
        if(name=='transaction'){
          setState(() {
            _sendAnalyticsEvent(transaction_screen_click);
            Get.off(() => TransactionScreen(
              transactionId: '',
              dailyId: '',
            ));
          });
        }
      }));
    }
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
  void dispose() {
    // Remove the observer
    WidgetsBinding.instance.removeObserver(this);
    _interstitialAd?.dispose();

    super.dispose();
  }
  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('Showad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('Showad $ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('Showad $ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();

    _interstitialAd = null;
  }
  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? interstitialAndroid
            : interstitialIOS,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));

  }

  Future<void> showCustomOrAdmob()async{
    bool isDarkMode=false;
    SharedPreferences pref=await SharedPreferences.getInstance();
    if(pref.getBool(is_Switch)!=null){
      isDarkMode=(await pref.getBool(is_Switch))!;
      print('Show Style: $isDarkMode');

    }
    if(isDarkMode){
      pref.setBool(is_Switch, true);
      ConstantUtils.isDarkMode=true;
    }else{
      pref.setBool(is_Switch, false);
      ConstantUtils.isDarkMode=false;
    }
    String code=myanmarCode;
    if(pref.getString(selected_country)!=null){
      code=pref.getString(selected_country).toString();
    }
    if(code==cambodiaCode){
      ConstantUtils.isUSDolllar=true;
    }else{
      ConstantUtils.isUSDolllar=false;
    }
    var mCount480=0;
    ConstantUtils utils=ConstantUtils();
    var isInternet=await utils.isInternet();
    if(isInternet){
      // AdsData? data=await RequestResponseApi.getAds480Response();
      // if(data!=null){
      //   if (data.options == 'custom') {
      //     if(pref.getString('mCount480')!=null){
      //       mCount480 = int.parse(pref.getString('mCount480').toString());
      //     }
      //     if (mCount480 == 0) {
      //       pref.setString('mCount480', data.frequency.toString());
      //     }
      //     if (mCount480 > 0) {
      //       mCount480--;
      //       pref.setString('mCount480', mCount480.toString());
      //     }
      //   }
      //   if(pref.getString('mCount480')!=null){
      //     mCount480 = int.parse(pref.getString('mCount480').toString());
      //     print('Show Custom 480: $mCount480');
      //   }
      //
      //   if(data.options=='custom'  && Platform.isAndroid){
      //     if((data.Frequency_ONOFF=='' || data.Frequency_ONOFF=='0')|| (data.Frequency_ONOFF=='on' && mCount480>0 && data.custom_Android_ONOFF=='on')){
      //       debugPrint('CustomAllToDo show: ${mCount480}');
      //
      //     //  Navigator.of(context).push(TutorialOverlay(data:data.custom_advertisement_Android,dataURL:data.site_url,duration:data.duration));
      //     }}else if(data.options=='custom' && Platform.isIOS){
      //       if((data.Frequency_ONOFF=='' || data.Frequency_ONOFF=='0') || (data.Frequency_ONOFF=='on' && mCount480>0 && data.custom_IOS_ONOFF=='on')){
      //         debugPrint('CustomAllToDo show: ${mCount480}');{
      //     //  Navigator.of(context).push(TutorialOverlay(data:data.custom_advertisement_IOS,dataURL:data.site_url,duration:data.duration));
      //     }}
      //   }else if(data.options=='admod'){
      //     if(data.admod_Android_ONOFF=='on' && Platform.isAndroid){
      //       _showInterstitialAd();
      //     }else if(data.admod_IOS_ONOFF=='on' && Platform.isIOS){
      //       _showInterstitialAd();
      //     }
      //
      //   }
      // }
      _showInterstitialAd();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state)async {
    super.didChangeAppLifecycleState(state);
    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
       showCustomOrAdmob();
        debugPrint('AppLifeCycle home: Resume');
        break;
      case AppLifecycleState.inactive:
        debugPrint('AppLifeCycle: inactive');
        // widget is inactive
        break;
      case AppLifecycleState.paused:
        debugPrint('AppLifeCycle: Pause');
        // widget is paused
        break;
      case AppLifecycleState.detached:
        debugPrint('AppLifeCycle: detached');
        // widget is detached
        break;
    }
  }

  Future<void> init() async {
    bool isDarkMode=false;
    SharedPreferences pref=await SharedPreferences.getInstance();
    if(pref.getBool(is_Switch)!=null){
      isDarkMode=(await pref.getBool(is_Switch))!;
      print('Show Style init: $isDarkMode');
    }
    if(isDarkMode){
      pref.setBool(is_Switch, true);
      ConstantUtils.isDarkMode=true;

    }else{
      pref.setBool(is_Switch, false);
      ConstantUtils.isDarkMode=false;
    }
    String code=myanmarCode;
    if(pref.getString(selected_country)!=null){
      code=pref.getString(selected_country).toString();
    }
    if(code==cambodiaCode){
      ConstantUtils.isUSDolllar=true;
    }else{
      ConstantUtils.isUSDolllar=false;
    }
    _commonController.onInit();
    // _commonController.sendMonthYear(currentMonthYear);
    setState(() {
      ("SelectedMenu Resume $selectedMenu");
      switch(selectedMenu){
        case 'calendar':
          _selectedIndex=0;
          ("SelectedMenu index $_selectedIndex");
          _widgetOptions.elementAt(_selectedIndex);
          break;
        case 'status':
          _selectedIndex=1;
          break;
        case 'accounts':
          _selectedIndex=2;
          _widgetOptions.elementAt(_selectedIndex);
          break;
        case 'exchange':
          _selectedIndex=3;
          break;
        default : _selectedIndex=0;

      }
      selectedDate = DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toString();

    });
  }

  Future hideStatusBar() => SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  @override
  void didUpdateWidget(HomePageScreen oldWidget) {
    init();
    super.didUpdateWidget(oldWidget);
  }
  Future<void> _setCurrentScreen(String screenName) async {
    await analytics.setCurrentScreen(
      screenName: screenName,
      screenClassOverride: screenName,
    );
  //  setMessage('Screen View is success');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantUtils.isDarkMode?dark_nav_color:themeColor,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ConstantUtils.isDarkMode?dark_nav_color:themeColor,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(color: ConstantUtils.isDarkMode?themeColor:light_label_selected_color),
        selectedItemColor: ConstantUtils.isDarkMode?themeColor:Colors.black,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: SizedBox(
              width: getProportionateScreenWidth(20),
              height: getProportionateScreenHeight(20),
              child: SvgPicture.asset(
                "assets/icon/Daily.svg",
                color: 'calendar'==selectedMenu
                    ? ConstantUtils.isDarkMode?themeColor:light_label_selected_color
                    : ConstantUtils.isDarkMode?dark_label_unselected_color:light_label_unselected_color,
              ),
            ),
            label: currentDay
          ),
          BottomNavigationBarItem(
              icon: Container(
                width: getProportionateScreenWidth(20),
                height: getProportionateScreenHeight(20),
                child: SvgPicture.asset(
                  "assets/icon/status.svg",
                  color: 'status' == selectedMenu
                      ? ConstantUtils.isDarkMode?themeColor:light_label_selected_color
                      : ConstantUtils.isDarkMode?dark_label_unselected_color:light_label_unselected_color,
                ),
              ),
            label: "Status".tr,
          ),
          BottomNavigationBarItem(
              icon: Container(
                width: getProportionateScreenWidth(20),
                height: getProportionateScreenHeight(20),
                child: SvgPicture.asset(
                  "assets/icon/account.svg",
                  color: 'accounts' == selectedMenu
                      ? ConstantUtils.isDarkMode?themeColor:light_label_selected_color
                      : ConstantUtils.isDarkMode?dark_label_unselected_color:light_label_unselected_color,
                ),
              ),
              label: "Accounts".tr,

          ),
          BottomNavigationBarItem(
              icon: Container(
                width: getProportionateScreenWidth(20),
                height: getProportionateScreenHeight(20),
                child: SvgPicture.asset(
                  "assets/images/exchange_rate.svg",
                  color: 'exchange' == selectedMenu
                      ? ConstantUtils.isDarkMode?themeColor:light_label_selected_color
                      : ConstantUtils.isDarkMode?dark_label_unselected_color:light_label_unselected_color,
                ),
              ),
            label: "Exchange".tr,

          ),
        ],
        onTap: (index) {
            setState(() {
              _selectedIndex = index;
              switch(_selectedIndex){
                case 0:
                  selectedMenu='calendar';
                  _sendAnalyticsEvent(calendar_screen);
                  break;
                case 1:
                  selectedMenu='status';
                  _sendAnalyticsEvent(status_screen);

                  break;
                case 2:
                  selectedMenu= 'accounts';
                  _sendAnalyticsEvent(account_screen);

                  break;
                case 3:
                  selectedMenu='exchange';
                  _sendAnalyticsEvent(exchange_screen);
                  break;
                default: selectedMenu='calendar';
              }
            });

        },
      ),
      floatingActionButton:Padding(
        padding: EdgeInsets.only(bottom: 40),
        child:  FloatingActionButton(
          backgroundColor: redColor,
          elevation: 5,
          hoverColor: themeColor,
          onPressed: () {
            ConstantUtils.logEvent(transaction_screen_click, ConstantUtils.eventValues).then((onValue){
             setState(() {
               ConstantUtils.logEventResponse=onValue.toString();
               print('LogEventResponse success: ${ConstantUtils.logEventResponse}');
             });
            }).catchError((onError){
              setState(() {
                ConstantUtils.logEventResponse=onError.toString();
                print('LogEventResponse error: ${ConstantUtils.logEventResponse}');

              });
            });

            _commonController.incomeExpenseTransactionList.clear();
            _commonController.transactionAmountController.clear();
            setState(() {
              var transactionId='';
              _sendAnalyticsEvent(transaction_screen_click);
              Get.off(() => TransactionScreen(transactionId:transactionId, dailyId: '',));
            });
          },
          child: Icon(Icons.add,color: Colors.white,),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );


  }
  // Future<void> _sendAnalyticsEvent(String eventName) async {
  //   FirebaseAnalytics analytics = Provider.of<FirebaseAnalytics>(context, listen: false);
  //   await analytics.logEvent(
  //     name: eventName,
  //     parameters: <String, dynamic>{
  //       'string': 'string',
  //       'int': 42,
  //       'long': 12345678910,
  //       'double': 42.0,
  //       'bool': true,
  //     },
  //   );
  // }


}
