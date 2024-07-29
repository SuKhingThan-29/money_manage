import 'package:AthaPyar/athabyar_api/request_response_api.dart';
import 'package:AthaPyar/athabyar_api/request_response_model.dart';
import 'package:AthaPyar/datatbase/model/tbl_exchange.dart';
import 'package:AthaPyar/datatbase/model/tbl_gold.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/services/exchange_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExchangeController extends GetxController {
  List<TBLExchange> exchangeList = [];
  List<TBLGold> goldList = [];
  List<TBLGold> yesterGoldList = [];
  TBLExchange? selectedValue;
  var selectedDate = '';
  var yesterdayDate ='';
  int selectedDay = (DateTime.now().day);
  var adsLoading = true.obs;
  List<AdsData> allTodos = [];
  List<AdsData> allTodos250 = [];
  bool isInternet = false;
  int mCount50 = 0;
  int mCount250 = 0;

  @override
  void onInit() {
    selectedDate = ConstantUtils.dayMonthYearFormat.format(DateTime.now());
    selectExchangeAndGoldData(DateTime.now());
    super.onInit();
  }

  void selectExchangeAndGoldData(DateTime _selectedDate) async {
    selectedDate = ConstantUtils.dayMonthYearFormat.format(_selectedDate);
    print('Current Day: $selectedDate');
    List<TBLExchange> _exchangeList = [];
    _exchangeList = await ExchangeService.selectExchangeList(selectedDate);
    List<TBLGold> _goldList = [];
    List<TBLGold> _yesterdayGoldList = [];
    _goldList = await ExchangeService.selectGoldList(selectedDate);
    var _yesterday=DateTime(_selectedDate.year,_selectedDate.month,_selectedDate.day - 1);
    yesterdayDate=ConstantUtils.dayMonthYearFormat.format(_yesterday);
    _yesterdayGoldList = await ExchangeService.selectGoldList(
        yesterdayDate
    );
    if (_yesterdayGoldList.length > 0) {
      yesterGoldList.clear();
      yesterGoldList = _yesterdayGoldList;
    } else {
      yesterGoldList.clear();
    }
    if (_goldList.length > 0) {
      goldList.clear();
      goldList = _goldList;
    } else {
      goldList.clear();
    }

    if (_exchangeList.length > 0) {
      exchangeList.clear();
      exchangeList = _exchangeList;
    } else {
      //exchangeList.clear();
    }
    if (exchangeList.length > 0) {
      selectedValue = exchangeList[0];
    }
    update();
  }
}
