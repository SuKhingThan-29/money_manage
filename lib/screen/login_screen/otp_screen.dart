import 'package:AthaPyar/controller/login_controller.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/screen/login_screen/login.dart';
import 'package:AthaPyar/screen/login_screen/signup.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPScreen extends StatefulWidget {
  String code;
   OTPScreen({required this.code});

  @override
  _OTPScreenState createState() => _OTPScreenState(code:code);
}

class _OTPScreenState extends State<OTPScreen> {
  String code;
  LoginController loginController = Get.put(LoginController());
  _OTPScreenState({required this.code});
  late String _otpNumber='';
    var endTime=DateTime.now().millisecondsSinceEpoch+1000*60;

  void onEnd(){
    setState(() {
      Get.off(() => LoginScreen());
    });
  }
  @override
  void dispose(){
    loginController.countdownTimerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    loginController.onInit();
    loginController.countdownTimerController=CountdownTimerController(endTime: endTime,onEnd: onEnd);
    super.initState();
    loginController.isLoading(true);
    _sendAnalyticsEvent(otp_screen);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: themeColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: GetBuilder<LoginController>(
            init: LoginController(),
            builder: (value){
              return value.isLoading.isTrue? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/background_curve.png"),
                        fit: BoxFit.cover),
                color: themeColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height/3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            child: Image.asset('assets/icon/splash_icon.png'),
                          ),
                          Text(
                            'AThaByar'.tr,
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 20,)
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height/2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Text(
                        'Verification Code'.tr,
                        style: TextStyle(color: Colors.black, fontSize: 22,fontWeight: FontWeight.bold),
                      ),
                          Text(
                            'Enter the verification code sent to\n'
                                '                 your phone number'.tr,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Center(
                              child:   FractionallySizedBox(
                                widthFactor: 1,
                                child: OTPTextField(
                                  length: 6,
                                  width: MediaQuery.of(context).size.width,
                                  textFieldAlignment: MainAxisAlignment.spaceAround,
                                  fieldWidth: 35,
                                  fieldStyle: FieldStyle.box,
                                  outlineBorderRadius: 15,
                                  style: TextStyle(fontSize: 17, color: Colors.black),
                                  onChanged: (pin) {
                                    _otpNumber = pin;
                                  },
                                  onCompleted: (pin) {
                                    _otpNumber = pin;
                                    FocusScope.of(context).requestFocus(FocusNode());
                                  },
                                ),
                              ),
                            ),
                          ),
                          CountdownTimer(
                              controller: loginController.countdownTimerController,
                              onEnd: onEnd,
                              endTime: endTime
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.5,
                            child: RaisedButton(
                                onPressed: () async{
                                  ConstantUtils util=ConstantUtils();
                                  SharedPreferences pref=await SharedPreferences.getInstance();
                                  var _isInternet = await util.isInternet();

                                  if(_isInternet){
                                    if(_otpNumber.length>3){
                                      value.isLoading(false);
                                      value.verifyOTP(_otpNumber,context,code);

                                    }else{
                                      ConstantUtils.showAlertDialog(context,'Please type correct otp code!');
                                    }

                                  }else{
                                    ConstantUtils.showAlertDialog(context,internetConnectionStatus);
                                    value.isLoading(true);
                                    setState(() {

                                    });
                                  }
                                  _sendAnalyticsEvent(otp_btn);
                                },
                                color: Colors.white,
                                textColor: Colors.black,
                                shape: StadiumBorder(
                                    side: BorderSide(color: themeColor, width: 1)),
                                child: Text('Login'.tr)),
                          ),
                          Text(
                            "Didn't receive code".tr,
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: (){
                              Get.off(()=>SignupScreen());
                            },
                            child: Text(
                              "Resend Now".tr,

                              style: TextStyle(color: Colors.red, fontSize: 16,decoration: TextDecoration.underline),
                            ),
                          )
                        ],
                      ),
                    )

                  ],
                ),
              ):Center(child: CircularProgressIndicator(),);
            },
          )
      ),
    );
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

}
