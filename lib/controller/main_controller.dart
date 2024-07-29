import 'package:AthaPyar/athabyar_api/request_response_api.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/screen/home_screen/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../athabyar_api/download_upload_all.dart';
import '../helper/style.dart';
import '../services/localization_service.dart';

class MainController extends GetxController{
  bool isLogin=false;
  late String deviceId;
  late bool profileId=false;
  @override
  void onInit(){
    super.onInit();
    init();
  }

  void init()async{
    String _deviceId='';
    String? profileid;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
    //  preferences.setString(mProfileId, '25d85e29a1afb64c768c11d159c545f3');
      if(preferences.getString(mProfileId)!=null){
        profileid=preferences.getString(mProfileId)!;
        var profile=await RequestResponseApi.getProfileResponse();
        if(profile!=null){
          if(preferences.getString(mDeviceId)!=null){
            deviceId=await preferences.getString(mDeviceId).toString();
          }
          if(deviceId==_deviceId){
            isLogin=true;
            print('IsLogin: $isLogin');
            Get.off(() =>HomeScreen(selectedMenu: 'calendar', showInterstitial: false));
            update();
          }else{
            isLogin=false;
          }
        }else{
          isLogin=false;
        }

      }else{
        isLogin=false;

      }
      late String _selectedLang;
      _selectedLang = LocalizationService.langs.first;
      LocalizationService().changeLocale(_selectedLang);
      try {
        _deviceId = (await PlatformDeviceId.getDeviceId)!;
      } on PlatformException {
        _deviceId = 'Failed to get deviceId.';
      }
      if(preferences.getString(Lang)!=null){
        _selectedLang=await preferences.getString(Lang)!;
      }
      print('Login _selectedLang: $_selectedLang');
      LocalizationService().changeLocale(_selectedLang);
      preferences.setString(Lang, _selectedLang);
    } catch (e) {
      print(e);
    }
    print('Login data: $isLogin');
    update();
  }
}