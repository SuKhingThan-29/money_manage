import 'package:AthaPyar/controller/transaction_controller.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:flutter/material.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:get/get.dart';

class MonthlySummaryWidget extends StatefulWidget {
  MonthlySummaryWidget({Key? key}) : super(key: key);

  @override
  _MonthlySummaryWidget createState() => _MonthlySummaryWidget();
}

class _MonthlySummaryWidget extends State<MonthlySummaryWidget> {
  TransactionController _transactionController =
  Get.put(TransactionController());
  var _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
     _transactionController.onInit();
    _transactionController.setYear(ConstantUtils.yearFormatter.format(_selectedDate));
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: GetBuilder<TransactionController>(
        init: TransactionController(),
        builder: (value) {
          return Container(
              margin: EdgeInsets.fromLTRB(2, 5, 2, 15),
              child: value.yearlySummaryList.length > 0
                  ? Row(
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
                                    side: BorderSide(color: themeColor))),
                          ),
                          onPressed: () {
                            setState(() {});
                          },
                          child: Padding(
                            padding: EdgeInsets.all(3),
                            child: Column(
                              children: [
                                Spacer(),
                                Text('income'.tr+ '( ${ConstantUtils.isUSDolllar?mDollar:'K'.tr} )',style: TextStyle(color: ConstantUtils.isDarkMode
                                    ? ConstantUtils.darkMode.textColor
                                    : ConstantUtils.lightMode.textColor,fontSize: 11.5),),
                                Spacer(),
                                Text(
                                      value.numberFormat.format(double.parse(
                                          value.yearlySummaryList[0].income)),
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        )),
                  ),
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
                                  side: BorderSide(color: themeColor))),
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
                                Text(
                                      value.numberFormat.format(double.parse(
                                          value
                                              .yearlySummaryList[0].expense)),
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
                        child: TextButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.all(2)),
                            backgroundColor:MaterialStateProperty.all<Color>(
                                ConstantUtils.isDarkMode?dark_nav_color:Colors.white),
                            foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    side: BorderSide(color: themeColor))),
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
                                  'Total'.tr+ '(${ConstantUtils.isUSDolllar?mDollar:'K'.tr})',style: TextStyle(color: ConstantUtils.isDarkMode
                                    ? ConstantUtils.darkMode.textColor
                                    : ConstantUtils.lightMode.textColor,fontSize: 11.5),
                                ),
                                Spacer(),
                                Text(
                                      value.numberFormat.format(double.parse(
                                          value.yearlySummaryList[0].total)),
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
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'income'+ '(${ConstantUtils.isUSDolllar?mDollar:'K'.tr}',
                          style: TextStyle(color: Colors.blue),
                        ),
                        Text(
                         ' 0.00',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Expense'+ '(${ConstantUtils.isUSDolllar?mDollar:'K'.tr})',
                          style: TextStyle(color: Colors.orange),
                        ),

                        Text(
                         ' 0.00',
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Total'+ '(${ConstantUtils.isUSDolllar?mDollar:'K'.tr})',
                          style: TextStyle(
                            color: ConstantUtils.isDarkMode
                                ? ConstantUtils.darkMode.textColor
                                : ConstantUtils.lightMode.textColor,
                          ),
                        ),
                        Text(
                         ' 0.00',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ConstantUtils.isDarkMode
                                ? ConstantUtils.darkMode.textColor
                                : ConstantUtils.lightMode.textColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
          );
        }));
  }
}
