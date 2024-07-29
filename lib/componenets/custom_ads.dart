import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/style.dart';

class CustomAds extends StatefulWidget {
  double height;
  String myBanner;
  CustomAds({required this.height,required this.myBanner});


  @override
  _CustomAdsState createState() => _CustomAdsState(height:height,myBanner:myBanner);
}

class _CustomAdsState extends State<CustomAds> {
  late BannerAd myBannerDaily;

  // late NativeAd myNativeAds;
 // CustomAdsController _controller=Get.put(CustomAdsController());
  double height;
  String myBanner;
   int maxFailedLoadAttempts = 3;

  late SharedPreferences pref;
  _CustomAdsState({required this.height,required this.myBanner});
  bool _isBannerAdReady = false;
  late NativeAd _ad;
  bool isNativeAdLoaded = false;

  @override
  void initState(){
  init();
//_controller.onInit();
  //  _controller.init(height);
    super.initState();
  }


  void init()async{
    _myBannerDaily();
    loadNativeAd();

  }

  void _myBannerDaily(){
    myBannerDaily = BannerAd(
      adUnitId: Platform.isAndroid ? bannerAndroid : bannerIOS,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
            print('Failed to load a banner ad success: ${_isBannerAdReady}');
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
    myBannerDaily.load();
  }

  @override
  void dispose(){
     myBannerDaily.dispose();
     _ad.dispose();
     super.dispose();
  }


  // void _launchURL(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
  void loadNativeAd() {
    _ad = NativeAd(
        request: const AdRequest(),
        ///This is a test adUnitId make sure to change it
        adUnitId: Platform.isAndroid?nativeAdvancedAndroid:nativeAdvanceIOS,
        factoryId: 'listTile',
        listener: NativeAdListener(
            onAdLoaded: (ad){
              setState(() {
                isNativeAdLoaded = true;
                print('load the ad success ${isNativeAdLoaded}');

              });
            },
            onAdFailedToLoad: (ad, error){
              ad.dispose();
              print('failed to load the ad ${error.message}, ${error.code}');
            }
        )
    );

    _ad.load();
  }
  @override
  Widget build(BuildContext context) {
    if(height==50){
      return _isBannerAdReady?Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 50.0,
            child: AdWidget(ad: myBannerDaily),
          )):Container();
    }else if(height==250){
      return isNativeAdLoaded?Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          child: AdWidget(ad: _ad,),
          alignment: Alignment.center,
          height: height,
          color: Colors.black12,
        ),
      ):Container();
    }else{
      return Container();
    }
    // return GetBuilder<CustomAdsController>(
    //   init: CustomAdsController(),
    //   builder: (value){
    //     if(height==50 && value.allTodos.length>0){
    //       AdsData? data=value.allTodos[0];
    //       print('GoogleAdmob height50: ${data.options}');
    //       print('GoogleAdmob height50: ${data.admod_Android_ONOFF}');
    //
    //       debugPrint('CustomAllToDo freqCount: ${value.mCount50}');
    //       if(data.options=='custom' &&  Platform.isAndroid){
    //         if((data.Frequency_ONOFF=='' || data.Frequency_ONOFF=='0') || (data.Frequency_ONOFF=='on' && value.mCount50>0 && data.custom_Android_ONOFF=='on')){
    //           debugPrint('CustomAllToDo show: ${value.mCount50}');
    //           return Container(
    //             height: height,
    //             child: WebView(
    //               initialUrl: Platform.isAndroid?data.custom_advertisement_Android:data.custom_advertisement_IOS,
    //               javascriptMode: JavascriptMode.unrestricted,
    //               javascriptChannels: <JavascriptChannel>[
    //                 JavascriptChannel(
    //                     name: 'MessageInvoker',
    //                     onMessageReceived: (s) {
    //                       if (s.message!=null && s.message.isNotEmpty) {
    //                         _launchURL(data.site_url);
    //                       }
    //                     }),
    //               ].toSet(),
    //               gestureNavigationEnabled: true,
    //             ),
    //           );
    //         }else {
    //           return Container();
    //         }
    //
    //       }else  if(data.options=='custom' && Platform.isIOS){
    //         if((data.Frequency_ONOFF=='' || data.Frequency_ONOFF=='0') ||  (data.Frequency_ONOFF=='on' && value.mCount50>0 && data.custom_IOS_ONOFF=='on')){
    //           debugPrint('CustomAllToDo show: ${value.mCount50}');
    //           return Container(
    //             height: height,
    //             child: WebView(
    //               initialUrl: Platform.isAndroid?data.custom_advertisement_Android:data.custom_advertisement_IOS,
    //               javascriptMode: JavascriptMode.unrestricted,
    //               javascriptChannels: <JavascriptChannel>[
    //                 JavascriptChannel(
    //                     name: 'MessageInvoker',
    //                     onMessageReceived: (s) {
    //                       if (s.message!=null && s.message.isNotEmpty) {
    //                         _launchURL(data.site_url);
    //                       }
    //                     }),
    //               ].toSet(),
    //               gestureNavigationEnabled: true,
    //             ),
    //           );
    //         }else {
    //           return Container();
    //         }
    //
    //       }else {
    //         print('GoogleAdmob height50 live: ${data.options}');
    //         //For Google admob
    //         if(data.options=='admod' && data.admod_Android_ONOFF=='on' && Platform.isAndroid){
    //           return _isBannerAdReady?Align(
    //               alignment: Alignment.bottomCenter,
    //               child: Container(
    //                 height: 50.0,
    //                 child: AdWidget(ad: myBannerDaily),
    //               )):Container();
    //         }else if(
    //         data.options=='admod' && data.admod_IOS_ONOFF=='on' && Platform.isIOS){
    //           return _isBannerAdReady?Align(
    //               alignment: Alignment.bottomCenter,
    //               child: Container(
    //                 height: 50.0,
    //                 child: AdWidget(ad: myBannerDaily),
    //               )):Container();
    //         }else{
    //           return Container();
    //         }
    //       }
    //     }else if(height==250 && value.allTodos250.length>0){
    //       AdsData? data=value.allTodos250[0];
    //       debugPrint('CustomAllToDo freqCount250: ${value.mCount250}');
    //       if(data.options=='custom'  && Platform.isAndroid){
    //         if((data.Frequency_ONOFF=='' || data.Frequency_ONOFF=='0')|| (data.Frequency_ONOFF=='on' && value.mCount250>0)){
    //           debugPrint('CustomAllToDo show: ${value.mCount250}');
    //           return Container(
    //             height: height,
    //             child: WebView(
    //               initialUrl: Platform.isAndroid?data.custom_advertisement_Android:data.custom_advertisement_IOS,
    //               javascriptMode: JavascriptMode.unrestricted,
    //               javascriptChannels: <JavascriptChannel>[
    //                 JavascriptChannel(
    //                     name: 'MessageInvoker',
    //                     onMessageReceived: (s) {
    //                       if (s.message!=null && s.message.isNotEmpty) {
    //                         _launchURL(data.site_url);
    //                       }
    //                     }),
    //               ].toSet(),
    //               gestureNavigationEnabled: true,
    //             ),
    //           );
    //         }else {
    //           return Container();
    //         }
    //
    //       }else  if(data.options=='custom' && Platform.isIOS){
    //         if((data.Frequency_ONOFF=='' || data.Frequency_ONOFF=='0') || (data.Frequency_ONOFF=='on' && value.mCount250>0)){
    //           debugPrint('CustomAllToDo show: ${value.mCount250}');
    //           return Container(
    //             height: height,
    //             child: WebView(
    //               initialUrl: Platform.isAndroid?data.custom_advertisement_Android:data.custom_advertisement_IOS,
    //               javascriptMode: JavascriptMode.unrestricted,
    //               javascriptChannels: <JavascriptChannel>[
    //                 JavascriptChannel(
    //                     name: 'MessageInvoker',
    //                     onMessageReceived: (s) {
    //                       if (s.message!=null && s.message.isNotEmpty) {
    //                         _launchURL(data.site_url);
    //                       }
    //                     }),
    //               ].toSet(),
    //               gestureNavigationEnabled: true,
    //             ),
    //           );
    //         }else {
    //           return Container();
    //         }
    //
    //       }else{
    //         if(data.options=='admod' && data.admod_Android_ONOFF=='on' && Platform.isAndroid){
    //           return isNativeAdLoaded?Align(
    //             alignment: Alignment.bottomCenter,
    //             child: Container(
    //               child: AdWidget(ad: _ad,),
    //               alignment: Alignment.center,
    //               height: height,
    //               color: Colors.black12,
    //             ),
    //           ):Container();
    //         }else if(
    //         data.options=='admod' && data.admod_IOS_ONOFF=='on' && Platform.isIOS){
    //           return isNativeAdLoaded?Align(
    //             alignment: Alignment.bottomCenter,
    //             child: Container(
    //               child: AdWidget(ad: _ad,),
    //               alignment: Alignment.center,
    //               height: height,
    //               color: Colors.black12,
    //             ),
    //           ):Container();
    //         }else{
    //           return Container();
    //         }
    //
    //         // return Align(
    //         //   alignment: Alignment.bottomCenter,
    //         //   child: Container(
    //         //     child: AdWidget(ad: _ad,),
    //         //     alignment: Alignment.center,
    //         //     height: height,
    //         //     color: Colors.black12,
    //         //   ),
    //         // );
    //       }
    //     }else if(height==480 && value.allTodos480.length>0){
    //       AdsData? data=value.allTodos480[0];
    //       debugPrint('CustomAllToDo freqCount: ${value.mCount480}');
    //       if(data.options=='custom' && data.custom_Android_ONOFF=='on' && Platform.isAndroid){
    //         if((data.Frequency_ONOFF=='' || data.Frequency_ONOFF=='0') || (data.Frequency_ONOFF=='on' && value.mCount480>0)){
    //           debugPrint('CustomAllToDo show: ${value.mCount480}');
    //           return Container(
    //             height: height,
    //             child: WebView(
    //               initialUrl: Platform.isAndroid?data.custom_advertisement_Android:data.custom_advertisement_IOS,
    //               javascriptMode: JavascriptMode.unrestricted,
    //               javascriptChannels: <JavascriptChannel>[
    //                 JavascriptChannel(
    //                     name: 'MessageInvoker',
    //                     onMessageReceived: (s) {
    //                       if (s.message!=null && s.message.isNotEmpty) {
    //                         _launchURL(data.site_url);
    //                       }
    //                     }),
    //               ].toSet(),
    //               gestureNavigationEnabled: true,
    //             ),
    //           );
    //         }else {
    //           return Container();
    //         }
    //
    //       }else  if(data.options=='custom' && data.custom_IOS_ONOFF=='on' && Platform.isIOS){
    //         if((data.Frequency_ONOFF=='' || data.Frequency_ONOFF=='0') ||  (data.Frequency_ONOFF=='on' && value.mCount480>0)){
    //           debugPrint('CustomAllToDo show: ${value.mCount480}');
    //           return Container(
    //             height: height,
    //             child: WebView(
    //               initialUrl: Platform.isAndroid?data.custom_advertisement_Android:data.custom_advertisement_IOS,
    //               javascriptMode: JavascriptMode.unrestricted,
    //               javascriptChannels: <JavascriptChannel>[
    //                 JavascriptChannel(
    //                     name: 'MessageInvoker',
    //                     onMessageReceived: (s) {
    //                       if (s.message!=null && s.message.isNotEmpty) {
    //                         _launchURL(data.site_url);
    //                       }
    //                     }),
    //               ].toSet(),
    //               gestureNavigationEnabled: true,
    //             ),
    //           );
    //         }else {
    //           return Container();
    //         }
    //
    //       }else {
    //         //For Google admob
    //         debugPrint('Admob android: ${data.options}');
    //         debugPrint('Admob android on: ${data.admod_Android_ONOFF}');
    //         debugPrint('Admob android ios: ${data.admod_IOS_ONOFF}');
    //         if(data.options=='admod' && data.admod_Android_ONOFF=='on' && Platform.isAndroid){
    //           return _isBannerAdReady?Align(
    //               alignment: Alignment.bottomCenter,
    //               child: Container(
    //                 height: 50.0,
    //                 width: 480.0,
    //                 child: AdWidget(ad: myBannerDaily),
    //               )):Container();
    //         }else if(
    //         data.options=='admod' && data.admod_IOS_ONOFF=='on' && Platform.isIOS){
    //           return _isBannerAdReady?Align(
    //               alignment: Alignment.bottomCenter,
    //               child: Container(
    //                 height: 50.0,
    //                 width: 480.0,
    //                 child: AdWidget(ad: myBannerDaily),
    //               )):Container();
    //         }else{
    //           return Container();
    //         }
    //
    //       }
    //     }else{
    //       return Container();
    //     }
    //   },
    // );
  }
}