import 'package:AthaPyar/controller/account_group_controller.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountSummaryWidget extends StatefulWidget {
  AccountSummaryWidget({Key? key}) : super(key: key);

  @override
  _AccountSummaryWidget createState() => _AccountSummaryWidget();
}

class _AccountSummaryWidget extends State<AccountSummaryWidget> {
  AccountGroupController _accountGroupController =
  Get.put(AccountGroupController());

  @override
  void initState() {
    super.initState();
    _accountGroupController.onInit();
  }
  @override
  Widget build(BuildContext context) {
 //   numberFormat = new NumberFormat("#,##0.00", "en_US");

    return Container(child: GetBuilder<AccountGroupController>(
        init: AccountGroupController(),
        builder: (value) {
          return Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
              child: value.accountSummaryList.length > 0
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex:1,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height/12,
                        child: TextButton(
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
                            padding: EdgeInsets.all(0),
                            child: Column(
                              children: [
                                Spacer(),
                                Text('Account'.tr + '(${ConstantUtils.isUSDolllar?mDollar:'K'.tr})', style: TextStyle(color: ConstantUtils.isDarkMode
                                    ? ConstantUtils.darkMode.textColor
                                    : ConstantUtils.lightMode.textColor,fontSize: 11.5)),
                                Spacer(),
                                Text(

                                      value.numberFormat.format(int.parse(
                                          value.accountSummaryList[0].account))

                                  ,
                                  style: TextStyle(color: Colors.blue),
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
                    flex:1,
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
                            padding: EdgeInsets.all(0),
                            child: Column(
                              children: [
                                Spacer(),
                                Text('Liabilities'.tr+ '(${ConstantUtils.isUSDolllar?mDollar:'K'.tr})',style: TextStyle(color: ConstantUtils.isDarkMode
                                ? ConstantUtils.darkMode.textColor
                                    : ConstantUtils.lightMode.textColor,fontSize: 11.5),),
                                Spacer(),
                                Text(

                                      value.numberFormat.format(double.parse(
                                          value
                                              .accountSummaryList[0].liabilities)),

                                  style: TextStyle(color: Colors.red),
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
                      flex:1,
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
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
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
                                  'Total'.tr+ '(${ConstantUtils.isUSDolllar?mDollar:'K'.tr})',
                                  style: TextStyle(color: ConstantUtils.isDarkMode
                                      ? ConstantUtils.darkMode.textColor
                                      : ConstantUtils.lightMode.textColor,fontSize: 11.5),
                                ),
                                Spacer(),
                                Text(

                                      value.numberFormat.format(double.parse(
                                          value.accountSummaryList[0].total)),
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
                          'income'.tr+'(${ConstantUtils.isUSDolllar?mDollar:'K'.tr})',
                          style: TextStyle(color: Colors.blue),
                        ),
                        Text(
                         '0.00',
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
                          'Expense'.tr+'(${ConstantUtils.isUSDolllar?mDollar:'K'.tr})',
                          style: TextStyle(color: Colors.orange),
                        ),
                        Text(
                         '0.00',
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Total'.tr+'(${ConstantUtils.isUSDolllar?mDollar:'K'.tr})',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ConstantUtils.isDarkMode
                                ? Colors.white: Colors.black,
                          ),
                        ),

                        Text(
                          '0.00',
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