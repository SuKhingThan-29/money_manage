import 'dart:io';
import 'package:AthaPyar/componenets/custom_ads.dart';
import 'package:AthaPyar/controller/exchange_controller.dart';
import 'package:AthaPyar/datatbase/model/tbl_exchange.dart';
import 'package:AthaPyar/helper/size_config.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/screen/home_screen/component/home_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ExchangePage extends StatefulWidget {
  @override
  _ExchangeScreen createState() => _ExchangeScreen();
}

class _ExchangeScreen extends State<ExchangePage> {
  ExchangeController _exchangeController = Get.put(ExchangeController());

  var _selectedDate = DateTime.now();
  var code=myanmarCode;
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _exchangeController.onInit();
    init();

  }
  void init()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    if(pref.getString(selected_country)!=null){
      code=await pref.getString(selected_country).toString();
    }
  }
  @override
  void dispose(){
    super.dispose();
  }

  bool loading = false;
  var allTodos = [];
  int freq = 0;
  int dura = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
          color: ConstantUtils.isDarkMode
              ? ConstantUtils.darkMode.backgroundColor
              : ConstantUtils.lightMode.backgroundColor,
          child: GetBuilder<ExchangeController>(
            init: ExchangeController(),
            builder: (_controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  HomeHeader(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      code==cambodiaCode?Container():Padding(
                          padding:
                          EdgeInsets.only(right: getProportionateScreenWidth(1)),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_outlined,
                              size: 22,
                              color: ConstantUtils.isDarkMode
                                  ? ConstantUtils.darkMode.imageBackgroundColor
                                  : ConstantUtils.lightMode.imageBackgroundColor,
                            ),
                            onPressed: () {
                              _selectedDate = DateTime(_selectedDate.year,_selectedDate.month,_selectedDate.day - 1);
                              setState(() {});
                              _controller.selectExchangeAndGoldData(_selectedDate);

                            },
                          )),
                      Container(
                        height: 50,
                        child: Center(
                          child: Text(
                            ConstantUtils.dayMonthYearFormat.format(_selectedDate),
                            style: TextStyle(
                                color: ConstantUtils.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 20),
                          ),
                        ),
                      ),
                      code==cambodiaCode?Container():Padding(
                          padding:
                          EdgeInsets.only(right: getProportionateScreenWidth(1)),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 22,
                              color: ConstantUtils.isDarkMode
                                  ? ConstantUtils.darkMode.imageBackgroundColor
                                  : ConstantUtils.lightMode.imageBackgroundColor,
                            ),
                            onPressed: () {
                              _selectedDate = DateTime(_selectedDate.year,_selectedDate.month,_selectedDate.day + 1);
                              setState(() {});
                              _controller.selectExchangeAndGoldData(_selectedDate);

                            },
                          ))
                    ],
                  ),
                  code==cambodiaCode?Container():Container(
                     //margin: EdgeInsets.all(10),
                     padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              width: 1,
                              color: ConstantUtils.isDarkMode
                                  ? dark_border_color
                                  : light_border_color),
                          ),
                      color: ConstantUtils.isDarkMode
                          ? dark_nav_color
                          : Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                         //   margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              color: themeColor,
                            ),
                            width: MediaQuery.of(context).size.width / 2,
                            height: 40,
                            child: Center(
                              child: Text(
                                'Gold'.tr,
                                style: TextStyle(
                                    color: ConstantUtils.isDarkMode
                                        ? Colors.black
                                        : Colors.white),
                              ),
                            )),

                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.arrow_drop_up_sharp,
                                  color: Colors.blue,
                                  size: 50,
                                ),
                                Text(
                                  _controller.goldList.length > 0
                                      ? _controller.goldList[0].local_price +
                                      ' ' +
                                      'MMK'.tr
                                      : '',
                                  style: TextStyle(
                                      color: ConstantUtils.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            RichText(
                              text: TextSpan(
                                  text: 'Yesterday'.tr,
                                  style: TextStyle(color: Colors.red, fontSize: 8),
                                  children: [
                                    TextSpan(
                                      text: _controller.yesterGoldList.length > 0
                                          ? _controller
                                          .yesterGoldList[0].local_price +
                                          ' ' +
                                          'MMK'.tr
                                          : '',
                                      style:
                                      TextStyle(color: Colors.red, fontSize: 12),
                                    )
                                  ]),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  _controller.exchangeList.length > 0
                      ? Container(
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              width: 1,
                              color: ConstantUtils.isDarkMode
                                  ? dark_border_color
                                  : light_border_color),
                          bottom: BorderSide(
                              width: 1,
                              color: ConstantUtils.isDarkMode
                                  ? dark_border_color
                                  : light_border_color)),
                      color: ConstantUtils.isDarkMode
                          ? dark_nav_color
                          : Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: Colors.green,
                          ),
                          width: MediaQuery.of(context).size.width / 2,
                          height: 40,
                          child: DropdownButton<TBLExchange>(
                            //isDense: true,
                            hint: Text(
                              'Choose'.tr,
                              style: TextStyle(
                                  color: Colors.white),
                            ),
                            value: _controller.selectedValue,
                            underline: SizedBox(),
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color:Colors.black,
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(
                                color:Colors.white),
                            onChanged: (TBLExchange? newValue) {
                              setState(() {
                                _controller.selectedValue = newValue;
                              });
                            },
                            items: _controller.exchangeList
                                .map<DropdownMenuItem<TBLExchange>>(
                                    (TBLExchange value) {
                                  return DropdownMenuItem<TBLExchange>(
                                    value: value,
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      width:
                                      MediaQuery.of(context).size.width / 2.5,
                                      child: Text(value.name,style: TextStyle(color:
                                      Colors.black),),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                        Spacer(),
                        Text(
                          _controller.selectedValue != null
                              ? _controller.selectedValue!.price
                              : '0.0',
                          style: TextStyle(
                              color: ConstantUtils.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          code==cambodiaCode?'KHR':'MMK'.tr,
                          style: TextStyle(
                              color: ConstantUtils.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 8,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  )
                      : Container(),


                  CustomAds(height: 250,myBanner: 'myBanner',),
                  Spacer(),
                  CustomAds(height: 50,myBanner: 'myBanner',)
                ],
              );
            },
          ),
        ));
  }
}
