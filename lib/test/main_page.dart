import 'dart:async';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/material.dart';


import 'home_container.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  late AppsflyerSdk _appsflyerSdk;
  late Map _deepLinkData;
  late Map _gcd;
  // called on every foreground
  @override
  void initState() {
    super.initState();
    final AppsFlyerOptions options = AppsFlyerOptions(
    afDevKey: 'WCEsoDzwXDTy9kq9fYugGH',
    appId: 'id1615505050',
    showDebug: true,
    timeToWaitForATTUserAuthorization: 15
    );
    _appsflyerSdk = AppsflyerSdk(options);
    _appsflyerSdk.onAppOpenAttribution((res) {
      print("onAppOpenAttribution res: " + res.toString());
      setState(() {
        _deepLinkData = res;
      });
    });
    _appsflyerSdk.onInstallConversionData((res) {
      print("onInstallConversionData res: " + res.toString());
      setState(() {
        _gcd = res;
      });
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
      setState(() {
        _deepLinkData = dp.toJson();
      });
    });

    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            children: <Widget>[
              Text('AppsFlyer SDK example app'),
              FutureBuilder<String?>(
                  future: _appsflyerSdk.getSDKVersion(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return Text(snapshot.hasData ? snapshot.data : "");
                  }), 
            ],
          ),
        ),
        body: FutureBuilder<dynamic>(
            future: _appsflyerSdk.initSdk(
                registerConversionDataCallback: true,
                registerOnAppOpenAttributionCallback: true,
                registerOnDeepLinkingCallback: true),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.hasData) {
                  return HomeContainer(
                    onData: _gcd, 
                    deepLinkData: _deepLinkData,
                    logEvent: logEvent,
                  );
                } else {
                  return Center(child: Text("Error initializing sdk"));
                }
              }
            }));
  }

  Future<bool?> logEvent(String eventName, Map eventValues)async {
    return _appsflyerSdk.logEvent(eventName, eventValues);
  }

}
