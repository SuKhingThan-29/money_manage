import 'package:AthaPyar/controller/weekly_controller.dart';
import 'package:AthaPyar/helper/size_config.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeeklyWidget extends StatefulWidget{
  @override
  _WeeklyWidget createState() => _WeeklyWidget();
}
class _WeeklyWidget extends State<WeeklyWidget>with WidgetsBindingObserver{
  WeeklyController _weeklyController=Get.put(WeeklyController());

  @override
  void initState(){
    _weeklyController.onInit();
    WidgetsBinding.instance.addObserver(this);
    init();
    super.initState();
  }
  void init()async{
    var dateTimeSelection =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    _weeklyController.setDate(dateTimeSelection);
  }
  @override
  void dispose() {
    // Remove the observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
      // widget is resumed
        break;
      case AppLifecycleState.inactive:
      // widget is inactive
        break;
      case AppLifecycleState.paused:
      // widget is paused
        break;
      case AppLifecycleState.detached:
      // widget is detached
        break;
    }
  }


  @override
  Widget build(BuildContext context){
    return GetBuilder<WeeklyController>(
          init: WeeklyController(),
            builder: (value){
            return
            Column(
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(2, 5, 2, 15),
                    child: value.weeklySummaryModelList.length > 0
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
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                    ConstantUtils.isDarkMode?dark_nav_color:light_nav_color,

                                  ),
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
                                          : ConstantUtils.lightMode.textColor,fontSize: 11.5),),
                                      Spacer(),
                                      Text(
                                            value.numberFormat.format(double.parse(
                                                value.weeklySummaryModelList[0].income)),
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
                            child:  TextButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(3)),
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  ConstantUtils.isDarkMode?dark_nav_color:light_nav_color,

                                ),
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
                                      Text(
                                            value.numberFormat.format(double.parse(
                                                value
                                                    .weeklySummaryModelList[0].expense)),
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
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                    ConstantUtils.isDarkMode?dark_nav_color:light_nav_color,
                                  ),
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
                                        'Total'.tr+ '(${ConstantUtils.isUSDolllar?mDollar:'K'.tr})',style: TextStyle(color: ConstantUtils.isDarkMode
                                      ? ConstantUtils.darkMode.textColor
                                          : ConstantUtils.lightMode.textColor,fontSize: 11.5),
                                      ),
                                      Spacer(),
                                      Text(

                                            value.numberFormat.format(double.parse(
                                                value.weeklySummaryModelList[0].total)),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: ConstantUtils.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
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
                                'income'.tr+ '(${ConstantUtils.isUSDolllar?mDollar:'K'.tr})',
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
                                'Expense'.tr+ '(${ConstantUtils.isUSDolllar?mDollar:'K'.tr})',
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
                                'Total'.tr+ '(${ConstantUtils.isUSDolllar?mDollar:'K'.tr})',
                                style: TextStyle(
                                  color: ConstantUtils.isDarkMode
                                      ? ConstantUtils.darkMode.textColor
                                      : ConstantUtils.lightMode.textColor,
                                ),
                              ),
                              SizedBox(
                                height: 2,
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
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: PageScrollPhysics(),
                    itemCount:value.weeklyModelList.length,
                    itemBuilder: (BuildContext context,int index){
                      return Container(
                          height:
                          getProportionateScreenHeight(50),
                          decoration: BoxDecoration(
                            color:  ConstantUtils.isDarkMode?dark_nav_color:Colors.white,
                              border: Border(
                                // top: BorderSide(
                                //   width: 1.0,
                                //   color: Utils.isDarkMode?dark_border_color:light_border_color
                                // ),
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
                                Text(value.weeklyModelList[index].weekly.split(' ')[0],
                                  style: TextStyle(color: ConstantUtils.isDarkMode
                                    ? ConstantUtils.lightMode.textColor
                                    : ConstantUtils.lightMode.textColor),
                                ),
                                Spacer(),
                                Text('${value.numberFormat.format(double.parse(value.weeklyModelList[index].income))}'+'${ConstantUtils.isUSDolllar?mDollar:'K'.tr}',style: TextStyle(color: Colors.blue),),
                                SizedBox(width: 10,),
                                Text('${value.numberFormat.format(double.parse(value.weeklyModelList[index].expense))}'+'${ConstantUtils.isUSDolllar?mDollar:'K'.tr}',style: TextStyle(color: redColor),),
                              ],
                            ),
                          )

                      );

                    })
              ],
            );
            }


    );
  }
}