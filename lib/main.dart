import 'package:AthaPyar/athabyar_api/download_upload_all.dart';
import 'package:AthaPyar/athabyar_api/request_response_api.dart';
import 'package:AthaPyar/componenets/notification_badge.dart';
import 'package:AthaPyar/controller/login_controller.dart';
import 'package:AthaPyar/controller/main_controller.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/screen/home_screen/home.dart';
import 'package:AthaPyar/screen/login_screen/choose_form.dart';
import 'package:AthaPyar/services/localization_service.dart';
import 'package:AthaPyar/test/main_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/push_notification_model.dart';
Future main() async {
  List<String> testDeviceIds = ['289C....E6'];
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await Firebase.initializeApp();
  MobileAds.instance.initialize();
  // thing to add
  // RequestConfiguration configuration =
  // RequestConfiguration(testDeviceIds: testDeviceIds);
  // MobileAds.instance.updateRequestConfiguration(configuration);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  MyAppState createState() => MyAppState();
}
class MyAppState extends State<MyApp>{
  LoginController loginController=Get.put(LoginController());
  MainController mainController=Get.put(MainController());
  late Image image1;
  late String version;
  late final FirebaseMessaging _firebaseMessaging;
  late int _totalNotificationCounter;
  PushNotification? _notificationInfo;
  String deviceId='deviceId';
  bool isLogin=false;
  @override
  void initState(){
    registerNotification();
    _totalNotificationCounter=0;
    loginController.onInit();
    init();
    image1=Image.asset('assets/icon/splash_icon.png');
    super.initState();

  }
  void registerNotification()async{
    await Firebase.initializeApp();
    MobileAds.instance.initialize();
    _firebaseMessaging=FirebaseMessaging.instance;
    //three type of state in notification
    //not determine (null),granted(true),and decline(false)
    NotificationSettings settings=await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,

    );
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print("Permission User granted the permission");
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        PushNotification notification=PushNotification(title: message.notification!.title, body: message.notification!.body, dataTitle: message.data['title'], dataBody: message.data['body'],);
        setState(() {
          _totalNotificationCounter++;
          _notificationInfo=notification;
          if(_notificationInfo!=null){
            print('Permission Notification Title: ${_notificationInfo!.title}');
          }
        });
          showSimpleNotification(Text(_notificationInfo!.title!),leading: NotificationBadget(totalNotification: _totalNotificationCounter),
              subtitle: Text(_notificationInfo!.body!),
              background: Colors.cyan,
              duration: Duration(seconds: 2));
      });
    }else{
      print("Permission Declined by user");
    }
  }
  @override
  void didChangeDependencies(){
    precacheImage(image1.image, context);
    super.didChangeDependencies();
  }
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);
  void init()async{
    String _deviceId='';
    String profileid='';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      _deviceId = (await PlatformDeviceId.getDeviceId)!;
    } on PlatformException {
      _deviceId = 'Failed to get deviceId.';
    }
    try {
      if(preferences.getString(mProfileId)!=null && preferences.getString(mProfileId).toString().isNotEmpty){
        profileid=preferences.getString(mProfileId)!;
        // ConstantUtils utils=ConstantUtils();
        // bool isInternet=await utils.isInternet();
        // if(isInternet){
        //   ConstantUtils.showToastLong('Please wait a few minute for calling data...');
        //   var profile=await RequestResponseApi.getProfileResponse();
        //   print('IsLoginData profile: ${profile}');
        //   if(profile!=null){
        //     if(preferences.getString(mDeviceId)!=null && preferences.getString(mDeviceId).toString().isNotEmpty){
        //       deviceId=await preferences.getString(mDeviceId).toString();
        //       setState(() {
        //         if(deviceId==_deviceId){
        //           isLogin=true;
        //           Get.off(() =>HomeScreen(selectedMenu: 'calendar', showInterstitial: false));
        //
        //         }else{
        //           isLogin=false;
        //           Get.off(()=> ChooseFormScreen());
        //
        //         }
        //       });
        //     }else{
        //       isLogin=false;
        //       Get.off(()=> ChooseFormScreen());
        //     }
        //   }else{
        //     setState(() {
        //       isLogin=false;
        //       Get.off(()=> ChooseFormScreen());
        //     });
        //   }
        // }else{
        //   setState(() {
        //     isLogin=false;
        //     Get.off(()=> ChooseFormScreen());
        //   });
        // }
        isLogin=true;
        Get.off(() =>HomeScreen(selectedMenu: 'calendar', showInterstitial: false));
      }else{
        setState(() {
          isLogin=false;
          Get.off(()=> ChooseFormScreen());
        });
      }
    } catch (e) {
     setState(() {
       Get.off(()=> ChooseFormScreen());
     });
    }
    try {
      late String _selectedLang;
      _selectedLang = LocalizationService.langs.first;
      if(preferences.getString(Lang)!=null){
        _selectedLang=await preferences.getString(Lang)!;
      }
      print('Login _selectedLang: $_selectedLang');
      LocalizationService().changeLocale(_selectedLang);
      preferences.setString(Lang, _selectedLang);
      await DownloadUploadAll.downloadTermAndCondition();
    } catch (e) {
      print(e);
    }
    try {
      await DownloadUploadAll.downloadGold();
    } catch (e) {
      print(e);
    }
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    precacheImage(image1.image, context);
    return GetMaterialApp(
          theme: ThemeData(primarySwatch: Colors.lightBlue),
          navigatorObservers: <NavigatorObserver>[observer],
          locale:LocalizationService.locale,
          fallbackLocale: LocalizationService.fallbackLocale,
          translations: LocalizationService(),
          debugShowCheckedModeBanner: false,
         home:Scaffold(
           backgroundColor: themeColor,
           body: SafeArea(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 // crossAxisAlignment: CrossAxisAlignment.stretch,
                 children: [
                   Spacer(),
                   Container(
                     width: 150,
                     height: 150,
                     child: image1,
                   ),
                   Spacer(),
                   Center(
                     child: Text(
                       'AThaByar',style: TextStyle(color: Colors.white,fontSize: 18),
                     ),
                   ),
                   SizedBox(height:100)
                 ],
               )
           ),
         )
    );
  }
}
