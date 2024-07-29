
import 'package:AthaPyar/componenets/custom_ads.dart';
import 'package:AthaPyar/controller/transaction_controller.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/screen/home_screen/component/monthly/_monthly_widget.dart';
import 'package:AthaPyar/screen/home_screen/component/summary/monthly_summary.dart';
import 'package:AthaPyar/screen/home_screen/component/weekly/weekly_widget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/screen/home_screen/component/summary/daily_summary.dart';
import 'package:AthaPyar/screen/home_screen/component/calendar/calendar_widget.dart';
import 'package:AthaPyar/screen/home_screen/component/daily/_daily_widget.dart';
import 'package:provider/provider.dart';

class TabBarSelection extends StatefulWidget {
  _TabBarSelection createState() => _TabBarSelection();
}

class _TabBarSelection extends State<TabBarSelection>
    with WidgetsBindingObserver {
  //
  int maxFailedLoadAttempts = 3;
  TransactionController _transactionController =
      Get.put(TransactionController());
  bool isSearch = false;
  bool isClickUrl = false;


  @override
  void initState() {
    init();
    super.initState();
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  void init() async {
    _transactionController.onInit();
    _transactionController.isMonthly = false;
    _transactionController.isWeekly = false;
    WidgetsBinding.instance.addObserver(this);
  }



  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      ("AppLifeCycleDKMADS: $state");
      if (state == AppLifecycleState.paused) {
        // Your Code goes here
      } else if (state == AppLifecycleState.inactive) {
        // Your Code goes here
      } else {
        // Your Code goes here
      }
    });
  }

  void onTab(int index) {
    if (index == 3) {
      _sendAnalyticsEvent(summary_screen);
      _transactionController.isMonthly = true;
      _transactionController.isWeekly = false;
    } else if (index == 4) {
      _transactionController.isMonthly = true;
      _transactionController.isWeekly = false;
      _sendAnalyticsEvent(monthly_screen);
    } else if (index == 2) {
      _transactionController.isWeekly = true;
      _transactionController.setMonthlyTab(false);
      _sendAnalyticsEvent(weekly_screen);
    }
    else {
      _transactionController.setMonthlyTab(false);
      _transactionController.isWeekly = false;


    }
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
  bool loading = false;
  var allTodos = [];
  int freq = 0;
  int dura = 0;


  Future<String> loadLocal() async {
    return await rootBundle.loadString('assets/files/test.html');
  }


  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 5,
        child: Expanded(
          child: Column(
            children: [
              Container(
                height: 46.0,
                child: TabBar(
                    onTap: onTab,
                    indicatorColor: ConstantUtils.isDarkMode
                        ? dark_box_background_color
                        : Colors.orangeAccent,
                    indicatorWeight: 5,
                    isScrollable: true,
                    tabs: [
                      Tab(
                        child: Text(
                          'Daily'.tr,
                          style: TextStyle(
                            color: ConstantUtils.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Calendar'.tr,
                          style: TextStyle(
                            color: ConstantUtils.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Weekly'.tr,
                          style: TextStyle(
                            color: ConstantUtils.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Monthly'.tr,
                          style: TextStyle(
                            color: ConstantUtils.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Summary'.tr,
                          style: TextStyle(
                            color: ConstantUtils.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      )
                    ]),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Stack(
                      children: [
                        Center(
                          child: Column(
                            children: [
                              DailySummaryWidget(),
                              DailyWidget(
                                isSearch: isSearch,
                              ),
                              SizedBox(height: 50,),
                            ],
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                          child: CustomAds(height: 50,myBanner:'daily'),)
                      ],
                    ),
                    Stack(
                      children: [
                       Center(
                         child:  CalendarWidget(title: 'calendar',),
                       ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: CustomAds(height: 50,myBanner:'weekly'),)
                      ],
                    ),
                    Stack(
                      children: [
                        Center(
                          child: WeeklyWidget(),
                        ),

                        Align(
                            alignment: Alignment.bottomCenter,
                          child: CustomAds(height: 50,myBanner:'weekly'),)
                      ],
                    ),
                    Stack(
                      children: [
                        Center(
                          child: Column(
                            children: [
                              MonthlySummaryWidget(),
                              MonthlyDetailWidget(),
                              SizedBox(height: 50,),
                            ],
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                          child: CustomAds(height: 50,myBanner:'monthly'),)
                      ],
                    ),
                    Stack(
                      children: [
                        MonthlySummaryWidget(),
                        Align(
                            alignment: Alignment.bottomCenter,
                          child: CustomAds(height: 50,myBanner:'summary'),)
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
