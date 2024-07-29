import 'dart:convert';
import 'package:AthaPyar/athabyar_api/AthaByarApi.dart';
import 'package:AthaPyar/datatbase/model/tbl_profile.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/screen/home_screen/home.dart';
import 'package:AthaPyar/services/setting_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SettingController extends GetxController{

  TextEditingController fullNameController=TextEditingController();
  TextEditingController userNameController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController confirmPasswordController=TextEditingController();
  TextEditingController emailAddressController=TextEditingController();
  TextEditingController phoneNoController=TextEditingController();
  TextEditingController dateController=TextEditingController();
  TextEditingController yearController=TextEditingController();
  bool invalidateFullName=false;
  bool invalidateUserName=false;
  bool invalidatePassword=false;
  bool invalidateConfirmPassword=false;
  bool invalidatePhoneNumber=false;
  bool invalidateDate=false;
  bool invalidateYear=false;
  String validatePasswordText='Please fill the password';
  String saveButton='Save';
  String? urlImageEncode='';
  String? dropdownvalue = 'January';
  late String gender='Male';
  late String _userName='';
  String get userName => this._userName;

  var profileTab = false;
// List of items in our dropdown menu
  var items = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  var adsLoading = true.obs;
  //List<AdsData> allTodos = [];
  bool isInternet=false;
  @override
  void onInit(){
    super.onInit();
    init();
  }
  int mCount50=0;

  void init()async {
    SharedPreferences pref=await SharedPreferences.getInstance();
    var createdBy=pref.getString(mProfileId);
    var phoneNumber=pref.getString(mPhoneNumber).toString();
    phoneNoController.text=phoneNumber;
    debugPrint('Profile logout: ${phoneNoController.text}');

    var list=await SettingService.getProfile(createdBy.toString());
    debugPrint('ProfileList: ${list.length}');
    try {
      if(list.length>0){
            var profile=list[0];
            fullNameController.text=profile.full_name;
            userNameController.text=profile.user_name;
            //passwordController.text=profile.password;
            emailAddressController.text=profile.email_address;
            phoneNoController.text=profile.phone_no;
            //confirmPasswordController.text=profile.password;
            urlImageEncode=profile.image;
            if(profile.gender!=null && profile.gender.isNotEmpty){
              gender=profile.gender;
            }else{
              gender='Male';
            }
            if(profile.full_name!=null && profile.full_name.isNotEmpty){
              _userName=profile.full_name;
            }else{
              _userName='';
            }

            dateController.text=profile.dob.split('-')[0];
            var mdropdownValue=profile.dob.split('-')[1];
            yearController.text=profile.dob.split('-')[2];
            for(var i in items){
              if(i==mdropdownValue){
                dropdownvalue=i;
              }

            }
            saveButton='Update';
            update();
          }else{
        gender='Male';
        fullNameController.clear();
        userNameController.clear();
        passwordController.clear();
        emailAddressController.clear();
        confirmPasswordController.clear();
        urlImageEncode='';
        dateController.clear();
        yearController.clear();
        saveButton='Save';
        dropdownvalue = 'January';
        update();

      }
    } catch (e) {
      print(e);
    }
    update();

  }
  Future<void> saveProfile(BuildContext context,String month,String gender,String image)async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    var profileId=pref.getString(mProfileId);
    bool isValid=await validate();
    if(isValid && month.isNotEmpty && gender.isNotEmpty){
      profileTab=false;
      var dob=dateController.text+'-'+month+'-'+yearController.text;
      var util=ConstantUtils();
      var _isInternet=await util.isInternet();

    TBLProfile profile=TBLProfile(id: profileId.toString(), full_name: fullNameController.text, user_name: userNameController.text, password: passwordController.text, email_address: emailAddressController.text, phone_no: phoneNoController.text, image: image, dob: dob, gender: gender, createdAt: DateTime.now().toString(), createdBy: profileId.toString(), updatedAt:  DateTime.now().toString(), updatedBy: profileId.toString());
      await SettingService.saveProfile(profile);
      if(_isInternet){
        var response;
        response = await http.post(Uri.parse(requestProfileApi),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(profile.toJson()));
        debugPrint('Response Profile json: ${jsonEncode(profile.toJson())}');

        if(response.statusCode == 200){
          saveButton='Update';
          Get.off(()=>HomeScreen(selectedMenu: 'calendar', showInterstitial: false));
        }else{
          profileTab=true;
          ConstantUtils.showAlertDialog(context, 'Your profile cannot be upload. Thanks');
        }
      }else{
        Get.off(()=>HomeScreen(selectedMenu: 'calendar', showInterstitial: false));
      }

    }else{
      profileTab=true;
    }
    update();
  }
  Future<bool> validate()async{
    if(fullNameController.text.isEmpty){
      invalidateFullName=true;
      return false;
    }else{
      invalidateFullName=false;
    }
    if(userNameController.text.isEmpty){
      invalidateUserName=true;
      return false;
    }else{
      invalidateUserName=false;
    }
    if(passwordController.text.isEmpty){
      invalidatePassword=true;
      return false;
    }else{
      invalidatePassword=false;
    }
    if(confirmPasswordController.text.isEmpty){
      invalidateConfirmPassword=true;
      return false;
    }else{
      invalidateConfirmPassword=false;
    }

    if(phoneNoController.text.isEmpty){
      invalidatePhoneNumber=true;
      return false;
    }else{
      invalidatePhoneNumber=false;
    }
    if(dateController.text.isEmpty){
      invalidateDate=true;
      return false;
    }else{
      invalidateDate=false;
    }
    if(yearController.text.isEmpty){
      invalidateYear=true;
      return false;
    }else{
      invalidateYear=false;
    }
    if(passwordController.text!=confirmPasswordController.text){
      validatePasswordText='Password did not match';
      invalidatePassword=true;
      return false;

    }else{
      validatePasswordText='';
      invalidatePassword=false;
    }
    update();
    return true;
  }
}