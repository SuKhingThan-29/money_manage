import 'package:AthaPyar/controller/login_controller.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/models/LanguageChange.dart';
import 'package:AthaPyar/screen/login_screen/forgot_password_sms.dart';
import 'package:AthaPyar/screen/login_screen/signup.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  LoginController loginController = Get.put(LoginController());
  bool isInvalid=false;
  bool isPasswordInvalid=false;
  String? _deviceId;
  FocusNode _focusNode=FocusNode();
  bool isPhoneNoStartWith=true;

  @override
  void initState() {
    super.initState();
    loginController.isRegister=false;
    loginController.phoneNoController.clear();
    loginController.passwordController.clear();
    loginController.confirmPasswordController.clear();
    initPlatformState();

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

  Future<void> initPlatformState() async {
    String? deviceId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    SharedPreferences pref=await SharedPreferences.getInstance();
    setState(() {
      _deviceId = deviceId;
      print("deviceId login->$_deviceId");
      pref.setString(mDeviceId, _deviceId.toString());

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: GetBuilder<LoginController>(
        init: LoginController(),
        builder: (value) {
          return loginController.isLoading.isTrue? SingleChildScrollView(child: Padding(padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
          child:Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background_curve.png"),
                    fit: BoxFit.cover),
                color: themeColor),

            child:  Column(
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
                      Center(
                        child: Text(
                          'AThaByar'.tr,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20,)

                    ],
                  ),
                ),
                Expanded(child: Container(
                  height: MediaQuery.of(context).size.height/1.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Login'.tr,
                        style: TextStyle(color: Colors.black, fontSize: 22,fontWeight: FontWeight.bold),
                      ),
                      Container(
                          margin: const EdgeInsets.only(
                              left: 30, right: 30, bottom: 10, top: 30),
                          width: MediaQuery.of(context).size.width,
                          height:70,
                          decoration: BoxDecoration(
                              color: lightGrey,
                              borderRadius:
                              BorderRadius
                                  .circular(
                                  35),
                              border: Border
                                  .all(
                                  color:
                                  lightGrey)),
                          child:Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(child: FractionallySizedBox(
                                widthFactor: 0.8,
                                child: DropdownButton(
                                  underline:
                                  SizedBox(),
                                  // Initial Value
                                  value: value
                                      .languageChange,

                                  // Down Arrow Icon
                                  icon:
                                  const Icon(
                                    Icons
                                        .keyboard_arrow_down,
                                    color: Colors.black,
                                    size: 15,
                                  ),

                                  // Array list of items
                                  items: LanguageChange.items
                                      .map((LanguageChange
                                  language) {
                                    return DropdownMenuItem(
                                        value:
                                        language,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left: 20),
                                              width: 25,
                                              height: 25,
                                              child: Image.asset(language.image),
                                            ),
                                            SizedBox(width: 10,),
                                            Text(language.code)
                                          ],
                                        )
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (LanguageChange?
                                  newValue) {
                                    setState(() {
                                      _focusNode.requestFocus();
                                      value.languageChange =
                                      newValue!;
                                    });
                                  },
                                ),
                              )),
                              Flexible(
                                child: FractionallySizedBox(
                                  widthFactor: 1.5,
                                  child: TextFormField(
                                    autofocus: true,
                                    focusNode: _focusNode,
                                    cursorColor: Colors.blue,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: new InputDecoration(hintText: value.languageChange!.country=='Myanmar'?'945XXXXXX':'81XXXXXXXX',
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                        //  errorText: value.phoneNoController.text.isEmpty?'Please fill your phone number':null
                                        errorText: isPhoneNoStartWith?null:'Please fill your phone no'
                                    ),
                                    controller: value.phoneNoController,
                                    keyboardType: TextInputType.phone,
                                    onChanged: (phonenoValue){
                                      setState(() {

                                        isPhoneNoStartWith=ConstantUtils.isErrorText(phonenoValue,value.languageChange!.code);
                                      });
                                    },


                                  ),
                                ),
                              )

                            ],
                          )

                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, bottom: 10, top: 10),
                        child:Center(
                          child: TextField(
                            obscureText: true,
                            controller: value.passwordController,
                            onChanged: (password_value){
                              setState(() {
                                if(password_value.isNotEmpty){
                                  isPasswordInvalid=false;
                                }
                              });

                            },
                            decoration: InputDecoration(
                                errorText: isPasswordInvalid?'Please insert your password':null,
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: lightGrey,width: 3.0),
                                    borderRadius: BorderRadius.circular(35)
                                ),
                                filled: true,
                                fillColor: lightGrey,
                                hintText: 'Password'.tr,
                                hintStyle: TextStyle(color: Colors.grey),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: lightGrey, width: 3.0),
                                    borderRadius: BorderRadius.circular(35)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(width: 3, color: lightGrey),
                                    borderRadius: BorderRadius.circular(35))
                            ),

                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Get.off(()=> ForgotPasswordSmsScreen());

                          });
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(8),
                            child: Center(
                              child: Text(
                                'Forgot password'.tr,
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                            )),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.5,
                        child: RaisedButton(
                            onPressed: () async {
                              bool isPhoneNoStartWith=ConstantUtils.isErrorText(value.phoneNoController.text,value.languageChange!.code);
                              if((value.phoneNoController.text.isEmpty || value.passwordController.text.isEmpty) && !isPhoneNoStartWith){
                                setState(() {
                                  if(value.phoneNoController.text.isEmpty){
                                    value.phoneNoController.text.isEmpty?isInvalid=true:isInvalid=false;
                                  }
                                  if(value.passwordController.text.isEmpty){
                                    value.passwordController.text.isEmpty?isPasswordInvalid=true:isPasswordInvalid=false;
                                  }
                                });
                              }else{
                                ConstantUtils util = ConstantUtils();
                                bool _isInternet = await util.isInternet();
                                debugPrint('boolLogin  isInternet: ${_isInternet}');
                                if (_isInternet) {
                                  value.isLoading(false);
                                  setState(() {
                                  });
                                  if(value.languageChange!.code==myanmarCode && isPhoneNoStartWith){
                                    value.login(value.phoneNoController.text,
                                        value.passwordController.text,context,_deviceId,myanmarCode);
                                  }else{
                                    value.login(value.phoneNoController.text,
                                        value.passwordController.text,context,_deviceId,cambodiaCode);
                                  }
                                } else {
                                  value.isLoading(true);
                                  setState(() {

                                  });
                                  ConstantUtils.showAlertDialog(context,internetConnectionStatus);
                                }
                              }
                              _sendAnalyticsEvent(login_btn);
                            },
                            color: Colors.white,
                            textColor: Colors.black,
                            shape: StadiumBorder(
                                side: BorderSide(color: themeColor, width: 1)),
                            child: Text('Login'.tr)),
                      ),
                      RichText(
                        text: TextSpan(
                            text: "Don't have an account?".tr,
                            style: TextStyle(color: Colors.black,fontSize: 10),
                            children: <TextSpan>[
                              TextSpan(text: 'Sign up'.tr,
                                  style: TextStyle(color: themeColor,fontSize: 16,

                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap=(){
                                      setState(() {
                                        Get.off(()=>SignupScreen());
                                      });

                                    }
                              )
                            ]
                        ),
                      )

                    ],
                  ),
                ))

              ],
            )

          ))):Center(child: CircularProgressIndicator(),);
        },

      )),
    );
  }

}
