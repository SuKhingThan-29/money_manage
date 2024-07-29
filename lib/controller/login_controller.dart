import 'dart:convert';
import 'package:AthaPyar/athabyar_api/AthaByarApi.dart';
import 'package:AthaPyar/athabyar_api/download_upload_all.dart';
import 'package:AthaPyar/athabyar_api/request_response_api.dart';
import 'package:AthaPyar/athabyar_api/request_response_model.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/models/LanguageChange.dart';
import 'package:AthaPyar/screen/login_screen/otp_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../screen/home_screen/home.dart';

class LoginController extends GetxController{
  bool isLogin=false;
  bool isRegister=false;
  bool isForgetPassword=false;
  bool isConfirmPassword=false;
  bool isOtpResponse=false;
  late bool _isForgetPassword;
  bool invalidateConfirmPassword=false;
  bool invalidatePassword=false;
  String saveLogin='Login';
  bool isValid=true;
  String profileID="";
  TextEditingController phoneNoController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController confirmPasswordController=TextEditingController();
   late CountdownTimerController countdownTimerController;
  SharedPreferences? preferences;
  var isLoading = true.obs;
   LanguageChange? languageChange;


  @override
  void onInit(){
    super.onInit();
    init();
  }
  @override
  void dispose(){
    super.dispose();

  }
  void setForgetPassword(bool isFPassword){
    _isForgetPassword=isFPassword;
    isForgetPassword=_isForgetPassword;
    if(isForgetPassword){
      saveLogin='Forget Password';
    }
    update();
  }
  void setRegister(bool register){
   isRegister=register;
   if(isRegister){
     saveLogin='Login';
   }

    update();
  }
  void init()async{
    languageChange=LanguageChange.items[0];
    preferences = await SharedPreferences.getInstance();
    isLogin=false;
    try {
      isLogin=await preferences!.getBool(LoginSuccess)!;
    } catch (e) {
      print(e);
    }
    isRegister=false;
    if(isForgetPassword){
     saveLogin='Forget Password';
    }else if(isConfirmPassword){
      saveLogin='Reset Password';
    }else if(!isRegister){
      saveLogin='Sign Up';
    }else if(isRegister){
      saveLogin='Login';
    }
    update();
  }

  Future<bool> validate()async{
    if(passwordController.text.isEmpty && confirmPasswordController.text.isEmpty){
      invalidatePassword=true;
      invalidateConfirmPassword=true;
      update();
      return false;
    }else if(passwordController.text.isEmpty){
      invalidatePassword=true;
      update();
      return false;
    }else if(confirmPasswordController.text.isEmpty){
      invalidateConfirmPassword=true;
      update();
      return false;
    }else if(passwordController.text!=confirmPasswordController.text){
      invalidatePassword=true;
      invalidateConfirmPassword=true;
      update();
      return false;
    }else{
      invalidateConfirmPassword=false;
      invalidatePassword=false;
    }
    update();
    return true;
  }
  Future<bool> login(String phoneNo,String password,BuildContext context,String? deviceId,String code)async{
  isLoading(false);
    bool isLogin=await RequestResponseApi.requestLogin(phoneNo,password,context,deviceId!,code);
    debugPrint('IsLogin deviceID: $isLogin');
    if(isLogin){
      try {
        var isProfile= await DownloadUploadAll.downloadProfile();
      } catch (e) {
        print(e);
      }
      try {
        var isDaily=await DownloadUploadAll.downloadDaily();
      } catch (e) {
        print(e);
      }
      try {
        var isAccountGroup=await DownloadUploadAll.downloadAccountGroup(code);
      } catch (e) {
        print(e);
      }
      try {
        var isAccount=await DownloadUploadAll.downloadAccount(code);
      } catch (e) {
        print(e);
      }
      try {
        var isCategory=await DownloadUploadAll.downloadCategory();
      } catch (e) {
        print(e);
      }
      try {
        // var isAccountSummary=await DownloadUploadAll.downloadAccountSummary();
        // debugPrint('IsLogin AccountSummary: $isAccountSummary');
        var isMonthlySummary=await DownloadUploadAll.downloadMonthlySummary();
      } catch (e) {
        print(e);
      }
      Get.off(()=> HomeScreen(selectedMenu: 'calendar',showInterstitial:true));

      try {
        await DownloadUploadAll.downloadTermAndCondition();
      } catch (e) {
        print(e);
      }
      try {
        await DownloadUploadAll.downloadAboutUs();
      } catch (e) {
        print(e);
      }
      try {
        await DownloadUploadAll.downloadGold();
      } catch (e) {
        print(e);
      }
      update();

   }else{
      isLogin=false;
    }
  isLoading(true);
    update();
  return true;
  }
  Future<void> forgetResetPassword(String phoneNo,String password,BuildContext context,String code)async{
  await RequestResponseApi.forgetResetPassword(phoneNo,password,context,code);
  isLoading(true);
    update();
  }
  Future<void> signupResetPassword(String phoneNo,String password,BuildContext context,String code)async{
    await RequestResponseApi.signupResetPassword(phoneNo,password,context,code);
    isLoading(true);
    update();
  }
  Future<void> verifyOTP(String otp,BuildContext context,String code)async{
    await RequestResponseApi.requestVerifyOTP(otp,context,code);
    isLoading(true);
    update();

  }
  Future<void> forgetPasswordverifyOTP(String otp,String phoneNo,BuildContext context,String code)async{
    await RequestResponseApi.requestForgetPasswordVerifyOTP(otp,phoneNo,context,code);
    isLoading(true);
    update();

  }
  Future<void> requestSMS(String phoneNo,BuildContext context,String code)async{
    String mUrl=requestSMSApi;
    if(code==cambodiaCode){
      mUrl=requestSMS_Cambodia_Api;
    }
    RequestSmsOTP smsOTP = RequestSmsOTP(to: code+phoneNo, message: 'Welcome to DKMads, Now Your OTP code is ....', sender: 'DKMads');
    var response = await http.post(Uri.parse(mUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization':'Bearer $token',
        },
        body: jsonEncode(smsOTP.toJson()));

    if(response.statusCode == 200){
      ResponseSms registerObj=ResponseSms.fromJson(jsonDecode(response.body));
      print('isRegister Cambodia: ${registerObj.register}');
       if(registerObj.register=='true'){
         ConstantUtils.showAlertDialog(context,loginMessage);
         isRegister=true;
       }else{
         Get.off(()=>OTPScreen(code: code,));
       }

    }else{
      isLogin=false;
      preferences!.setBool(LoginSuccess, isLogin);
  }
    isLoading(true);
    update();
  }
  Future<void> requestForgetPasswordSMS(String phoneNo,BuildContext context,String code)async{
    await RequestResponseApi.requestForgetPasswordSMS(phoneNo,context,code);
    isLoading(true);
    update();
  }

}