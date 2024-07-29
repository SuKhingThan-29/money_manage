import 'package:AthaPyar/controller/transaction_controller.dart';
import 'package:AthaPyar/helper/size_config.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MonthlyDetailWidget extends StatefulWidget{
  @override
  _MonthlyDetailWidget createState() => _MonthlyDetailWidget();
}
class _MonthlyDetailWidget extends State<MonthlyDetailWidget>{
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    var numberFormat = new NumberFormat("#,##0", "en_US");
    return Expanded(
      child:  GetBuilder<TransactionController>(
          init: TransactionController(),
          builder: (value){
            return ListView.builder(
                shrinkWrap: true,
                physics: PageScrollPhysics(),
                itemCount:value.monthlySummaryList.length,
                itemBuilder: (BuildContext context,int index){
                  return Container(
                      padding: EdgeInsets.all(5),
                      height:
                      getProportionateScreenHeight(50),
                      decoration: BoxDecoration(
                          color:  ConstantUtils.isDarkMode?dark_nav_color:Colors.white,
                          border: Border(
                              bottom: BorderSide(
                                  width: 1.0,
                                  color: ConstantUtils.isDarkMode?dark_border_color:light_border_color
                              )

                          )
                      ),
                      child :Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(value.monthlySummaryList[index].monthYear.split(' ')[0],style: TextStyle(color: ConstantUtils.isDarkMode
                                ? ConstantUtils.lightMode.textColor
                                : ConstantUtils.lightMode.textColor),
                            ),
                            Spacer(),
                            Text('${numberFormat.format(double.parse(value.monthlySummaryList[index].incomeAmount))}'+'${ConstantUtils.isUSDolllar?mDollar:'K'.tr}',style: TextStyle(color: Colors.blue),),
                            SizedBox(width: 10,),
                            Text('${numberFormat.format(double.parse(value.monthlySummaryList[index].expenseAmount))}'+'${ConstantUtils.isUSDolllar?mDollar:'K'.tr}',style: TextStyle(color: redColor),),
                          ],
                        ),
                      )

                  );
                });
          })
    );
  }
}