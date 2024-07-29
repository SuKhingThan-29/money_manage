import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:AthaPyar/athabyar_api/download_upload_all.dart';
import 'package:AthaPyar/componenets/about_us_dialog.dart';
import 'package:AthaPyar/componenets/custom_ads.dart';
import 'package:AthaPyar/componenets/tern_and_condition_dialog.dart';
import 'package:AthaPyar/controller/setting_controller.dart';
import 'package:AthaPyar/helper/size_config.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/screen/home_screen/home.dart';
import 'package:AthaPyar/screen/login_screen/login.dart';
import 'package:AthaPyar/services/setting_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:AthaPyar/services/localization_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPage createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage>
    with SingleTickerProviderStateMixin {
  late String _selectedLang;
  SettingController _settingController = Get.put(SettingController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late var languageTab = false;
  late var styleTab = false;
  late var contactUsTab = false;
  late int _radioValue = 0;
  late int _langValue = 0;
  late bool isSwitched = false;
  late String mGender='Male';
  final maxLines = 5;
  String version='';
// Initial Selected Value
  SharedPreferences? preferences;
  final _picker = ImagePicker();
  File? _image;
  var isLoading=false;
  String location ='Null, Press Button';
  String countryCode = '';


  void _handleRadioValueChange(int? value) {
    setState(() {
      _radioValue = value!;
      switch (_radioValue) {
        case 0:
          mGender='Male';
          break;
        case 1:
          mGender='Female';
          break;
        case 2:
          mGender='Other';
          break;
      }
    });
  }

  void _handleLangValueChange(int? value) async {
      _langValue = value!;
      switch (_langValue) {
        case 0:
          _selectedLang = LocalizationService.langs.first;
          LocalizationService().changeLocale(_selectedLang);
          preferences!.setString(Lang, _selectedLang);
          _sendAnalyticsEvent(language_change_event);

          break;
        case 1:
          _selectedLang = LocalizationService.langs.last;
          LocalizationService().changeLocale(_selectedLang);
          preferences!.setString(Lang, _selectedLang);
          _sendAnalyticsEvent(language_myanmar_event);
          break;
        case 2:
          break;
      }
  }

  Uint8List decodeImage(String img64) {
    return base64Decode(img64);
  }

  _imgFromCamera() async {
    PickedFile? image =
    await _picker.getImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      final File file = File(image!.path);
      _image = file;
      _settingController.urlImageEncode = encodeImg(_image);
      // _settingController.saveProfile(context,
      //     _settingController.dropdownvalue!,
      //     mGender,
      //     _settingController.urlImageEncode
      //         .toString());

    });
  }

  _imgFromGallery() async {
    PickedFile? image =
    await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      final File file = File(image!.path);
      _image = file;
      _settingController.urlImageEncode = encodeImg(_image);
      // _settingController.saveProfile(context,
      //     _settingController.dropdownvalue!,
      //     mGender,
      //     _settingController.urlImageEncode
      //         .toString());
    });
  }

  String encodeImg(File? image) {
    final bytes = image!.readAsBytesSync();
    String img64 = base64Encode(bytes);
    return img64;
  }

  void _showPicker(context) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext bc) {
          return CupertinoActionSheet(
            actions: <Widget>[
              new Wrap(
                children: <Widget>[
                  CupertinoActionSheetAction(onPressed: (){
                    _imgFromCamera();
                    Navigator.of(context).pop();

                  }, child: Container(
                    alignment: Alignment.centerLeft,
                    child: new Text('Camera'.tr,style: TextStyle(color:ConstantUtils.isDarkMode?dark_font_grey_color:Colors.black,fontSize: 14),),
                  ),
                  ),
                  Divider(height: 1, color: ConstantUtils.isDarkMode?dark_nav_color:Colors.grey,
                  ),
                  CupertinoActionSheetAction(onPressed: (){
                    _imgFromGallery();
                    Navigator.of(context).pop();

                  }, child:  Container(
                    alignment: Alignment.centerLeft,
                    child: new Text('Gallery'.tr,style: TextStyle(color:ConstantUtils.isDarkMode?dark_font_grey_color:Colors.black,fontSize: 14),),
                  ),
                  ),


                ],
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              child:   Container(
                alignment: Alignment.center,
                child: new Text('Cancel'.tr,style: TextStyle(color:ConstantUtils.isDarkMode?dark_font_grey_color:Colors.black,fontSize: 16),),
              ),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
            ),
          );
        });
  }

  Future<void> init() async {
    SharedPreferences pref=await SharedPreferences.getInstance();
    String code=myanmarCode;
    if(pref.getString(selected_country)!=null){
      code=await pref.getString(selected_country).toString();
    }
    if(code==myanmarCode){
      try {
        Position position = await ConstantUtils.getGeoLocationPosition();
        countryCode=await ConstantUtils.GetAddressFromLatLong(position);
      } catch (e) {
        print(e);
      }
    }


    final info = await PackageInfo.fromPlatform();

    setState(() {
      _packageInfo = info;
    });
    _settingController.fullNameController.clear();
    _settingController.userNameController.clear();
    _settingController.passwordController.clear();
    _settingController.emailAddressController.clear();
    _settingController.confirmPasswordController.clear();
    _settingController.urlImageEncode='';
    _settingController.dateController.clear();
    _settingController.yearController.clear();
    _settingController.saveButton='Save';
    _settingController.dropdownvalue = 'January';


    var createdBy=pref.getString(mProfileId);

    var list=await SettingService.getProfile(createdBy.toString());
      preferences = await SharedPreferences.getInstance();
      if(list.length>0){
        if(list[0].gender !=null && list[0].gender.isNotEmpty){
          mGender=list[0].gender;
        }else{
          mGender='Male';
        }
      }

      switch (mGender) {
        case 'Male':
          _radioValue = 0;
          break;
        case 'Female':
          _radioValue = 1;
          break;
        case 'Other':
          _radioValue = 2;
          break;
      }

      try {
        SharedPreferences pref = await SharedPreferences.getInstance();

        var lang = preferences!.getString(Lang);
        try {
          _selectedLang=(await pref.getString(Lang))!;
          LocalizationService().changeLocale(_selectedLang);
          pref.setString(Lang, _selectedLang);
          if(_selectedLang=='Myanmar'){
            _langValue=1;
          }else{
            _langValue = 0;
          }

        } catch (e) {
          print(e);
        }


        if (_langValue == 0) {
          _selectedLang = LocalizationService.langs.first;
          LocalizationService().changeLocale(_selectedLang);
        } else {
          _selectedLang = LocalizationService.langs.last;
          LocalizationService().changeLocale(_selectedLang);
        }
        bool? isStyle = preferences!.getBool(is_Switch);
        if (isStyle!) {
          isSwitched = true;
          ConstantUtils.isDarkMode=true;
        } else {
          isSwitched = false;
          ConstantUtils.isDarkMode=false;

        }
      } catch (e) {
        print(e);
      }

  }




  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );
  @override
  void initState() {
    _settingController.onInit();
    _settingController.gender='Male';
    _sendAnalyticsEvent(setting_screen);


    init();
    super.initState();
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
  @override
  void dispose(){
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ConstantUtils.isDarkMode?dark_background_color:themeColor,
        body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(ConstantUtils.isDarkMode?"assets/images/dark_curve.png":"assets/images/background_curve.png"),
                              fit: BoxFit.cover)
                      ),
                      child: isLoading?Center(child: CircularProgressIndicator(),):Column(
                        children: [
                          InkWell(
                              onTap: () {
                                Get.off(() => HomeScreen(
                                  selectedMenu: 'calendar', showInterstitial: false
                                ));
                              },
                              child:Padding(
                                padding: EdgeInsets.only(top: 25),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                        height: 25,
                                        child: SvgPicture.asset(
                                            'assets/settings/on_back.svg')),
                                    Spacer(),
                                    Text(
                                      'Setting'.tr,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 25,
                                      child: SvgPicture.asset(
                                          'assets/settings/setting.svg'),
                                    ),
                                  ],
                                ),
                              )
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: Card(
                                  color: ConstantUtils.isDarkMode?dark_nav_color:Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20)
                                      )),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        GetBuilder<SettingController>(
                                          init: SettingController(),
                                          builder: (value) {
                                            return value.profileTab
                                                ?  Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              width: 1.0,
                                                              color:
                                                              ConstantUtils.isDarkMode?dark_border_color:light_border_color))),
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            _showPicker(
                                                                context);
                                                          });
                                                        },
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle),
                                                              width: 50,
                                                              height: 50,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                  right:
                                                                  10),
                                                              child: (value.urlImageEncode ==
                                                                  null ||
                                                                  value
                                                                      .urlImageEncode!
                                                                      .isEmpty)
                                                                  ? SvgPicture
                                                                  .asset(
                                                                  'assets/settings/profile.svg')
                                                                  : ClipRRect(
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    50),
                                                                child: Image
                                                                    .memory(
                                                                  decodeImage(value
                                                                      .urlImageEncode
                                                                      .toString()),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              bottom: 1,
                                                              right: 5,
                                                              child: Container(
                                                                width: 20,
                                                                height: 20,
                                                                child: SvgPicture
                                                                    .asset(
                                                                    'assets/settings/profile/profile_group.svg'),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                          onTap: () {
                                                            setState(()async {

                                                              ConstantUtils utils=ConstantUtils();
                                                              bool isInternet=await utils.isInternet();
                                                              if(isInternet){
                                                                DownloadUploadAll.downloadProfile();

                                                              }
                                                              if (value
                                                                  .profileTab) {

                                                                value.profileTab =
                                                                false;
                                                              } else {
                                                                value.profileTab =
                                                                true;
                                                              }
                                                            });
                                                          },
                                                          child: Container(
                                                            width:
                                                            getProportionateScreenWidth(
                                                                200),
                                                            child: Text(value.userName!=null && value.userName.isNotEmpty?value.userName:
                                                            'Profile'.tr,
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  color: ConstantUtils.isDarkMode?dark_background_color:light_background_color,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        padding:EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                            border: Border(
                                                                bottom: BorderSide(
                                                                    width: 1.0,
                                                                    color:
                                                                    ConstantUtils.isDarkMode?dark_nav_color:underLineGreyColor
                                                                )
                                                            )),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                          Container(
                                                          width: setting_icon_size,
                                                          margin: EdgeInsets.only(
                                                              right: 10,
                                                             ),
                                                          child: SvgPicture.asset(
                                                              'assets/settings/profile/name.svg'),
                                                        ),
                                                            Container(
                                                            width:setting_label_width,
                                                              child:
                                                              Text(
                                                                'Full Name'.tr,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                    color: fontGreyColor,
                                                                    fontSize: label_text_size),
                                                              ),
                                                            ),
                                                            Flexible(
                                                                flex:4,
                                                                child:
                                                                Container(
                                                                  height: 55,
                                                                  child: TextFormField(
                                                                    maxLines: 1,
                                                                    keyboardType: TextInputType.multiline,
                                                                    controller: value
                                                                        .fullNameController,
                                                                    onChanged: (mChangeValue){
                                                                      setState(() {
                                                                        if(mChangeValue.isNotEmpty){
                                                                          value.invalidateFullName=false;

                                                                        }
                                                                      });
                                                                    },
                                                                    style: TextStyle(color: ConstantUtils.isDarkMode?dark_font_grey_color:Colors.black),
                                                                    decoration: InputDecoration(
                                                                        errorText: value
                                                                            .invalidateFullName
                                                                            ? 'Please fill the Full Name '
                                                                            : null,

                                                                        fillColor: ConstantUtils.isDarkMode?dark_nav_color:lightWhiteBackgroundColor,
                                                                        filled: true,
                                                                        focusedBorder:OutlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                color:
                                                                                lightGrey,
                                                                                width:
                                                                                1.0),
                                                                            borderRadius:
                                                                            BorderRadius.circular(
                                                                                15)),
                                                                        enabledBorder: OutlineInputBorder(
                                                                            borderSide:
                                                                            BorderSide(
                                                                                color:
                                                                                lightGrey,
                                                                                width:
                                                                                2.0),
                                                                            borderRadius:
                                                                            BorderRadius
                                                                                .circular(
                                                                                border_radius))),
                                                                  )
                                                                )
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                            border: Border(
                                                                bottom: BorderSide(
                                                                    width: 1.0,
                                                                    color:
                                                                    ConstantUtils.isDarkMode?dark_nav_color:underLineGreyColor
                                                                ))),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,

                                                          children: [
                                                            Container(
                                                             width:setting_icon_size,
                                                              margin: EdgeInsets.only(
                                                                right: 10,
                                                              ),
                                                              child: SvgPicture.asset(
                                                                  'assets/settings/profile/user_name.svg'),
                                                            ),

                                                            Container(
                                                              width:setting_label_width,
                                                              child: Text(
                                                                'User Name'.tr,
                                                                style: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: label_text_size),
                                                              ),
                                                            ),
                                                            Flexible(
                                                                flex: 4,
                                                                child: TextFormField(
                                                                  onChanged: (mChangeValue){
                                                                    setState(() {
                                                                      if(mChangeValue.isNotEmpty){
                                                                        value.invalidateUserName=false;

                                                                      }
                                                                    });
                                                                  },
                                                                  controller: value
                                                                      .userNameController,
                                                                  style: TextStyle(color: ConstantUtils.isDarkMode?dark_font_grey_color:Colors.black),

                                                                  decoration: InputDecoration(
                                                                      errorText: value
                                                                          .invalidateUserName
                                                                          ? 'Please fill the User Name '
                                                                          : null,
                                                                      fillColor:  ConstantUtils.isDarkMode?dark_nav_color:lightWhiteBackgroundColor,
                                                                      filled: true,
                                                                      focusedBorder:OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                            color:
                                            lightGrey,
                                            width:
                                            1.0),
                                            borderRadius:
                                            BorderRadius.circular(
                                            15)),
                                                                      enabledBorder: OutlineInputBorder(
                                                                          borderSide:
                                                                          BorderSide(
                                                                              color:
                                                                              lightGrey,
                                                                              width:
                                                                              2.0),
                                                                          borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                              border_radius))),
                                                                )
                                                            )

                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 0),

                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Container(
                                                              width: setting_icon_size,
                                                              margin: EdgeInsets.only(right: 10),
                                                              child: SvgPicture.asset(
                                                                  'assets/settings/profile/ic_password.svg'),
                                                            ),
                                                            Container(
                                                              width: setting_label_width,
                                                              child:  Text(
                                                                'Password'.tr,
                                                                style: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: label_text_size),
                                                              ),
                                                            ),
                                                            Flexible(
                                                              flex: 4,
                                                              child: SizedBox(
                                                                height: 55,
                                                                child: TextField(
                                                                  inputFormatters: [
                                                                    LengthLimitingTextInputFormatter(
                                                                        15),
                                                                  ],
                                                                  obscureText: true,
                                                                  decoration: InputDecoration(
                                                                      errorText: value
                                                                          .invalidatePassword
                                                                          ? value
                                                                          .validatePasswordText
                                                                          : null,
                                                                      filled: true,
                                                                      fillColor:
                                                                      ConstantUtils.isDarkMode?dark_nav_color:lightWhiteBackgroundColor,
                                                                      focusedBorder:OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              color:
                                                                              lightGrey,
                                                                              width:
                                                                              1.0),
                                                                          borderRadius:
                                                                          BorderRadius.circular(
                                                                              15)),
                                                                      enabledBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              color:
                                                                              lightGrey,
                                                                              width:
                                                                              1.0),
                                                                          borderRadius:
                                                                          BorderRadius.circular(
                                                                              15))),
                                                                  controller: value
                                                                      .passwordController,
                                                                  onChanged: (mChangeValue){
                                                                    setState(() {
                                                                      if(mChangeValue.isNotEmpty){
                                                                        value.invalidatePassword=false;

                                                                      }
                                                                    });
                                                                  },
                                                                  style: TextStyle(color: ConstantUtils.isDarkMode?dark_font_grey_color:Colors.black),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                            border: Border(
                                                                bottom: BorderSide(
                                                                    width: 1.0,
                                                                    color:
                                                                    ConstantUtils.isDarkMode?dark_nav_color:underLineGreyColor
                                                                ))),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Container(
                                                              width:110,
                                                              child:  Text(
                                                                'Confirm Password'.tr,
                                                                style: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: label_text_size),
                                                              ),
                                                            ),
                                                            Flexible(
                                                              flex: 4,
                                                              child: SizedBox(
                                                                height: 55,
                                                                child: TextField(
                                                                  inputFormatters: [
                                                                    LengthLimitingTextInputFormatter(
                                                                        15),
                                                                  ],
                                                                  obscureText: true,
                                                                  decoration: InputDecoration(
                                                                      errorText: value
                                                                          .invalidateConfirmPassword
                                                                          ? 'Please fill the confirmPassword'
                                                                          : null,
                                                                      fillColor:
                                                                      ConstantUtils.isDarkMode?dark_nav_color:lightWhiteBackgroundColor,
                                                                      filled: true,
                                                                      focusedBorder:OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              color:
                                                                              lightGrey,
                                                                              width:
                                                                              1.0),
                                                                          borderRadius:
                                                                          BorderRadius.circular(
                                                                              15)),
                                                                      enabledBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              color:
                                                                              lightGrey,
                                                                              width:
                                                                              1.0),
                                                                          borderRadius:
                                                                          BorderRadius.circular(
                                                                              15))),
                                                                  controller: value
                                                                      .confirmPasswordController,
                                                                  onChanged: (mChangeValue){
                                                                    setState(() {
                                                                      if(mChangeValue.isNotEmpty){
                                                                        value.invalidateConfirmPassword=false;

                                                                      }
                                                                    });
                                                                  },
                                                                  style: TextStyle(color: ConstantUtils.isDarkMode?dark_font_grey_color:Colors.black),
                                                                ),
                                                              ),
                                                            ),
                                                            // Column(
                                                            //   crossAxisAlignment:
                                                            //   CrossAxisAlignment
                                                            //       .start,
                                                            //   children: [
                                                            //     Container(
                                                            //       margin:
                                                            //       EdgeInsets.only(
                                                            //           left: 10),
                                                            //       width:
                                                            //       getProportionateScreenWidth(
                                                            //           180),
                                                            //       height: getProportionateScreenHeight(
                                                            //           value.invalidatePassword
                                                            //               ? 50
                                                            //               : 30),
                                                            //       child: TextField(
                                                            //         inputFormatters: [
                                                            //           LengthLimitingTextInputFormatter(
                                                            //               15),
                                                            //         ],
                                                            //         obscureText: true,
                                                            //         decoration: InputDecoration(
                                                            //             errorText: value
                                                            //                 .invalidatePassword
                                                            //                 ? value
                                                            //                 .validatePasswordText
                                                            //                 : null,
                                                            //             fillColor:
                                                            //             ConstantUtils.isDarkMode?dark_nav_color:lightGreyBackgroundColor,
                                                            //             filled: true,
                                                            //             enabledBorder: OutlineInputBorder(
                                                            //                 borderSide: BorderSide(
                                                            //                     color:
                                                            //                     lightGrey,
                                                            //                     width:
                                                            //                     1.0),
                                                            //                 borderRadius:
                                                            //                 BorderRadius.circular(
                                                            //                     15))),
                                                            //         controller: value
                                                            //             .passwordController,
                                                            //         onChanged: (mChangeValue){
                                                            //           setState(() {
                                                            //             if(mChangeValue.isNotEmpty){
                                                            //               value.invalidatePassword=false;
                                                            //
                                                            //             }
                                                            //           });
                                                            //         },
                                                            //         style: TextStyle(color: ConstantUtils.isDarkMode?dark_font_grey_color:Colors.black),
                                                            //       ),
                                                            //     ),
                                                            //     Container(
                                                            //       margin:
                                                            //       EdgeInsets.only(
                                                            //           left: 15,top: 2,bottom: 2),
                                                            //       child: Text(
                                                            //         'Confirm Passwords'.tr,
                                                            //         style: TextStyle(
                                                            //             color:
                                                            //             Colors.grey,
                                                            //             fontSize: 8),
                                                            //       ),
                                                            //     ),
                                                            //     Container(
                                                            //       margin:
                                                            //       EdgeInsets.only(
                                                            //           left: 10),
                                                            //       width:
                                                            //       getProportionateScreenWidth(
                                                            //           180),
                                                            //       height: getProportionateScreenHeight(
                                                            //           value.invalidateConfirmPassword
                                                            //               ? 50
                                                            //               : 30),
                                                            //       child: TextField(
                                                            //         obscureText: true,
                                                            //         style: TextStyle(color: ConstantUtils.isDarkMode?dark_font_grey_color:Colors.black),
                                                            //
                                                            //         inputFormatters: [
                                                            //           LengthLimitingTextInputFormatter(
                                                            //               15),
                                                            //         ],
                                                            //
                                                            //         decoration: InputDecoration(
                                                            //             errorText: value
                                                            //                 .invalidateConfirmPassword
                                                            //                 ? 'Please fill the confirmPassword'
                                                            //                 : null,
                                                            //             fillColor:
                                                            //             ConstantUtils.isDarkMode?dark_nav_color:lightGreyBackgroundColor,
                                                            //             filled: true,
                                                            //             enabledBorder: OutlineInputBorder(
                                                            //                 borderSide: BorderSide(
                                                            //                     color:
                                                            //                     lightGrey,
                                                            //                     width:
                                                            //                     1.0),
                                                            //                 borderRadius:
                                                            //                 BorderRadius.circular(
                                                            //                     15))),
                                                            //         controller: value
                                                            //             .confirmPasswordController,
                                                            //         onChanged: (mChangeValue){
                                                            //          setState(() {
                                                            //            if(mChangeValue.isNotEmpty){
                                                            //              value.invalidateConfirmPassword=false;
                                                            //
                                                            //            }
                                                            //          });
                                                            //         },
                                                            //       ),
                                                            //     )
                                                            //   ],
                                                            // )
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                            border: Border(
                                                                bottom: BorderSide(
                                                                    width: 1.0,
                                                                    color:
                                                                    ConstantUtils.isDarkMode?dark_nav_color:underLineGreyColor
                                                                ))),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Container(
                                                              width: setting_icon_size,
                                                              margin: EdgeInsets.only(
                                                                  right: 10,),
                                                              child: SvgPicture.asset(
                                                                  'assets/settings/profile/email.svg'),
                                                            ),
                                                            Container(
                                                              width: setting_label_width,
                                                              child: Text(
                                                                'Email Address'.tr,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                    color: Colors.grey,
                                                                    fontSize: label_text_size),
                                                              ),
                                                            ),
                                                           Flexible(
                                                             flex: 4,
                                                             child: TextField(
                                                               style: TextStyle(color: ConstantUtils.isDarkMode?dark_font_grey_color:Colors.black),
                                                               decoration: InputDecoration(

                                                                   fillColor:  ConstantUtils.isDarkMode?dark_nav_color:lightWhiteBackgroundColor,
                                                                   filled: true,
                                                                   focusedBorder:OutlineInputBorder(
                                                                   borderSide:
                                            BorderSide(
                                            color:
                                            lightGrey,
                                            width:
                                            1.0),
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                            border_radius)),
                                                                   enabledBorder: OutlineInputBorder(
                                                                       borderSide:
                                                                       BorderSide(
                                                                           color:
                                                                           lightGrey,
                                                                           width:
                                                                           1.0),
                                                                       borderRadius:
                                                                       BorderRadius
                                                                           .circular(
                                                                           border_radius))
                                            ),
                                                               controller: value
                                                                   .emailAddressController,
                                                               onChanged: (mChangeValue){
                                                                 setState(() {

                                                                 });
                                                               },
                                                             ),
                                                           )
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                            border: Border(
                                                                bottom: BorderSide(
                                                                    width: 1.0,
                                                                    color:
                                                                    ConstantUtils.isDarkMode?dark_nav_color:underLineGreyColor
                                                                ))),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Container(
                                                              width: setting_icon_size,
                                                              margin: EdgeInsets.only(
                                                                  right: 10,
                                                             ),
                                                              child: SvgPicture.asset(
                                                                  'assets/settings/profile/phone.svg'),
                                                            ),
                                                            Container(
                                                              width: setting_label_width,
                                                              child: Text(
                                                                'Phone Number'.tr,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                    color: Colors.grey,
                                                                    fontSize: label_text_size),
                                                              ),
                                                            ),
                                                           Flexible(
                                                             flex: 4,
                                                               child: TextField(
                                                                 style: TextStyle(color: ConstantUtils.isDarkMode?dark_font_grey_color:Colors.black),
                                                                 inputFormatters: [
                                                                   LengthLimitingTextInputFormatter(
                                                                       15),
                                                                 ],
                                                                 keyboardType:
                                                                 TextInputType
                                                                     .phone,
                                                                 decoration: InputDecoration(
                                                                     errorText: value
                                                                         .invalidatePhoneNumber
                                                                         ? 'Please fill the phone number'
                                                                         : null,
                                                                     fillColor:  ConstantUtils.isDarkMode?dark_nav_color:lightWhiteBackgroundColor,
                                                                     filled: true,
                                                                     enabledBorder: OutlineInputBorder(
                                                                         borderSide:
                                                                         BorderSide(
                                                                             color:
                                                                             lightGrey,
                                                                             width:
                                                                             1.0),
                                                                         borderRadius:
                                                                         BorderRadius
                                                                             .circular(
                                                                             15))),
                                                                 controller: value
                                                                     .phoneNoController,
                                                                 onChanged: (mChangeValue){
                                                                   setState(() {
                                                                     if(mChangeValue.isNotEmpty){
                                                                       value.invalidatePhoneNumber=false;

                                                                     }
                                                                   });
                                                                 },
                                                               ),)
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                            border: Border(
                                                                bottom: BorderSide(
                                                                    width: 1.0,
                                                                    color:
                                                                    ConstantUtils.isDarkMode?dark_nav_color:underLineGreyColor
                                                                ))),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Container(
                                                              width: setting_icon_size,
                                                              margin: EdgeInsets.only(right: 5),
                                                              child: SvgPicture.asset(
                                                                  'assets/settings/profile/ic_date.svg'),
                                                            ),
                                                            Container(
                                                              width: setting_label_width,
                                                              child:  Text(
                                                                'Date of Birth'.tr,
                                                                style: TextStyle(
                                                                    color:
                                                                    Colors.grey,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: label_text_size),
                                                              ),
                                                            ),
                                                            Flexible(
                                                                child:
                                                                FractionallySizedBox(
                                                                  widthFactor: 0.7,
                                                                  child: Column(
                                                                    children: [
                                                                      Text(
                                                                        'Date'.tr,
                                                                        style: TextStyle(
                                                                            fontSize: label_text_size,
                                                                            color: Colors
                                                                                .grey),
                                                                      ),
                                                                      SizedBox(height: 5,),
                                                                      Container(
                                                                        height:30,
                                                                        child: TextField(
                                                                          style: TextStyle(color: ConstantUtils.isDarkMode?dark_font_grey_color:Colors.black),

                                                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(
                                                                              2),],
                                                                          keyboardType:
                                                                          TextInputType
                                                                              .number,
                                                                          decoration: InputDecoration(
                                                                              errorText: value
                                                                                  .invalidateDate
                                                                                  ? 'Please fill the date'
                                                                                  : null,
                                                                              fillColor:
                                                                              ConstantUtils.isDarkMode?dark_nav_color:lightWhiteBackgroundColor,
                                                                              filled:
                                                                              true,
                                                                              enabledBorder: OutlineInputBorder(
                                                                                  borderSide: BorderSide(
                                                                                      color:
                                                                                      lightGrey,
                                                                                      width:
                                                                                      1.0),
                                                                                  borderRadius:
                                                                                  BorderRadius.circular(10))),
                                                                          controller: value
                                                                              .dateController,
                                                                          onChanged: (mChangeValue){
                                                                            setState(() {
                                                                              if(mChangeValue.isNotEmpty){
                                                                                value.invalidateDate=false;

                                                                              }
                                                                            });
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )),
                                                            Flexible(
                                                                child:
                                                                FractionallySizedBox(
                                                                  widthFactor: 1.2,
                                                                  child: Column(
                                                                    children: [
                                                                      Text('Month'.tr,
                                                                          style: TextStyle(
                                                                              fontSize: label_text_size,
                                                                              color: Colors
                                                                                  .grey)),
                                                                      SizedBox(height: 5,),
                                                                      Container(
                                                                        height:30,
                                                                        decoration: BoxDecoration(
                                                                            color: ConstantUtils.isDarkMode?dark_nav_color:Colors.white,
                                                                            borderRadius:
                                                                            BorderRadius
                                                                                .circular(
                                                                                10),
                                                                            border: Border
                                                                                .all(
                                                                                color:
                                                                                Colors.white)),
                                                                        child:
                                                                        DropdownButton(
                                                                          underline:
                                                                          SizedBox(),
                                                                          // Initial Value
                                                                          value: value
                                                                              .dropdownvalue!,

                                                                          // Down Arrow Icon
                                                                          icon:
                                                                          const Icon(
                                                                            Icons
                                                                                .keyboard_arrow_down,
                                                                            size: 15,
                                                                          ),

                                                                          // Array list of items
                                                                          items: value.items
                                                                              .map((String
                                                                          items) {
                                                                            return DropdownMenuItem(
                                                                              value:
                                                                              items,
                                                                              child: Text(
                                                                                  items,
                                                                                  style: TextStyle(
                                                                                    fontWeight: FontWeight.bold,
                                                                                      fontSize:
                                                                                      10,
                                                                                      color:
                                                                                      Colors.grey)),
                                                                            );
                                                                          }).toList(),
                                                                          // After selecting the desired option,it will
                                                                          // change button value to selected value
                                                                          onChanged: (String?
                                                                          newValue) {
                                                                            setState(() {
                                                                              value.dropdownvalue =
                                                                              newValue!;
                                                                            });
                                                                          },
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )),
                                                            Flexible(
                                                                child:
                                                                FractionallySizedBox(
                                                                  widthFactor: 1,
                                                                  child: Column(
                                                                    children: [
                                                                      Text(
                                                                        'Year'.tr,
                                                                        style: TextStyle(
                                                                            fontSize: label_text_size,
                                                                            color: Colors
                                                                                .grey),
                                                                      ),
                                                                      SizedBox(height: 5,),
                                                                      Container(
                                                                        height: 30,
                                                                        child: TextField(
                                                                          style: TextStyle(color: ConstantUtils.isDarkMode?dark_font_grey_color:Colors.black),
                                                                          keyboardType:
                                                                          TextInputType
                                                                              .number,
                                                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(
                                                                              4),],
                                                                          decoration: InputDecoration(
                                                                              errorText: value
                                                                                  .invalidateYear
                                                                                  ? 'Please fill the year'
                                                                                  : null,
                                                                              fillColor:
                                                                              ConstantUtils.isDarkMode?dark_nav_color:lightWhiteBackgroundColor,
                                                                              filled:
                                                                              true,
                                                                              enabledBorder: OutlineInputBorder(
                                                                                  borderSide: BorderSide(
                                                                                      color:
                                                                                      lightGrey,
                                                                                      width:
                                                                                      1.0),
                                                                                  borderRadius:
                                                                                  BorderRadius.circular(10))),
                                                                          controller: value
                                                                              .yearController,
                                                                          onChanged: (mChangeValue){
                                                                            setState(() {
                                                                              if(mChangeValue.isNotEmpty){
                                                                                value.invalidateYear=false;

                                                                              }
                                                                            });
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                            border: Border(
                                                                bottom: BorderSide(
                                                                    width: 1.0,
                                                                    color:
                                                                    ConstantUtils.isDarkMode?dark_nav_color:underLineGreyColor

                                                                ))),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Container(
                                                              width: setting_icon_size,
                                                              margin:
                                                              EdgeInsets.only(
                                                                  right: 10,
                                                                 ),
                                                              child: SvgPicture.asset(
                                                                  'assets/settings/profile/gender.svg'),
                                                            ),
                                                           Container(
                                                             width: setting_label_width,
                                                             child: Text(
                                                               'Gender'.tr,
                                                               style: TextStyle(
                                                                 fontWeight: FontWeight.bold,
                                                                   color:
                                                                   Colors.grey,
                                                                   fontSize: label_text_size),
                                                             ),

                                                           ),

                                                            Flexible(
                                                                child:
                                                                FractionallySizedBox(
                                                                    widthFactor:
                                                                    1,
                                                                    child: Column(
                                                                      children: [
                                                                        Text(
                                                                          'Male'.tr,
                                                                          style: TextStyle(
                                                                              fontSize:
                                                                              label_text_size,
                                                                              color:
                                                                              Colors.grey),
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                          25,
                                                                          child:
                                                                          Radio(
                                                                            value:
                                                                            0,
                                                                            groupValue:
                                                                            _radioValue,
                                                                            onChanged:
                                                                            _handleRadioValueChange,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ))),
                                                            Flexible(
                                                                child:
                                                                FractionallySizedBox(
                                                                    widthFactor:
                                                                    1,
                                                                    child: Column(
                                                                      children: [
                                                                        Text(
                                                                          'Female'.tr,
                                                                          style: TextStyle(
                                                                              fontSize:
                                                                              label_text_size,
                                                                              color:
                                                                              Colors.grey),
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                          25,
                                                                          child:
                                                                          Radio(
                                                                            value:
                                                                            1,
                                                                            groupValue:
                                                                            _radioValue,
                                                                            onChanged:
                                                                            _handleRadioValueChange,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ))),
                                                            Flexible(
                                                                child:
                                                                FractionallySizedBox(
                                                                    widthFactor:
                                                                    1,
                                                                    child: Column(
                                                                      children: [
                                                                        Text(
                                                                          'Other'.tr,
                                                                          style: TextStyle(
                                                                              fontSize:
                                                                              label_text_size,
                                                                              color:
                                                                              Colors.grey),
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                          25,
                                                                          child:
                                                                          Radio(
                                                                            value:
                                                                            2,
                                                                            groupValue:
                                                                            _radioValue,
                                                                            onChanged:
                                                                            _handleRadioValueChange,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    )))
                                                          ],
                                                        ),
                                                      ),
                                                      // GestureDetector(
                                                      //   onTap: () {
                                                      //     if (value.urlImageEncode ==
                                                      //         null ||
                                                      //         value.urlImageEncode
                                                      //             .toString()
                                                      //             .isEmpty) {
                                                      //       value.saveProfile(context,
                                                      //           value.dropdownvalue!,
                                                      //           mGender,
                                                      //           '');
                                                      //     } else {
                                                      //       value.saveProfile(context,
                                                      //           value.dropdownvalue!,
                                                      //           mGender,
                                                      //           value.urlImageEncode
                                                      //               .toString());
                                                      //     }
                                                      //   },
                                                      //   child: Container(
                                                      //       height: 50,
                                                      //       padding:
                                                      //       EdgeInsets.all(10),
                                                      //       decoration: BoxDecoration(
                                                      //           color: themeColor,
                                                      //           border: Border(
                                                      //               bottom: BorderSide(
                                                      //                   width: 1.0,
                                                      //                   color:
                                                      //                   themeColor))),
                                                      //       child: Row(
                                                      //         mainAxisAlignment:
                                                      //         MainAxisAlignment
                                                      //             .center,
                                                      //         children: [
                                                      //           Center(
                                                      //             child: Text(
                                                      //                 value
                                                      //                     .saveButton,
                                                      //                 style: TextStyle(
                                                      //                     color: Colors
                                                      //                         .white)),
                                                      //           )
                                                      //         ],
                                                      //       )),
                                                      // )
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 30,right: 30,bottom: 10,top: 10),
                                                        child: FractionallySizedBox(
                                                          widthFactor: 1.0,
                                                          child: RaisedButton(
                                                              onPressed: () async {
                                                                    if (value.urlImageEncode ==
                                                                        null ||
                                                                        value.urlImageEncode
                                                                            .toString()
                                                                            .isEmpty) {
                                                                      value.saveProfile(context,
                                                                          value.dropdownvalue!,
                                                                          mGender,
                                                                          '');
                                                                    } else {
                                                                      value.saveProfile(context,
                                                                          value.dropdownvalue!,
                                                                          mGender,
                                                                          value.urlImageEncode
                                                                              .toString());
                                                                    }
                                                                    _sendAnalyticsEvent(profile_btn);


                                                              },
                                                              color: Colors.red,
                                                              textColor: Colors.white,
                                                              shape: StadiumBorder(
                                                                  side: BorderSide(color: Colors.red, width: 1)),
                                                              child: Text('Save'.tr)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )

                                              ],

                                            )
                                                : Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          width: 1.0,
                                                          color:
                                                          ConstantUtils.isDarkMode?dark_nav_color:light_border_color))),
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _showPicker(context);
                                                      });
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width: 50,
                                                          height: 50,
                                                          margin:
                                                          EdgeInsets.only(
                                                              right: 10),
                                                          child: (_settingController
                                                              .urlImageEncode ==
                                                              null ||
                                                              _settingController
                                                                  .urlImageEncode!
                                                                  .isEmpty)
                                                              ? SvgPicture.asset(
                                                              'assets/settings/profile.svg')
                                                              : ClipRRect(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                50),
                                                            child: Image
                                                                .memory(
                                                              decodeImage(_settingController
                                                                  .urlImageEncode
                                                                  .toString()),
                                                              fit: BoxFit
                                                                  .cover,
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          bottom: 1,
                                                          right: 5,
                                                          child: Container(
                                                            width: 20,
                                                            height: 20,
                                                            child: SvgPicture.asset(
                                                                'assets/settings/profile/profile_group.svg'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          if (value
                                                              .profileTab) {
                                                            value.profileTab =
                                                            false;
                                                          } else {
                                                            value.profileTab =
                                                            true;
                                                          }
                                                        });
                                                      },
                                                      child: Container(
                                                        width:
                                                        getProportionateScreenWidth(
                                                            200),
                                                        child: Text(value.userName!=null && value.userName.isNotEmpty?value.userName:
                                                          'Profile'.tr,
                                                          style: TextStyle(
                                                             fontSize: 16,
                                                              color:
                                                              Colors.black),
                                                        ),
                                                      ))
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        countryCode=='MM'?GestureDetector(
                                          onTap: (){
                                            setState(() {
                                                    if (languageTab) {
                                                      languageTab = false;
                                                    } else {
                                                      languageTab = true;
                                                    }
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        width: 1.0,
                                                        color:
                                                        themeColor))),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  child: SvgPicture.asset(
                                                      'assets/settings/language.svg'),
                                                ),
                                                Text(
                                                  'Language'.tr,
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                )
                                              ],
                                            ),
                                          ),

                                        ):Container(),
                                        countryCode=='MM'?languageTab
                                            ? Column(
                                          children: [
                                          GestureDetector(onTap: (){
                                            _handleLangValueChange(0);
                                          },
                                            child:   Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color:
                                                  ConstantUtils.isDarkMode?dark_nav_color:lightGreyBackgroundColor,
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          width: 1.0,
                                                          color:
                                                          ConstantUtils.isDarkMode?dark_border_color:underLineGreyColor))),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 25,
                                                    child: Radio(
                                                      value: 0,
                                                      groupValue: _langValue,
                                                      onChanged:
                                                      _handleLangValueChange,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 20,
                                                    height: 20,
                                                    margin: EdgeInsets.only(
                                                      right: 15,
                                                    ),
                                                    child: SvgPicture.asset(
                                                        'assets/settings/lang/eng.svg'),
                                                  ),
                                                  Text(
                                                    'English'.tr,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                            GestureDetector(
                                              onTap: (){
                                                _handleLangValueChange(1);
                                              },
                                              child:   Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color:
                                                    ConstantUtils.isDarkMode?dark_nav_color:lightGreyBackgroundColor,
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            width: 1.0,
                                                            color:
                                                            themeColor))),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 25,
                                                      child: Radio(
                                                        value: 1,
                                                        groupValue: _langValue,
                                                        onChanged:
                                                        _handleLangValueChange,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 20,
                                                      height: 20,
                                                      margin: EdgeInsets.only(
                                                        right: 15,
                                                      ),
                                                      child: SvgPicture.asset(
                                                          'assets/settings/lang/myan.svg'),
                                                    ),
                                                    Text(
                                                      'Myanmar'.tr,
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )

                                          ],
                                        ):  Container():Container(),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (styleTab) {
                                                styleTab = false;

                                              } else {
                                                styleTab = true;

                                              }
                                            });
                                          },
                                          child: styleTab
                                              ? Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            width: 1.0,
                                                            color:
                                                            ConstantUtils.isDarkMode?dark_border_color:light_border_color))),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 30,
                                                      height: 30,
                                                      margin: EdgeInsets.only(
                                                          right: 10),
                                                      child: SvgPicture.asset(
                                                          'assets/settings/style.svg'),
                                                    ),
                                                    Text(
                                                      'Style'.tr,
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                EdgeInsets.only(left: 50),
                                                decoration: BoxDecoration(
                                                    color:
                                                    ConstantUtils.isDarkMode?dark_nav_color:lightGreyBackgroundColor,
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            width: 1.0,
                                                            color:
                                                            ConstantUtils.isDarkMode?dark_border_color:light_border_color))),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Light'.tr,
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                    Switch(
                                                      value: isSwitched,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          isSwitched = value;
                                                          if (isSwitched) {
                                                            preferences!
                                                                .setBool(
                                                                is_Switch,
                                                                true);
                                                            ConstantUtils.isDarkMode =true;

                                                          } else {
                                                            ConstantUtils.isDarkMode =
                                                            false;
                                                            preferences!
                                                                .setBool(
                                                                is_Switch,
                                                                false);
                                                          }
                                                        });
                                                      },
                                                      activeTrackColor:
                                                      themeColor,
                                                      activeColor: Colors.white,
                                                    ),
                                                    // Expanded(
                                                    // child:   AnimatedToggle(
                                                    //   values: ['Light', 'Dark'],
                                                    //   textColor:
                                                    //   Utils.isDarkMode ? Utils.darkMode.textColor : Utils.lightMode.textColor,
                                                    //   backgroundColor: Utils.isDarkMode
                                                    //       ? Utils.darkMode.imageBackgroundColor
                                                    //       : Utils.lightMode.imageBackgroundColor,
                                                    //   buttonColor: Utils.isDarkMode
                                                    //       ? Utils.darkMode.imageColor
                                                    //       : Utils.lightMode.imageColor,
                                                    //   shadows: Utils.isDarkMode ? Utils.darkMode.shadow : Utils.lightMode.shadow,
                                                    //   onToggleCallback: (index) {
                                                    //     Utils.isDarkMode = !Utils.isDarkMode;
                                                    //     setState(() {});
                                                    //     changeThemeMode();
                                                    //   },
                                                    // ),),
                                                    Text(
                                                      'Dark'.tr,
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                              : Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        width: 1.0,
                                                        color:
                                                        ConstantUtils.isDarkMode?dark_border_color:light_border_color))),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  child: SvgPicture.asset(
                                                      'assets/settings/style.svg'),
                                                ),
                                                Text(
                                                  'Style'.tr,
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            showDialog(
                                              barrierColor: Colors.grey,
                                              context: context,
                                              builder: (context) {
                                                return CustomAlertDialog(

                                                );
                                              },
                                            );

                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        width: 1.0,
                                                        color:  ConstantUtils.isDarkMode?dark_border_color:light_border_color))),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  margin: EdgeInsets.only(right: 10),
                                                  child: SvgPicture.asset(
                                                      'assets/settings/term_condition.svg'),
                                                ),
                                                Text(
                                                  'Terms & Condition'.tr,
                                                  style: TextStyle(color: Colors.grey),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            showDialog(
                                              barrierColor: Colors.grey,
                                              context: context,
                                              builder: (context) {
                                                return CustomAboutUsAlertDialog(

                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        width: 1.0,
                                                        color:  ConstantUtils.isDarkMode?dark_border_color:light_border_color))),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  margin: EdgeInsets.only(right: 10),
                                                  child: SvgPicture.asset(
                                                      'assets/settings/about_us.svg'),
                                                ),
                                                Text(
                                                  'About Us'.tr,
                                                  style: TextStyle(color: Colors.grey),
                                                )
                                              ],
                                            ),
                                          ),

                                        ),

                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      width: 1.0,
                                                      color:  ConstantUtils.isDarkMode?dark_border_color:light_border_color))),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 30,
                                                height: 30,
                                                margin: EdgeInsets.only(right: 10),
                                                child: SvgPicture.asset(
                                                    'assets/settings/version.svg'),
                                              ),
                                              Text(
                                                'Version'.tr+' '+_packageInfo.version,
                                                style: TextStyle(color: Colors.grey),
                                              )
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (contactUsTab) {
                                                contactUsTab = false;
                                              } else {
                                                contactUsTab = true;
                                              }
                                            });
                                          },
                                          child: contactUsTab
                                              ? Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            width: 1.0,
                                                            color:
                                                            ConstantUtils.isDarkMode?dark_border_color:light_border_color))),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 30,
                                                      height: 30,
                                                      margin: EdgeInsets.only(
                                                          right: 10),
                                                      child: SvgPicture.asset(
                                                          'assets/settings/contact_us.svg'),
                                                    ),
                                                    Text(
                                                      'Contact Us'.tr,
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color:
                                                    ConstantUtils.isDarkMode?dark_nav_color:lightGreyBackgroundColor,
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            width: 1.0,
                                                            color:
                                                            ConstantUtils.isDarkMode?dark_border_color:light_border_color))),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 20,
                                                      height: 20,
                                                      margin: EdgeInsets.only(
                                                          left: 30, right: 5),
                                                      child: SvgPicture.asset(
                                                          'assets/settings/profile/email.svg'),
                                                    ),
                                                    Text(
                                                      'athabyar@gmail.com',
                                                      style: TextStyle(
                                                          color:  Colors.grey,
                                                          fontSize: 10),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                              : Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        width: 1.0,
                                                        color:
                                                        ConstantUtils.isDarkMode?dark_border_color:light_border_color))),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  child: SvgPicture.asset(
                                                      'assets/settings/contact_us.svg'),
                                                ),
                                                Text(
                                                  'Contact Us'.tr,
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: ()async{
                                            ConstantUtils utils=ConstantUtils();
                                            var isInternet=await utils.isInternet();
                                            if(isInternet){
                                              showDownloadData();
                                            }else{
                                              ConstantUtils.showAlertDialog(context, internetConnectionStatus);
                                            }


                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        width: 1.0,
                                                        color:  ConstantUtils.isDarkMode?dark_border_color:light_border_color))),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  margin: EdgeInsets.only(right: 10),
                                                  child: SvgPicture.asset(
                                                      'assets/settings/Sync icon.svg'),
                                                ),
                                                Text(
                                                  'Sync Data'.tr,
                                                  style: TextStyle(color: Colors.grey),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async{
                                            ConstantUtils utils=ConstantUtils();
                                            var isInternet=await utils.isInternet();
                                            isLoading=true;
                                            SharedPreferences pref =
                                            await SharedPreferences
                                                .getInstance();
                                            pref.remove(mProfileId);
                                            pref.remove(mDeviceId);
                                            pref.remove(Lang);
                                            pref.remove(mPhoneNumber);
                                            pref.remove(is_Switch);
                                            pref.remove(LoginSuccess);
                                            pref.remove(termsAndCondition_eng);
                                            pref.remove(termsAndCondition_mm);
                                            pref.remove(about_us_eng);
                                            pref.remove(about_us_mm);
                                            pref.remove(selected_date);
                                            pref.remove(selected_type);
                                            pref.remove(selected_img);
                                            pref.remove(selected_country);
                                            pref.remove(mCountryCode);
                                            setState(() {

                                            });
                                            if(isInternet){
                                                try {
                                                  await DownloadUploadAll.uploadAll();
                                                } catch (e) {
                                                  print(e);
                                                }
                                            }else{
                                              ConstantUtils.showAlertDialog(context, internetConnectionStatus);
                                            }

                                            Get.off(() => LoginScreen());
                                            isLoading=false;


                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        width: 1.0,
                                                        color:  ConstantUtils.isDarkMode?dark_nav_color:light_border_color))),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  margin: EdgeInsets.only(right: 10),
                                                  child: SvgPicture.asset(
                                                    'assets/settings/logout.svg',
                                                    color: lightGrey,
                                                  ),
                                                ),
                                                Text(
                                                  'Logout'.tr,
                                                  style:
                                                  TextStyle(color: Colors.grey),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                          //_widgetAdsType(context)
                          SizedBox(height: getProportionateScreenHeight(50),)
                        ],
                      )
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                 // child: _widgetAdsType(context),
                child: CustomAds(height: 50,myBanner: 'myBanner',))

              ],
            )));
  }


  Container buildDot(
      {required double width, required double height, required Color color}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: width,
      height: height,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: color,
      ),
    );
  }



  void showDownloadData()async {
    SharedPreferences pref=await SharedPreferences.getInstance();
    String code=myanmarCode;
    if(pref.getString(selected_country)!=null){
      code=(await pref.getString(selected_country))!;
    }
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: ()async {
        setState(() {
          Navigator.of(context).pop();
          isLoading=true;
        });
        try {
          try {
            await DownloadUploadAll.uploadAll();
          } catch (e) {
            print(e);
          }
           try {
             await DownloadUploadAll.downloadProfile();
           } catch (e) {
             print(e);
           }
           try {
             await DownloadUploadAll.downloadDaily();
           } catch (e) {
             print(e);
           }
           try {
             await DownloadUploadAll.downloadAccountGroup(code);
           } catch (e) {
             print(e);
           }
           try {
             await DownloadUploadAll.downloadAccount(code);
           } catch (e) {
             print(e);
           }
            try {
             await DownloadUploadAll.downloadCategory();
           } catch (e) {
             print(e);
           }
        //  await DownloadUploadAll.downloadAccountSummary();
          //await DownloadUploadAll.downloadMonthlySummary();

           try {
             await DownloadUploadAll.downloadTermAndCondition();
             await DownloadUploadAll.downloadAboutUs();
             await DownloadUploadAll.downloadGold();
           } catch (e) {
             print(e);
           }


        } catch (e) {
          print(e);
        }
        setState(() {
            isLoading=false;
        });

      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('AThaByar'),
      content: Text("Are you sure you want to sync data?"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
