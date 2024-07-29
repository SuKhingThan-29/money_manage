import 'dart:math';
import 'package:AthaPyar/componenets/RouteAwareAnalytics.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/models/theme_color.dart';
import 'package:AthaPyar/screen/home_screen/home.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConstantUtils {
  static bool isDarkMode = false;

  static bool isUSDolllar=false;

  static DateTime dateTime = DateTime.now();

  static DateFormat formatter = DateFormat('dd/MM/yyyy (EEE)');

  static DateFormat yearFormatter = DateFormat('yyyy');

  static DateFormat weekFormatter = DateFormat('EEEE');

  static DateFormat monthFormatter = DateFormat('MMM yyyy');

  static DateFormat dayMonthFormatter = DateFormat('dd/MM');

  static DateFormat monthNumber=DateFormat('MM');

  static DateFormat dayMonthYearFormat = DateFormat('dd-MM-yyyy');

  static DateTime year = DateTime(DateTime
      .now()
      .year);

  static DateTime month = DateTime(DateTime
      .now()
      .month);

  static DateTime day = DateTime(DateTime
      .now()
      .day);
  Color light_background_color=HexColor("#F2F2F2");

  static late AppsflyerSdk _appsflyerSdk;
  static late Map _deepLinkData;
  static late Map _gcd;
  //static final String eventName = transaction_screen_click;
  static String logEventResponse = "No event have been sent";


  static final Map eventValues = {
    "af_content_id": "id123",
    "af_currency": "USD",
    "af_revenue": "0.1"
  };
  static Future<bool?> logEvent(String eventName, Map eventValues)async {
    final AppsFlyerOptions options = AppsFlyerOptions(
        afDevKey: 'WCEsoDzwXDTy9kq9fYugGH',
        appId: 'id1615505050',
        showDebug: true,
        timeToWaitForATTUserAuthorization: 15
    );
    _appsflyerSdk = AppsflyerSdk(options);
    _appsflyerSdk.onAppOpenAttribution((res) {
      print("onAppOpenAttribution res: " + res.toString());
      // setState(() {
      //   _deepLinkData = res;
      // });
    });
    _appsflyerSdk.onInstallConversionData((res) {
      print("onInstallConversionData res: " + res.toString());
      // setState(() {
      //   _gcd = res;
      // });
    });
    _appsflyerSdk.onDeepLinking((DeepLinkResult dp){
      switch (dp.status) {
        case Status.FOUND:
          print(dp.deepLink?.toString());
          print("deep link value: ${dp.deepLink?.deepLinkValue}");
          break;
        case Status.NOT_FOUND:
          print("deep link not found");
          break;
        case Status.ERROR:
          print("deep link error: ${dp.error}");
          break;
        case Status.PARSE_ERROR:
          print("deep link status parsing error");
          break;
      }
      print("onDeepLinking res: " + dp.toString());
      // setState(() {
      //   _deepLinkData = dp.toJson();
      // });
    });
    _appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: false,
        registerOnDeepLinkingCallback: true);
    return _appsflyerSdk.logEvent(eventName, eventValues);
  }
  static ThemeColor darkMode = ThemeColor(
    gradient: [
      const Color(0xFF8983F7),
      const Color(0xFFA3DAFB),
    ],
    backgroundColor: HexColor("#303539"),
    textColor: HexColor("#FFFFFF"),
    cardTextColor: const Color(0xFF26242e),
    imageColor: const Color(0xFFFFFFFF),
    imageBackgroundColor: const Color(0xFFe7e7e8),
    shadow: const <BoxShadow>[
      BoxShadow(
        color: const Color(0x66000000),
        spreadRadius: 5,
        blurRadius: 10,
        offset: Offset(0, 5),
      ),
    ],
  );
  static ThemeColor lightMode = ThemeColor(
    gradient: [
      const Color(0xDDFF0080),
      const Color(0xDDFF8C00),
    ],
    backgroundColor:  HexColor("#F2F2F2"),
    textColor: HexColor("#7B7B7B"),
    imageColor: const Color(0xFf34323d),
    cardTextColor: const Color(0xFF26242e),
    imageBackgroundColor: const Color(0xFF222029),
    shadow: const [
      BoxShadow(
        color: const Color(0xFFd8d7da),
        spreadRadius: 5,
        blurRadius: 10,
        offset: Offset(0, 5),
      ),
    ],
  );

  static Future<void> showToast(String message)async {
    Fluttertoast.showToast(msg: message,toastLength:  Toast.LENGTH_SHORT,gravity: ToastGravity.CENTER,timeInSecForIosWeb: 1,backgroundColor: Colors.grey,textColor: Colors.white);

  }
  static Future<void> showToastLong(String message)async {
    Fluttertoast.showToast(msg: message,toastLength:  Toast.LENGTH_LONG,gravity: ToastGravity.BOTTOM,timeInSecForIosWeb: 1,backgroundColor: Colors.grey,textColor: Colors.white);

  }
  static Future<void> setCurrentScreen(String eventName) async {

  }
  static AnalyticsEventItem itemCreator() {
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
  static Future sendAnalyticsEvent(
     String eventName) async {
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
  }
  Future<bool> isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network, make sure there is actually a net connection.
      // if (await DataConnectionChecker().hasConnection) {
      //   // Mobile data detected & internet connection confirmed.
      //   return true;
      // } else {
      //   // Mobile data detected but no internet connection found.
      //   return false;
      // }
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a WIFI network, make sure there is actually a net connection.
      // if (await DataConnectionChecker().hasConnection) {
      //   // Wifi detected & internet connection confirmed.
      //   return true;
      // } else {
      //   // Wifi detected but no internet connection found.
      //   return false;
      // }
      return true;
    } else {
      // Neither mobile data or WIFI detected, not internet connection found.
      return false;
    }
  }

  static Color randomColor() {
    return Color(Random().nextInt(0xffffffff));
  }

  static Color randomOpaqueColor() {
    return Color(Random().nextInt(0xffffffff)).withAlpha(0xff);
  }
  static bool isErrorText(String phoneNo,String code){
    if(code==myanmarCode && phoneNo.isEmpty){
      return false;
    }
    // else if(code ==cambodiaCode && phoneNo.isNotEmpty && !phoneNo.startsWith(('8'))){
    //   return false;
    // }
    else if(phoneNo.isEmpty){
      return false;
    }
    return true;

  }

  // static bool isPhoneNoSelect(String phoneNo,String code){
  //   if(code==myanmarCode && phoneNo.isEmpty){
  //     return false;
  //   }
  //   // else if(code ==cambodiaCode && phoneNo.isNotEmpty && !phoneNo.startsWith(('8'))){
  //   //   return false;
  //   // }
  //   return true;
  //
  // }
  static Future<Position> getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
  static Future<String> GetAddressFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    //Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.isoCountryCode}';
    // countryCode='${place.isoCountryCode}';
    // setState(()  {
    // });
    return place.isoCountryCode.toString();

  }
  static showLoginAlertDialog(BuildContext context,String message) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: ()async {
        Navigator.of(context).pop();
        Get.off(()=> HomeScreen(selectedMenu: 'calendar',showInterstitial:true));
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('AThaByar'),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  static showAlertDialog(BuildContext context,String message) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: ()async {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('AThaByar'),
      content: Text(message.tr),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}

