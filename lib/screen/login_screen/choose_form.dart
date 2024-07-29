
import 'package:AthaPyar/componenets/tern_and_condition_dialog.dart';
import 'package:AthaPyar/controller/login_controller.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/screen/login_screen/login.dart';
import 'package:AthaPyar/screen/login_screen/signup.dart';
import 'package:AthaPyar/services/localization_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class ChooseFormScreen extends StatefulWidget {
  const ChooseFormScreen({Key? key}) : super(key: key);

  @override
  _ChooseFormScreen createState() => _ChooseFormScreen();
}

class _ChooseFormScreen extends State<ChooseFormScreen> with WidgetsBindingObserver{
  LoginController loginController = Get.put(LoginController());
  bool isInvalid=false;
  late bool isSwitched = false;
  late String _selectedLang;
  String location ='Null, Press Button';
  String countryCode = '';

  @override
  void initState() {
    super.initState();

    init();
    debugPrint('AppLifeCycle init:$countryCode');

  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state)async {
    super.didChangeAppLifecycleState(state);
    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
        init();
        debugPrint('AppLifeCycle Resume: $countryCode');
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
  void init()async{
   // hideStatusBar();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      Position position = await ConstantUtils.getGeoLocationPosition();
      location ='Lat: ${position.latitude} , Long: ${position.longitude}';
      countryCode=await ConstantUtils.GetAddressFromLatLong(position);
    } catch (e) {
      print(e);
    }
    debugPrint('AppLifeCycle countryCode:$countryCode');
    preferences.setString(mCountryCode, countryCode);


    late String _selectedLang;
    _selectedLang = LocalizationService.langs.first;
    LocalizationService().changeLocale(_selectedLang);
    try {
      if(preferences.getString(Lang)!=null){
        _selectedLang=await preferences.getString(Lang)!;
      }
      LocalizationService().changeLocale(_selectedLang);
      preferences.setString(Lang, _selectedLang);
      if(_selectedLang=='Myanmar'){
        isSwitched=true;
      }else{
        isSwitched=false;
      }

    } catch (e) {
      print(e);
    }
    loginController.isRegister=false;
    loginController.phoneNoController.clear();
    loginController.passwordController.clear();
    loginController.confirmPasswordController.clear();

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
  Future hideStatusBar() => SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: SingleChildScrollView(
            child:Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/chooseform.png"),
                      fit: BoxFit.cover),
                color:themeColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Spacer(),
                  Spacer(),
                  Container(
                    width: 100,
                    height: 100,
                    child: Image.asset('assets/icon/splash_icon.png'),
                  ),
                  Center(
                    child: Text(
                      'AThaByar'.tr,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(left: 30,right: 30,bottom: 10),
                    child: FractionallySizedBox(
                      widthFactor: 1.0,
                      child: RaisedButton(
                          onPressed: () async {
                            setState(() {
                              _sendAnalyticsEvent(signup_btn);
                            });
                            Get.off(()=> SignupScreen());

                          },
                          color: themeColor,
                          textColor: Colors.white,
                          shape: StadiumBorder(
                              side: BorderSide(color: themeColor, width: 1)),
                          child: Text('Sign Up'.tr)),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 30,right: 30,bottom: 10),
                    child: FractionallySizedBox(
                      widthFactor: 1.0,
                      child: RaisedButton(
                          onPressed: () async {
                            setState(() {
                              _sendAnalyticsEvent(login_btn);
                              Get.off(()=>LoginScreen());

                            });

                          },
                          color: Colors.white,
                          textColor: Colors.black,
                          shape: StadiumBorder(
                              side: BorderSide(color: themeColor, width: 1)),
                          child: Text('Login'.tr)),
                    ),
                  ),
                  countryCode=='MM'?Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'English'.tr,
                        style: TextStyle(
                            color: Colors.grey),
                      ),
                      Switch(
                        value: isSwitched,
                        onChanged: (value) async{
                          setState(() {
                            isSwitched = value;


                          });
                          SharedPreferences preferences = await SharedPreferences.getInstance();

                          if (isSwitched) {
                            _selectedLang = LocalizationService.langs.last;
                            LocalizationService().changeLocale(_selectedLang);
                            preferences.setString(Lang, _selectedLang);
                            _sendAnalyticsEvent(language_myanmar_event);
                          } else {
                            _selectedLang = LocalizationService.langs.first;
                            LocalizationService().changeLocale(_selectedLang);
                            preferences.setString(Lang, _selectedLang);
                            _sendAnalyticsEvent(language_change_event);

                          }
                          print('select lang: ${preferences.getString(Lang)}');
                          _selectedLang=(preferences.getString(Lang))!;
                        },
                        activeTrackColor:
                        themeColor,
                        activeColor: Colors.white,
                      ),
                      Text(
                        'Myanmar'.tr,
                        style: TextStyle(
                            color: Colors.grey),
                      )
                    ],
                  ):Container(),
                  SizedBox(height: 20,),

                  GestureDetector(
                    onTap: (){
                      setState(() {
                        showDialog(
                          barrierColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(

                            );
                          },
                        );
                      });
                    },
                    child: Center(
                      child: Text(
                        'Terms and conditions'.tr,
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blueGrey),
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Center(
                    child: Text(
                      'Powered by DKMads 360 Digital Advertising'.tr,
                      style: TextStyle(
                          fontSize: 10,

                          color: Colors.blueGrey),
                    ),
                  ),
                  Spacer()
                ],
              ),
            )
          )
      ),
    );
  }
}
