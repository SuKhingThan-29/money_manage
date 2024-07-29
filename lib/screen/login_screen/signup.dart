import 'package:AthaPyar/componenets/tern_and_condition_dialog.dart';
import 'package:AthaPyar/controller/login_controller.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/models/LanguageChange.dart';
import 'package:AthaPyar/screen/login_screen/login.dart';
import 'package:AthaPyar/screen/login_screen/otp_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
  @override
  _SignupScreen createState() => _SignupScreen();
}

class _SignupScreen extends State<SignupScreen> {
  LoginController loginController = Get.put(LoginController());
  bool isInvalid=false;
  FocusNode _focusNode=FocusNode();
  bool isPhoneNoStartWith=true;

  @override
  void initState() {
    super.initState();
   // hideStatusBar();
    loginController.onInit();
    loginController.isRegister=false;
    loginController.phoneNoController.clear();
    loginController.passwordController.clear();
    loginController.confirmPasswordController.clear();
    _sendAnalyticsEvent(register_screen);
  }
  //Future hideStatusBar() => SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: loginController.isLoading.isTrue?SafeArea(
          child: GetBuilder<LoginController>(
            init: LoginController(),
            builder: (value) {
              return SingleChildScrollView(
                child: Container(
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
                              'Sign Up'.tr,
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
                                          keyboardType: const TextInputType.numberWithOptions(
                                              signed: true,
                                              decimal: true),
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.digitsOnly
                                          ],
                                          decoration: new InputDecoration(hintText: value.languageChange!.country=='Myanmar'?'945XXXXXX':'81XXXXXXXX',
                                              hintStyle: TextStyle(color: Colors.grey),
                                              border: InputBorder.none,
                                              errorText: isPhoneNoStartWith?null:'Please fill your phone no'
                                          ),
                                          controller: value.phoneNoController,
                                          onChanged: (phonenoValue){
                                            setState(() {
                                              bool isPhoneNoStartWith=false;
                                              isPhoneNoStartWith=ConstantUtils.isErrorText(phonenoValue,value.languageChange!.code);
                                              print('PhoneNoWith Country: $isPhoneNoStartWith');
                                            });
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                )

                            ),
                            FractionallySizedBox(
                              widthFactor: 0.5,
                              child: RaisedButton(
                                  onPressed: () async {
                                    bool isPhoneNoStartWith=ConstantUtils.isErrorText(value.phoneNoController.text,value.languageChange!.code);
                                    if(value.phoneNoController.text.isEmpty && !isPhoneNoStartWith){
                                      setState(() {
                                        value.phoneNoController.text.isEmpty?isInvalid=true:isInvalid=false;
                                      });
                                    }
                                    else{
                                      ConstantUtils util = ConstantUtils();
                                      var _isInternet = await util.isInternet();
                                      if (_isInternet) {
                                        value.isLoading(false);
                                        setState(() {

                                        });
                                        if(value.languageChange!.code==myanmarCode && isPhoneNoStartWith){
                                          value.requestSMS(value.phoneNoController.text,context,myanmarCode);
                                        }else if(value.languageChange!.code==cambodiaCode && isPhoneNoStartWith){
                                          value.requestSMS(value.phoneNoController.text,context,cambodiaCode);
                                        }else{
                                          value.isLoading(true);
                                        }
                                        value.isLoading(true);
                                      } else {
                                        ConstantUtils.showAlertDialog(context,internetConnectionStatus);
                                      }
                                    }
                                  },
                                  color: Colors.white,
                                  textColor: Colors.black,
                                  shape: StadiumBorder(
                                      side: BorderSide(color: themeColor, width: 1)),
                                  child: Text('Sign Up'.tr)),
                            ),
                            RichText(
                              text: TextSpan(
                                  text: 'By Signing up you accept the'.tr,
                                  style: TextStyle(color: Colors.black,fontSize: 10),
                                  children: <TextSpan>[
                                    TextSpan(text: 'Terms and condition'.tr,
                                        style: TextStyle(color: Colors.blueAccent,fontSize: 14,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap=(){
                                            setState(() {
                                              showDialog(
                                                barrierColor: Colors.transparent,
                                                context: context,
                                                builder: (context) {
                                                  return CustomAlertDialog(

                                                  );
                                                },
                                              );
                                            });
                                          }
                                    )
                                  ]
                              ),
                            ),
                            SizedBox(height: 10,),
                            RichText(
                              text: TextSpan(
                                  text: 'Already have an account?'.tr,
                                  style: TextStyle(color: Colors.black,fontSize: 10),
                                  children: <TextSpan>[
                                    TextSpan(text: 'Login'.tr,
                                        style: TextStyle(color: themeColor,fontSize: 16,

                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap=(){
                                            Get.off(()=>LoginScreen());

                                          }
                                    )
                                  ]
                              ),
                            ),

                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ))
    :Center(
        child: CircularProgressIndicator(),
      ));
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
