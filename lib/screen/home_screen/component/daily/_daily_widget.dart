import 'package:AthaPyar/athabyar_api/request_response_model.dart';
import 'package:AthaPyar/controller/transaction_controller.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/screen/transaction_screen/transaction.dart';
import 'package:flutter/material.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DailyWidget extends StatefulWidget {
  bool isSearch;

  DailyWidget({required this.isSearch});

  @override
  _DailyWidget createState() => _DailyWidget(isSearch: isSearch);
}

class _DailyWidget extends State<DailyWidget> {
  bool isSearch;

  _DailyWidget({required this.isSearch});
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return GetBuilder<TransactionController>(
        init: TransactionController(),
        builder: (value) {
          return value.isLoading.isTrue
              ? CircularProgressIndicator()
              : value.dailyModelList.length > 0
                  ? Expanded(
                      child: ListView.builder(
                      physics: PageScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: value.dailyModelList.length,
                      itemBuilder: (BuildContext context, int mIndex) {
                        String dateResult = '';
                        String dayResult = '';
                        try {
                          String mDate = value.dailyModelList[mIndex].date;
                          var mDateResult = mDate.split(' ')[0];
                          var dateData = ConstantUtils.formatter
                              .format(DateTime.parse(mDateResult));
                          dateResult = dateData.split('/')[0];
                          var day = dateData.split('(')[1];
                          dayResult = day.split(')')[0];
                        } catch (e) {
                          print(e);
                        }
                        return (value.dailyModelList[mIndex].daily_detail
                                    .length ==
                                0)
                            ? Container()
                            : _widgetView(value.dailyModelList[mIndex],
                                dateResult, dayResult);
                      },
                    ))
                  : Container();
        });
  }

  Widget _widgetView(Daily daily, String resultDate, String mDayResult) {
    var numberFormat = new NumberFormat("#,##0", "en_US");
    return Container(
        decoration: BoxDecoration(
          color: ConstantUtils.isDarkMode ? dark_nav_color : Colors.white,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: ConstantUtils.isDarkMode
                              ? dark_border_color
                              : light_border_color),
                      bottom: BorderSide(
                          color: ConstantUtils.isDarkMode
                              ? dark_border_color
                              : light_border_color))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(resultDate,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: ConstantUtils.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 50,
                    height: 20,
                    child: TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(1)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            ConstantUtils.isDarkMode
                                ? dark_box_background_color
                                : light_box_background_color),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )),
                      ),
                      onPressed: () {
                        setState(() {});
                      },
                      child: Text(
                        ' $mDayResult ',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                        '${numberFormat.format(double.parse(daily.incomeAmount))} ${ConstantUtils.isUSDolllar?mDollar:'K'.tr}' ,
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(

                        '${numberFormat.format(double.parse(daily.expenseAmount))} ${ ConstantUtils.isUSDolllar?mDollar:'K'.tr}',
                    //daily.expenseAmount,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            daily.daily_detail.length > 0
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: PageScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: daily.daily_detail.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                          onTap: () {
                            Get.off(() => TransactionScreen(
                                transactionId: daily.daily_detail[index].id,
                                dailyId: daily.daily_detail[index].dailyId));
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1.0,
                                        color: ConstantUtils.isDarkMode
                                            ? dark_border_color
                                            : light_border_color))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                daily.daily_detail[index].type == TransferType
                                    ? Expanded(
                                        child: FractionallySizedBox(
                                        widthFactor: 0.8,
                                        child: Text(
                                          'Transfer'.tr,
                                          style:
                                              TextStyle(color: fontGreyColor),
                                          textAlign: TextAlign.start,
                                        ),
                                      ))
                                    : Expanded(
                                    child: FractionallySizedBox(
                                      widthFactor: 0.8,
                                      child: Text(
                                        daily
                                            .daily_detail[index].categoryName,
                                        style: TextStyle(
                                            color: daily.daily_detail[index]
                                                .type ==
                                                IncomeType
                                                ? Colors.blue
                                                : Colors.red),
                                        textAlign: TextAlign.start,
                                      ),
                                    )),
                                Expanded(
                                    child: FractionallySizedBox(
                                        widthFactor: 1.0,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              daily.daily_detail[index].note
                                                      .isNotEmpty
                                                  ? Text(daily
                                                      .daily_detail[index].note,style: TextStyle(
                                                color: fontGreyColor
                                              ),)
                                                  : Container(),
                                              daily.daily_detail[index].type ==
                                                      TransferType
                                                  ? Row(
                                                      children: [
                                                      Flexible(
                                                      child: FractionallySizedBox(
                      widthFactor: 1.0,
                                                       child: Text(
                                                          daily
                                                              .daily_detail[
                                                                  index]
                                                              .accountName,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              color:
                                                                  fontGreyColor),
                                                        ),
                                                              ),),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.all(2),
                                                          child: Icon(
                                                            Icons.arrow_forward,
                                                            size: 14.0,
                                                            color:
                                                                fontGreyColor,
                                                          ),
                                                        ),
                                                        Flexible(
                                                        child: FractionallySizedBox(
                                                        widthFactor: 1.0,
                                                        child:
                                                        Text(
                                                          daily
                                                              .daily_detail[
                                                                  index]
                                                              .toAccountName,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              color:
                                                                  fontGreyColor),
                                                        ),
                                                        ))
                                                      ],
                                                    )
                                                  : Text(
                                                      daily.daily_detail[index]
                                                          .accountName,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: Colors.blue),
                                                    )
                                            ]))),

                                Expanded(
                                    child: FractionallySizedBox(
                                        widthFactor: 1,
                                        child: Text(
                                          numberFormat.format(double.parse(
                                                  daily.daily_detail[index]
                                                      .amount)),
                                          textAlign: TextAlign.end,
                                          style: TextStyle(color:daily.daily_detail[index].type==IncomeType?Colors.blue:Colors.red),
                                        ))),
                                Text(
                                  ConstantUtils.isUSDolllar?mDollar:'K'.tr +
                                      ' ' ,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(color:daily.daily_detail[index].type==IncomeType?Colors.blue:Colors.red),
                                )
                              ],
                            ),
                          ));
                    })
                : Container(),
          ],
        ));
  }
}
