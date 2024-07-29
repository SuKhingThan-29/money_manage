import 'package:AthaPyar/controller/login_controller.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/screen/login_screen/signup.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordReset extends StatefulWidget {
  String phoneNo;
  String code;
   ForgotPasswordReset({required this.phoneNo,required this.code,Key? key}) : super(key: key);

  @override
  _ForgotPasswordLogin createState() => _ForgotPasswordLogin(phoneNo:phoneNo,code:code);
}

class _ForgotPasswordLogin extends State<ForgotPasswordReset> {
  String phoneNo;
  String code;
  _ForgotPasswordLogin({required this.phoneNo,required this.code});
  LoginController loginController = Get.put(LoginController());
  bool isInvalidPassword=false;
  bool isInvalidConfirmPassword=false;
  bool isPhoneNo=false;

  @override
  void initState() {
    super.initState();
    loginController.isRegister=false;
    loginController.phoneNoController.clear();
    loginController.passwordController.clear();
    loginController.confirmPasswordController.clear();
    _sendAnalyticsEvent(password_reset);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
    //  backgroundColor: themeColor,
      body: SafeArea(
          child: GetBuilder<LoginController>(
        init: LoginController(),
        builder: (value) {
          return value.isLoading.isTrue?SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child:Container(
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
                             'Create New Password'.tr,
                             style: TextStyle(color: Colors.black, fontSize: 22,fontWeight: FontWeight.bold),
                           ),
                           Text(
                             "Your new password must be different".tr,
                             style: TextStyle(color: Colors.grey, fontSize: 12),
                           ),
                           Text(
                             "from previous used password".tr,
                             style: TextStyle(color: Colors.grey, fontSize: 12),
                           ),
                           Padding(
                             padding: const EdgeInsets.only(
                                 left: 30, right: 30, bottom: 10, top: 30),
                             child: Center(
                               child: TextField(
                                 obscureText: true,

                                 controller: value.passwordController,
                                 onChanged: (passwordValue){
                                   setState(() {
                                     if(passwordValue.isNotEmpty){
                                       isInvalidPassword=false;
                                     }
                                   });
                                 },
                                 decoration: InputDecoration(
                                     errorText: isInvalidPassword?'Please insert your new password':null,
                                     errorBorder: OutlineInputBorder(
                                         borderSide: BorderSide(color: lightGrey,width: 3.0),
                                         borderRadius: BorderRadius.circular(35)
                                     ),
                                     filled: true,
                                     fillColor: lightGrey,
                                     hintText: 'New Password'.tr,
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
                           Padding(
                             padding: const EdgeInsets.only(
                                 left: 30, right: 30, bottom: 10, top: 10),
                             child:Center(
                               child: TextField(
                                 obscureText: true,
                                 controller: value.confirmPasswordController,
                                 onChanged: (passwordValue){
                                   setState(() {
                                     if(passwordValue.isNotEmpty){
                                       isInvalidConfirmPassword=false;
                                     }
                                   });
                                 },
                                 decoration: InputDecoration(
                                     errorText: isInvalidConfirmPassword?'Please insert your confirm password':null,
                                     errorBorder: OutlineInputBorder(
                                         borderSide: BorderSide(color: lightGrey,width: 3.0),
                                         borderRadius: BorderRadius.circular(35)
                                     ),
                                     filled: true,
                                     fillColor: lightGrey,
                                     hintText: 'Confirm Password'.tr,
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
                           FractionallySizedBox(
                             widthFactor: 0.5,
                             child: RaisedButton(
                                 onPressed: () async {
                                   if( value.passwordController.text.isEmpty || value.confirmPasswordController.text.isEmpty){
                                     setState(() {
                                       value.passwordController.text.isEmpty?isInvalidPassword=true:isInvalidPassword=false;
                                       value.confirmPasswordController.text.isEmpty?isInvalidConfirmPassword=true:isInvalidConfirmPassword=false;
                                     });

                                   }else if(value.passwordController.text!=value.confirmPasswordController.text){
                                     setState(() {
                                       isInvalidPassword=true;
                                       isInvalidConfirmPassword=true;
                                     });
                                   }
                                   else{
                                     ConstantUtils util = ConstantUtils();
                                     var _isInternet = await util.isInternet();
                                     if (_isInternet) {
                                       if(code==cambodiaCode){
                                         value.forgetResetPassword(phoneNo,value.passwordController.text,context,cambodiaCode);
                                       }else{
                                         value.forgetResetPassword(phoneNo,value.passwordController.text,context,myanmarCode);

                                       }

                                     } else {
                                       ConstantUtils.showAlertDialog(context,internetConnectionStatus);
                                     }
                                   }

                                 },
                                 color: Colors.white,
                                 textColor: Colors.black,
                                 shape: StadiumBorder(
                                     side: BorderSide(color: themeColor, width: 1)),
                                 child: Text('Login'.tr)),
                           ),
                           SizedBox(height: 10,),
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
                     )

                    ],
                  ),
                )),
          ):Center(
            child: CircularProgressIndicator(),
          );
        },
      )),
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
