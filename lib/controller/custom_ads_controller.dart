import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../athabyar_api/request_response_api.dart';
import '../athabyar_api/request_response_model.dart';

class CustomAdsController extends GetxController {
  bool isInternet = false;
  List<AdsData> allTodos = [];
  List<AdsData> allTodos250 = [];
  List<AdsData> allTodos480 = [];
  int mCount480 = 0;
  int mCount50 = 0;
  int mCount250 = 0;

  bool isFirst = false;
  bool isFirst250 = false;


  @override
  void onInit() {
    super.onInit();
  }

  void init(double adsType) async {
    debugPrint('CustomAds height: $adsType');
    if (adsType == 50) {
      getAllTodosAds50();
    }
    if (adsType == 250) {
      getAllTodosAds250();
    }
    if (adsType == 480) {
      getAllTodosAds480();
    }
  }

  Future getAllTodosAds50() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String currentDate50 = '';
    currentDate50 = ConstantUtils.dayMonthYearFormat.format(DateTime.now());
    String isCurrentDateCustomAds50 = '';
    if (pref.getString(CurrentDate50) != null) {
      isCurrentDateCustomAds50 = pref.getString(CurrentDate50).toString();
    }
    try {
      AdsData? data = await RequestResponseApi.getAds50Response();
      if(data!=null){
        print('DataOption: ${data.options}');
        if(data.options=='admod'){
          allTodos.clear();
          allTodos.add(data);
        }else{
          print('DataOption custom: ${isCurrentDateCustomAds50}');
          print('DataOption custom: ${currentDate50}');

          if (isCurrentDateCustomAds50 != currentDate50) {
            print('DataOption custom: ${isCurrentDateCustomAds50}');

            if (data != null) {
              allTodos.clear();
              allTodos.add(data);
              pref.setString(CurrentDate50, currentDate50);
              mCount50 = int.parse(data.frequency);
            }
          }else{
            if(allTodos!=null && allTodos.length>0){
              mCount50--;
            }
          }
          debugPrint('Frequency res50: ${mCount50}');
        }
      }


    } catch (error) {

    }
    update();
  }

  Future getAllTodosAds250() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String currentDate250 = '';
    currentDate250 = ConstantUtils.dayMonthYearFormat.format(DateTime.now());
    String isCurrentDateCustomAds250 = '';
    if (pref.getString(CurrentDate250) != null) {
      isCurrentDateCustomAds250 = pref.getString(CurrentDate250).toString();
    }
    try {
      AdsData? data = await RequestResponseApi.getAds250Response();
      if(data!=null){
        if(data.options=='admod'){
          allTodos250.clear();
          allTodos250.add(data);
        }else{
          if (isCurrentDateCustomAds250 != currentDate250) {
            AdsData? data = await RequestResponseApi.getAds250Response();
            if (data != null) {
              allTodos250.clear();
              allTodos250.add(data);
              pref.setString(CurrentDate250, currentDate250);
              mCount250 = int.parse(data.frequency);
            }
          }else{
            if(allTodos250!=null && allTodos250.length>0){
              mCount250--;
            }

          }
        }
      }


      debugPrint('Frequency res250: ${mCount250}');
    } catch (error) {

    }
    update();
  }

  Future getAllTodosAds480() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String currentDate480 = '';
    currentDate480 = ConstantUtils.dayMonthYearFormat.format(DateTime.now());
    String isCurrentDateCustomAds480 = '';
    if (pref.getString(CurrentDate480) != null) {
      isCurrentDateCustomAds480 = pref.getString(CurrentDate480).toString();
    }
    try {
      AdsData? data = await RequestResponseApi.getAds480Response();
      if(data!=null){
        if(data.options=='admod'){
          allTodos480.clear();
          allTodos480.add(data);
        }else{
          if (isCurrentDateCustomAds480 != currentDate480) {
            AdsData? data = await RequestResponseApi.getAds480Response();
            if (data != null) {
              allTodos480.clear();
              allTodos480.add(data);
              pref.setString(CurrentDate480, currentDate480);
              mCount480 = int.parse(data.frequency);
            }
          }
          if (mCount480 > 0 && allTodos480 != null && allTodos480.length > 0) {
            if (mCount480 != allTodos480[0].frequency) {
              mCount480--;
              debugPrint('Frequency freqsss2: ${mCount480}');
            }
          }
        }
      }

      debugPrint('Frequency res: ${mCount480}');
    } catch (error) {

    }
    update();
  }
}
