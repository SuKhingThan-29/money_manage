import 'package:AthaPyar/controller/status_controller.dart';
import 'package:AthaPyar/controller/transaction_controller.dart';
import 'package:AthaPyar/datatbase/model/tbl_status.dart';
import 'package:AthaPyar/helper/size_config.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/screen/home_screen/component/date_selection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../componenets/custom_ads.dart';

enum LegendShape { Circle, Rectangle }

class StatusScreenPage extends StatefulWidget {
  @override
  _StatusScreenPage createState() => _StatusScreenPage();
}

class GDPData {
  GDPData(this.continent, this.gdp, this.color);

  final String continent;
  final int gdp;
  final int color;
}

class _StatusScreenPage extends State<StatusScreenPage> with WidgetsBindingObserver {
  StatusController _statusController = Get.put(StatusController());
  TransactionController _transactionController = Get.put(TransactionController());
  TBLStatus? tblStatus;

  final colorList = <Color>[
    Color(0xfffdcb6e),
    Color(0xff0984e3),
    Color(0xfffd79a8),
    Color(0xffe17055),
    Color(0xff6c5ce7),
  ];

  final gradientList = <List<Color>>[
    [
      Color.fromRGBO(223, 250, 92, 1),
      Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      Color.fromRGBO(129, 182, 205, 1),
      Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      Color.fromRGBO(175, 63, 62, 1.0),
      Color.fromRGBO(254, 154, 92, 1),
    ]
  ];

  ChartType? _chartType = ChartType.disc;
  bool _showCenterText = true;
  double? _ringStrokeWidth = 32;
  double? _chartLegendSpacing = 32;

  bool _showLegendsInRow = false;
  bool _showLegends = true;

  bool _showChartValueBackground = true;
  bool _showChartValues = true;
  bool _showChartValuesInPercentage = false;
  bool _showChartValuesOutside = false;

  bool _showGradientColors = false;

  LegendShape? _legendShape = LegendShape.Circle;

  int key = 0;
  var chart;

  String type=IncomeType;
  var currentDate;

NumberFormat numbarFormat =NumberFormat("#,##0.00", "en_US");
  @override
  void initState() {

    var dateTimeSelection =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
     currentDate = ConstantUtils.monthFormatter.format(dateTimeSelection);

    _statusController.onInit();
    _statusController.isIncomeClick=true;

    _statusController.sendMonthYear(currentDate,type);
    _transactionController.isMonthly=false;
    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state)async {
    super.didChangeAppLifecycleState(state);
    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
        _statusController.sendMonthYear(currentDate, type);
        debugPrint('AppLifeCycle: Resume');
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
  @override
  void didUpdateWidget(StatusScreenPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  bool loading = false;
  var allTodos = [];
  int freq = 0;
  int dura = 0;


  @override
  Widget build(BuildContext context) {
    if(_statusController.statusList == null && _statusController.dataMap.isNull && _statusController.colorList == null){

    }else{
      chart = GetBuilder<StatusController>(
          init: StatusController(),
          builder: (_controller) {
            return (_controller.dataMap !=null && _controller.dataMap!.length>0 && _controller.colorList !=null && _controller.colorList.length>0)?PieChart(
              dataMap: _controller.dataMap!,
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: _chartLegendSpacing!,
              chartRadius: MediaQuery.of(context).size.width / 2,
              colorList: _controller.colorList,
              initialAngleInDegree: 0,
              chartType: _chartType!,
              centerText: _showCenterText ? "" : null,
              legendOptions: LegendOptions(
                showLegendsInRow: _showLegendsInRow,
                showLegends: _showLegends,
                legendShape: _legendShape == LegendShape.Circle
                    ? BoxShape.circle
                    : BoxShape.rectangle,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              chartValuesOptions: ChartValuesOptions(
                showChartValueBackground: _showChartValueBackground,
                showChartValues: _showChartValues,
                showChartValuesInPercentage: _showChartValuesInPercentage,
                showChartValuesOutside: _showChartValuesOutside,
              ),
              ringStrokeWidth: _ringStrokeWidth!,
              emptyColor: Colors.grey,
              gradientList: _showGradientColors ? gradientList : null,
              emptyColorGradient: [
                Color(0xff6c5ce7),
                Colors.blue,
              ],
            ):Container();

          });
    }
    var numberFormat = new NumberFormat("#,##0", "en_US");
    return  SafeArea(
      child:GetBuilder<StatusController>(
          init: StatusController(),
          builder: (value) {
            return  Container(
                color: ConstantUtils.isDarkMode
                ? ConstantUtils.darkMode.backgroundColor
                    : ConstantUtils.lightMode.backgroundColor,
                child:  Stack(

              children: [
                Column(
                  children: [
                    Container(
                      color: ConstantUtils.isDarkMode ? dark_nav_color : themeColor,
                      height: getProportionateScreenHeight(app_bar_height),
                      child: Center(
                        child: Text(
                          'Status'.tr,
                          style: TextStyle(color: Colors.white,fontSize: app_bar_title),
                        ),
                      ),
                    ),
                    DateSelection(),
                    Padding(
                      padding: EdgeInsets.all(2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              child: FractionallySizedBox(
                                widthFactor: 1.0,
                                child: TextButton(
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                        EdgeInsets.all(3)),
                                    backgroundColor: MaterialStateProperty.all<Color>(
                                        ConstantUtils.isDarkMode
                                            ? dark_nav_color
                                            : Colors.white),
                                    foregroundColor:
                                    MaterialStateProperty.all<Color>(Colors.black),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                            side: BorderSide(
                                                color: value.isIncomeClick?ConstantUtils.isDarkMode
                                                    ? dark_border_color
                                                    : light_border_color:lightGrey))),
                                  ),
                                  onPressed: () {
                                    value.isIncomeClick=true;
                                    type=IncomeType;
                                    value.isExpenseClick=false;
                                    value.sendMonthYear(value.monthYear,type);

                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('income'.tr+'(${ConstantUtils.isUSDolllar?mDollar:'K'.tr})' ,
                                            style: TextStyle(color: fontGreyColor,fontSize: 12)),
                                        Text(
                                            (value.dailySummaryList.length > 0)
                                                ?
                                            value.numberFormat.format(int.parse(
                                                value.dailySummaryList[0]
                                                    .incomeAmount))
                                                :  '0.00',
                                            style: TextStyle(color: Colors.blue)),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                          SizedBox(
                            width: 5,
                          ),
                          Flexible(
                              child: FractionallySizedBox(
                                widthFactor: 1.0,
                                child: TextButton(
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                        EdgeInsets.all(3)),
                                    backgroundColor: MaterialStateProperty.all<Color>(
                                        ConstantUtils.isDarkMode
                                            ? dark_nav_color
                                            : Colors.white),
                                    foregroundColor:
                                    MaterialStateProperty.all<Color>(Colors.black),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                            side: BorderSide(
                                                color: value.isExpenseClick?ConstantUtils.isDarkMode
                                                    ? dark_border_color
                                                    : light_border_color:lightGrey))),
                                  ),
                                  onPressed: () {
                                    value.isIncomeClick=false;
                                    value.isExpenseClick=true;
                                    type=ExpenseType;
                                    value.sendMonthYear(value.monthYear,type);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Expense'.tr+'(${ConstantUtils.isUSDolllar?mDollar:'K'.tr})' ,
                                            style: TextStyle(color: fontGreyColor,fontSize: 12)),
                                        Text(
                                            (value.dailySummaryList.length > 0)
                                                ?
                                            value.numberFormat.format(int.parse(
                                                value.dailySummaryList[0]
                                                    .expenseAmount))
                                                :  '0.00',
                                            style: TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                   Expanded(child: SingleChildScrollView(
                     child: Column(
                       children: [
                         (value.statusList!=null && value.statusList.length > 0 &&
                             value.dataMap != null &&
                             value.dataMap!.isNotEmpty &&
                             value.dataMap!.length > 0)
                             ? Container(
                           child: chart,
                           margin: EdgeInsets.symmetric(
                             vertical: 5,
                           ),
                         )
                             : Container(),
                         (value.statusList.length > 0)
                             ? ListView.builder(
                             physics: PageScrollPhysics(),
                             scrollDirection: Axis.vertical,
                             shrinkWrap: true,
                             itemCount: value.statusList.length,
                             itemBuilder: (BuildContext context, int index) {
                               try {
                                 tblStatus = value.statusList[index];
                               } catch (e) {
                                 print(e);
                               }
                               return Container(
                                 decoration: BoxDecoration(
                                     color: ConstantUtils.isDarkMode
                                         ? dark_nav_color
                                         : Colors.white,
                                     border: Border(
                                         bottom: BorderSide(
                                             width: 1.0,
                                             color: ConstantUtils.isDarkMode
                                                 ? dark_border_color
                                                 : underLineColor))),
                                 padding: EdgeInsets.all(10),
                                 child: Row(
                                   mainAxisAlignment:
                                   MainAxisAlignment.spaceBetween,
                                   children: [
                                     Container(
                                       width: 50,
                                       height: 20,
                                       child: TextButton(
                                         style: ButtonStyle(
                                           padding: MaterialStateProperty.all<
                                               EdgeInsets>(EdgeInsets.all(1)),
                                           backgroundColor:
                                           MaterialStateProperty.all<Color>(
                                               Color(int.parse(
                                                   tblStatus!.color))
                                                   .withOpacity(1)),
                                           foregroundColor:
                                           MaterialStateProperty.all<Color>(
                                               Colors.white),
                                           shape: MaterialStateProperty.all<
                                               RoundedRectangleBorder>(
                                               RoundedRectangleBorder(
                                                   borderRadius:
                                                   BorderRadius.circular(
                                                       18.0),
                                                   side: BorderSide(
                                                       color: Colors.grey))),
                                         ),
                                         onPressed: () {
                                           setState(() {});
                                         },
                                         child: Text(
                                           numberFormat.format(double.parse(tblStatus!.percent))

                                               +
                                               '%',
                                           style: TextStyle(
                                               color: Colors.black,
                                               fontSize: 12),
                                         ),
                                       ),
                                     ),
                                     SizedBox(
                                       width: 5,
                                     ),
                                     Text(
                                       tblStatus!.categoryName,
                                       style: TextStyle(color: Colors.red),
                                     ),
                                     Spacer(),
                                     Text(
                                       '${numberFormat.format(
                                           double.parse(tblStatus!.amount))}' +'${ConstantUtils.isUSDolllar?mDollar:'K'.tr}',
                                       style: TextStyle(color: Colors.red),
                                     )
                                   ],
                                 ),
                               );
                             })
                             : Container(),
                       ],
                     ),
                   ),),
                    SizedBox(height: getProportionateScreenHeight(50),),
                  ],
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  //child: _widgetAdsType(context),
                  child: CustomAds(height: 50, myBanner: 'myBanner', ),)

              ],
            )
            );

          },
        ),
      );

  }
}
