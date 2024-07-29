
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/screen/home_screen/home.dart';
import 'package:AthaPyar/screen/login_screen/choose_form.dart';
import 'package:AthaPyar/services/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../controller/main_controller.dart';

class SplashScreenPage extends StatefulWidget{
  bool isLogin;
  SplashScreenPage({required this.isLogin});
  _SplashScreenState createState() => _SplashScreenState(isLogin:isLogin);


}
class _SplashScreenState extends State<SplashScreenPage>{
  bool isLogin;
  _SplashScreenState({required this.isLogin});
  @override
  void initState(){
    super.initState();
    init();
  }
  @override
  void dispose(){
    super.dispose();
  }



  void init()async{
    late String _selectedLang;
    _selectedLang = LocalizationService.langs.first;
    LocalizationService().changeLocale(_selectedLang);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      if(preferences.getString(Lang)!=null){
        _selectedLang=await preferences.getString(Lang)!;
      }
      LocalizationService().changeLocale(_selectedLang);
      preferences.setString(Lang, _selectedLang);
    } catch (e) {
      print(e);
    }
    print('Splash isLogin: $isLogin');
    ConstantUtils.showToast('Splash isLogin: $isLogin');
    if(isLogin){
      Get.off(()=> HomeScreen(selectedMenu: 'calendar', showInterstitial: false));
    }else{
      Get.off(()=> ChooseFormScreen());
    }

  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: themeColor,
      body: Scaffold(
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
                  child: Image.asset('assets/icon/splash_icon.png'),
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