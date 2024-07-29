
import 'package:AthaPyar/athabyar_api/request_response_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/UserGuide.dart';


class UserGuideController extends GetxController {

  late PageController _pageController;

  PageController get pageController => this._pageController;

  RxInt _questionNumber = 1.obs;

  RxInt get questionNumber => this._questionNumber;

  List<UserGuide> userGuideList = [];


  @override
  void onInit() {
    _pageController = PageController();
    init();
    super.onInit();
  }
  void updateTheQnNum(int index) {
    _questionNumber.value = index + 1;
      update();
  }
  void init() async {
    userGuideList.clear();
    userGuideList = await RequestResponseApi.getUserGuideResponse();
    update();
  }

  @override
  void onClose() {
    super.onClose();
    _pageController.dispose();
  }


}
