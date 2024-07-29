import 'package:AthaPyar/controller/transaction_controller.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:flutter/material.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:get/get.dart';

class DailySummaryWidget extends StatefulWidget {
  DailySummaryWidget({Key? key}) : super(key: key);

  @override
  _DailySummaryWidget createState() => _DailySummaryWidget();
}

class _DailySummaryWidget extends State<DailySummaryWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(2, 5, 2, 15),
        child: GetBuilder<TransactionController>(
        init: TransactionController(),
        builder: (value) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/12,
                    child:  TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(3)),
                        backgroundColor:MaterialStateProperty.all<Color>(
                            ConstantUtils.isDarkMode?dark_nav_color:Colors.white),
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.black),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: BorderSide(color: ConstantUtils.isDarkMode?dark_border_color:light_border_color))),
                      ),
                      onPressed: () {
                        setState(() {});
                      },
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: Column(
                          children: [
                            Spacer(),
                            Text('income'.tr+ '(${ConstantUtils.isUSDolllar?mDollar:'K'.tr})',style: TextStyle(color: ConstantUtils.isDarkMode
                                ? ConstantUtils.darkMode.textColor
                                : ConstantUtils.lightMode.textColor,fontSize: 11),),
                          Spacer(),
                            Text(value.dailySummaryList.length>0?

                                value.numberFormat.format(double.parse(
                                    value.dailySummaryList[0].incomeAmount)):' 0.00',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),

                          ],
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                width: 2,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/12,
                  child: TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(3)),
                      backgroundColor:MaterialStateProperty.all<Color>(
                          ConstantUtils.isDarkMode?dark_nav_color:Colors.white),
                      foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                      shape: MaterialStateProperty.all<
                          RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: BorderSide(color: ConstantUtils.isDarkMode?dark_border_color:light_border_color))),
                    ),
                    onPressed: () {
                      setState(() {});
                    },
                    child: Padding(
                        padding: EdgeInsets.all(3),
                        child: Column(
                          children: [
                            Spacer(),
                            Text('Expense'.tr+ '(${ConstantUtils.isUSDolllar?mDollar:'K'.tr})',style: TextStyle(color: ConstantUtils.isDarkMode
                                ? ConstantUtils.darkMode.textColor
                                : ConstantUtils.lightMode.textColor,fontSize: 11.5),),
                            Spacer(),

                            Text(value.dailySummaryList.length>0?
                                value.numberFormat.format(double.parse(
                                    value.dailySummaryList[0].expenseAmount)):'0.00',
                              // value
                              //     .dailySummaryList[0].expenseAmount,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),

                          ],
                        )),
                  ),
                ),
              ),
              SizedBox(
                width: 2,
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/12,
                    child:  TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(3)),
                        backgroundColor:MaterialStateProperty.all<Color>(
                            ConstantUtils.isDarkMode?dark_nav_color:Colors.white),
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: BorderSide(color: ConstantUtils.isDarkMode?dark_border_color:light_border_color))),
                      ),
                      onPressed: () {
                        setState(() {});
                      },
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: Column(
                          children: [
                            Spacer(),
                            Text(
                              'Total'.tr+ '(${ConstantUtils.isUSDolllar?mDollar:'K'.tr})',
                              style: TextStyle(
                                color: ConstantUtils.isDarkMode
                                    ? ConstantUtils.darkMode.textColor
                                    : ConstantUtils.lightMode.textColor,fontSize: 11.5
                              ),
                            ),
                            Text(value.dailySummaryList.length>0?

                                value.numberFormat.format(double.parse(
                                    value.dailySummaryList[0].total)):' 0.00',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ConstantUtils.isDarkMode
                                    ? Colors.white: Colors.black,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  )),
            ],
          );
        }));
  }
}
