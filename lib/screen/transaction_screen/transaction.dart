import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:AthaPyar/controller/account_controller.dart';
import 'package:AthaPyar/controller/transaction_controller.dart';
import 'package:AthaPyar/datatbase/model/tbl_dailyDetail.dart';
import 'package:AthaPyar/helper/size_config.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/screen/account_screen/account.dart';
import 'package:AthaPyar/screen/category_screen/category.dart';
import 'package:AthaPyar/screen/category_screen/category_detail.dart';
import 'package:AthaPyar/screen/home_screen/home.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../componenets/user_guide.dart';

class TransactionScreen extends StatefulWidget  {
  String transactionId;
  String dailyId;

  TransactionScreen({required this.transactionId, required this.dailyId});

  @override
  _TransactionScreen createState() =>
      _TransactionScreen(transactionId: transactionId, dailyId: dailyId);
}

class _TransactionScreen extends State<TransactionScreen> with WidgetsBindingObserver{
  String transactionId;
  String dailyId;
  bool isClickedIncome = false;
  bool isClickedExpense = false;
  bool isClickedTransfer = false;
  String selectedDate = '';
  String type = '';
  bool isDialogShow=false;

  final Map<DateTime, List<CleanCalendarEvent>> _events = {};

  _TransactionScreen({required this.transactionId, required this.dailyId});

  final TransactionController _commonController =
  Get.put(TransactionController());

  final AccountController _accountController = Get.put(AccountController());

  String? _urlImageEncode;
  late String _dir;
  final _picker = ImagePicker();
  //File? _image;
  FocusNode? categoryFocus;
  FocusNode? toAccountFocus;
  FocusNode? amountFocus;
  FocusNode? accountFocus;

  late bool saveBtnClick = true;
  late bool deleteBtnClick = false;

  bool isFromAccount = false;
  bool isToAccount = false;
  bool isAmount = false;
  bool isCategory = false;
  bool isIncomeAccountUG=false;
  bool isCategoryAccountUG=false;
  bool isIncomeAmountUG=false;
  bool isSaveUG=false;
  PersistentBottomSheetController? accountBottomSheetController;
  PersistentBottomSheetController? dateBottomSheetController;
  PersistentBottomSheetController? toAccountBottomSheetController;
  PersistentBottomSheetController? categoryBottomSheetController;

  bool isUserGuideSelected=true;
  late String _amount='';
  String isIncomeTypeSave='';
  String isExpenseTypeSave='';

  late AppsflyerSdk _appsflyerSdk;
  late Map _deepLinkData;
  late Map _gcd;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state)async {
    SharedPreferences pref=await SharedPreferences.getInstance();
    super.didChangeAppLifecycleState(state);
    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
        if(pref.getBool(isUserGuideWork) !=null){
          isUserGuideSelected=pref.getBool(isUserGuideWork)!;
        }
        debugPrint('isUserGuide Resume: $isUserGuideSelected');
        debugPrint('AppLifeCycle home: Resume');
        break;
      case AppLifecycleState.inactive:
        debugPrint('AppLifeCycle: inactive');
        // widget is inactive
        break;
      case AppLifecycleState.paused:
        debugPrint('AppLifeCycle: Pause');
        // widget is paused
        break;
      case AppLifecycleState.detached:
        debugPrint('AppLifeCycle: detached');
        // widget is detached
        break;
    }
  }
  @override
  void initState() {
    super.initState();
    final AppsFlyerOptions options = AppsFlyerOptions(
        afDevKey: 'WCEsoDzwXDTy9kq9fYugGH',
        appId: 'id1615505050',
        showDebug: true,
        timeToWaitForATTUserAuthorization: 15
    );
    _appsflyerSdk = AppsflyerSdk(options);
    _appsflyerSdk.onAppOpenAttribution((res) {
      print("onAppOpenAttribution res: " + res.toString());
      setState(() {
        _deepLinkData = res;
      });
    });
    _appsflyerSdk.onInstallConversionData((res) {
      print("onInstallConversionData res: " + res.toString());
      setState(() {
        _gcd = res;
      });
    });
    _appsflyerSdk.onDeepLinking((DeepLinkResult dp){
      switch (dp.status) {
        case Status.FOUND:
          print(dp.deepLink?.toString());
          print("deep link value: ${dp.deepLink?.deepLinkValue}");
          break;
        case Status.NOT_FOUND:
          print("deep link not found");
          break;
        case Status.ERROR:
          print("deep link error: ${dp.error}");
          break;
        case Status.PARSE_ERROR:
          print("deep link status parsing error");
          break;
      }
      print("onDeepLinking res: " + dp.toString());
      setState(() {
        _deepLinkData = dp.toJson();
      });
    });

    categoryFocus = FocusNode();
    toAccountFocus = FocusNode();
    amountFocus = FocusNode();
    accountFocus=FocusNode();
    _accountController.onInit();

    if(isClickedIncome){
      type=IncomeType;
    }else if(isClickedExpense){
      type = ExpenseType;
    }else if(isClickedTransfer){
      type = TransferType;
    }else{
      isClickedExpense = true;
      type = ExpenseType;
    }
    init();

  }
  void _closeAccountBottomSheet() {
    setState(() {
      try {

          accountBottomSheetController!.close();

      } catch (e) {
        print(e);
      }
    });
  }
  void _closeToAccountBottomSheet() {
    setState(() {
      try {

          toAccountBottomSheetController!.close();


      } catch (e) {
        print(e);
      }
    });
  }
  void _closeCategoryBottomSheetController() {
    setState(() {
      try {

          categoryBottomSheetController!.close();

      } catch (e) {
        print(e);
      }
    });
  }
  void _closeDateBottomSheetController() {
    setState(() {
      try {
          dateBottomSheetController!.close();

      } catch (e) {
        print(e);
      }
    });
  }
  void isUserGuide(String image,String selectedType,String skipName)async{
    print('SkipChangedData useGuide: $skipName');
    SharedPreferences pref=await SharedPreferences.getInstance();
    String selectedLan=pref.getString(Lang).toString();
    if(isUserGuideSelected ){
      _accountController.accountController.clear();
      _accountController.categoryController.clear();
      _commonController.transactionAmountController.clear();
      Timer(Duration(seconds: 0),(){
        Navigator.of(context).push(UserGuideState(img:image,skipName:skipName,onCountChange: (bool res) {
          setState(() {
            debugPrint('isUserGuide response: $res');

            if(pref.getBool(isUserGuideWork) !=null){
              isUserGuideSelected=pref.getBool(isUserGuideWork)!;
            }
            debugPrint('isUserGuide work: $isUserGuideSelected');
            if(res){
              type=selectedType;
              if (type == IncomeType) {
                isClickedIncome = true;
                isClickedExpense = false;
                isClickedTransfer = false;
              } else if (type == ExpenseType) {
                isClickedIncome = false;
                isClickedExpense = true;
                isClickedTransfer = false;
              } else {
                isClickedIncome = false;
                isClickedExpense = false;
                isClickedTransfer = true;
              }
                accountFocus!.requestFocus();
            }

          });
        },onSkipChange: (String name){
          if(name==skipName){
            print('IncomeAccount: $name');
            if(name=='income-account'){
              categoryFocus!.requestFocus();
              _commonController.setCategoryType(type);
              _showCategoryBottomSheet();
              userGuideData('test',selectedLan=='English'?'assets/icon/income/income-category-eng.svg':'assets/icon/income/income-category.svg','income-category');
            }
            if(name=='expense-account'){
              categoryFocus!.requestFocus();
              _commonController.setCategoryType(type);
              _showCategoryBottomSheet();
              userGuideData('test',selectedLan=='English'?'assets/icon/expense/expense-category-eng.svg':'assets/icon/expense/expense-category.svg','expense-category');
            }

          }

        }));
      });

    }

  }

  Uint8List decodeImage(String img64) {
    return base64Decode(img64);
  }

  _imgFromCamera() async {
    PickedFile? image =
    await _picker.getImage(source: ImageSource.camera, imageQuality: 50);
    SharedPreferences pref=await SharedPreferences.getInstance();

    setState(() {
      final File file = File(image!.path);
      //_image = file;
      _urlImageEncode = encodeImg(file);
      pref.setString(selected_img, _urlImageEncode!);
    });
  }

  _imgFromGallery() async {
    PickedFile? image =
    await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    SharedPreferences pref=await SharedPreferences.getInstance();
    setState(() {
      final File file = File(image!.path);
      // _image = file;
      _urlImageEncode = encodeImg(file);
      pref.setString(selected_img, _urlImageEncode!);

    });
  }

  String encodeImg(File? image) {
    final bytes = image!.readAsBytesSync();
    String img64 = base64Encode(bytes);
    return img64;
  }
  @override
  void dispose() {
    super.dispose();

  }
  void init() async {
    _commonController.onInit();
    SharedPreferences pref=await SharedPreferences.getInstance();
    _dir = (await getApplicationDocumentsDirectory()).path;
    debugPrint('DailyID select: $dailyId');
    selectedDate = (DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day))
        .toString();
    if(pref.getString(selected_date)!=null && pref.getString(selected_date).toString().isNotEmpty){
      selectedDate=pref.getString(selected_date).toString();
    }
    if(pref.getString(selected_type)!=null && pref.getString(selected_type).toString().isNotEmpty){
      type=pref.getString(selected_type).toString();
      print('SelectedType: $type');
    }
    if(pref.getString(selected_img)!=null && pref.getString(selected_img).toString().isNotEmpty){
      _urlImageEncode=pref.getString(selected_img).toString();
    }
    if(pref.getBool(isUserGuideWork) !=null){
      isUserGuideSelected=pref.getBool(isUserGuideWork)!;
    }
    debugPrint('isUserGuide work: $isUserGuideSelected');

    if (dailyId.isNotEmpty) {
      _commonController.incomeExpenseTransactionList.clear();
      var list = await _commonController.updateTransaction(transactionId);
      updateData(list);
    } else {
      pref.setString(selected_type, type);
      type=pref.getString(selected_type).toString();
      print('SelectedType: s $type');
      if (type == IncomeType) {
        isClickedIncome = true;
        isClickedExpense = false;
        isClickedTransfer = false;
      } else if (type == ExpenseType) {
        isClickedIncome = false;
        isClickedExpense = true;
        isClickedTransfer = false;
      } else {
        isClickedIncome = false;
        isClickedExpense = false;
        isClickedTransfer = true;
      }

     if(await pref.getString(IncomeTypeSave_UserGuide)!=null){
       isIncomeTypeSave= await pref.getString(IncomeTypeSave_UserGuide).toString();
     }else if(await pref.getString(ExpenseTypeSave_UserGuide)!=null){
       isExpenseTypeSave=await pref.getString(ExpenseTypeSave_UserGuide).toString();
     }
      String selectedLan=pref.getString(Lang).toString();
      debugPrint('SelectedLang home: $selectedLan');
      if(isUserGuideSelected && isIncomeTypeSave.isEmpty){
        isUserGuide(selectedLan=='English'?'assets/icon/income/income-account-eng.svg':'assets/icon/income/income-account.svg',IncomeType,'income-account');
      }else if(isUserGuideSelected && isIncomeTypeSave==IncomeTypeSave_UserGuide){
        isUserGuide(selectedLan=='English'?'assets/icon/expense/expense-account-eng.svg':'assets/icon/expense/expense-account.svg',ExpenseType,'expense-account');
      }
      debugPrint('isUserGuide Save: $isUserGuideSelected');

      Timer.run(() {
        if (_accountController.accountController.text.isEmpty) {
          _showAccountBottomSheet();
        }
      });
    }
  }

  void _handleNewDate(date) async{
    SharedPreferences pref=await SharedPreferences.getInstance();

    setState(() {
      selectedDate = date.toString();
      pref.setString(selected_date, selectedDate);

    });
  }

  void updateData(List<TBL_DailyDetail> list) async{
    SharedPreferences pref=await SharedPreferences.getInstance();

    if (list.length > 0) {
      selectedDate = list[0].date;
      _accountController.accountController.text = list[0].accountName;
      _accountController.categoryController.text = list[0].categoryName;
      _commonController.transactionAmountController.text = list[0].amount;
      _commonController.transactionNoteController.text=list[0].note;
      _urlImageEncode = list[0].image;
      _accountController.setAccountId(list[0].accountId);
      _accountController.setCategoryId(list[0].categoryId);
      type = list[0].type;
      SharedPreferences pref=await SharedPreferences.getInstance();
      pref.setString(selected_type, type);
      _commonController.setCategoryType(type);
      if (type == IncomeType) {
        isClickedIncome = true;
        isClickedExpense = false;
        isClickedTransfer = false;
      } else if (type == ExpenseType) {
        isClickedIncome = false;
        isClickedExpense = true;
        isClickedTransfer = false;
      } else {
        isClickedIncome = false;
        isClickedExpense = false;
        isClickedTransfer = true;
        _accountController.setToAccountId(list[0].toAccountId);
        _accountController.toController.text = list[0].toAccountName;
      }
    }

  }





  Future hideStatusBar() => SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ConstantUtils.isDarkMode
            ? dark_background_color
            : light_background_color,
        key: _scaffoldKey,
        appBar:  AppBar(
          toolbarHeight: app_bar_height,
            automaticallyImplyLeading: false,
            backgroundColor: ConstantUtils.isDarkMode?dark_nav_color:themeColor,
            centerTitle: true,
            title: Text(
              'Transaction'.tr,
              style: TextStyle(fontSize: app_bar_title, color: appBarColor),
            ),
            leading: IconButton(onPressed: (){
              Get.off(() => HomeScreen(
                selectedMenu: 'calendar', showInterstitial: false,
              ));
            }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,))
        ),
        body: SafeArea(
            child: GetBuilder<TransactionController>(
              init: TransactionController(),
              builder: (value) {
                return  isLoading?Center(child: CircularProgressIndicator(),):SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: getProportionateScreenHeight(spaceMedium),
                        ),
                        Container(
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: FractionallySizedBox(
                                      widthFactor: 1.0,
                                      child: TextButton(
                                        style: ButtonStyle(
                                          padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                              EdgeInsets.all(3)),
                                          backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              ConstantUtils.isDarkMode
                                                  ? dark_nav_color
                                                  : Colors.white),
                                          foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10.0),
                                                  side: BorderSide(
                                                    color: isClickedIncome
                                                        ? themeColor
                                                        : Colors.grey,
                                                  ))),
                                        ),
                                        onPressed: () async{
                                          SharedPreferences pref=await SharedPreferences.getInstance();

                                          setState(() {
                                            type = IncomeType;
                                            isClickedIncome = true;
                                            isClickedExpense = false;
                                            isClickedTransfer = false;
                                            value.setCategoryType(type);
                                            pref.setString(selected_type, type);
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(3),
                                          child: Text(
                                            'income'.tr,
                                            style: TextStyle(color: isClickedIncome?Colors.blue:fontGreyColor),
                                          ),
                                        ),
                                      )),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Flexible(
                                  child: FractionallySizedBox(
                                    widthFactor: 1.0,
                                    child: TextButton(
                                      style: ButtonStyle(
                                        padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            EdgeInsets.all(3)),
                                        backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            ConstantUtils.isDarkMode
                                                ? dark_nav_color
                                                : Colors.white),
                                        foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                                side: BorderSide(
                                                  color: isClickedExpense
                                                      ? themeColor
                                                      : Colors.grey,
                                                ))),
                                      ),
                                      onPressed: ()async {
                                        SharedPreferences pref=await SharedPreferences.getInstance();

                                        setState(() {
                                          type = ExpenseType;
                                          isClickedIncome = false;
                                          isClickedExpense = true;
                                          isClickedTransfer = false;
                                          value.setCategoryType(type);
                                          pref.setString(selected_type, type);
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(3),
                                        child: Text(
                                          'Expense'.tr,
                                          style: TextStyle(color: isClickedExpense?Colors.red:Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Flexible(
                                    child: FractionallySizedBox(
                                      widthFactor: 1.0,
                                      child: TextButton(
                                        style: ButtonStyle(
                                          padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                              EdgeInsets.all(3)),
                                          backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              ConstantUtils.isDarkMode
                                                  ? dark_nav_color
                                                  : Colors.white),
                                          foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10.0),
                                                  side: BorderSide(
                                                    color: isClickedTransfer
                                                        ? themeColor
                                                        : Colors.grey,
                                                  ))),
                                        ),
                                        onPressed: () async{
                                          SharedPreferences pref=await SharedPreferences.getInstance();
                                          setState(() {
                                            type = TransferType;
                                            isClickedIncome = false;
                                            isClickedExpense = false;
                                            isClickedTransfer = true;
                                            value.setCategoryType(type);
                                            pref.setString(selected_type, type);

                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(3),
                                          child: Text(
                                            'Transfer'.tr,
                                            style: TextStyle(color: isClickedTransfer?Colors.black:fontGreyColor),
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: ConstantUtils.isDarkMode
                              ? dark_nav_color
                              : Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                        child: Text(
                                          'Date'.tr,
                                          style: TextStyle(
                                              color: ConstantUtils.isDarkMode
                                                  ? dark_font_grey_color
                                                  : fontGreyColor),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: new InkWell(
                                          onTap: () {
                                            Timer.run(() {
                                              _showDateBottomSheet();
                                            });
                                          },
                                          child:new Text(
                                            ConstantUtils.formatter.format(
                                                DateTime.parse(selectedDate.isEmpty?  (DateTime(
                                                    DateTime.now().year, DateTime.now().month, DateTime.now().day))
                                                    .toString():selectedDate))
                                            ,
                                            style: TextStyle(
                                                color: ConstantUtils.isDarkMode
                                                    ? Colors.white
                                                    : Colors.black),
                                          )
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                                Divider(
                                  thickness: 1,
                                  color:ConstantUtils.isDarkMode?dark_font_grey_color:underLineGreyColor,
                                  indent: 76,
                                  height: 10,),

                                isClickedTransfer
                                    ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          flex: 5,
                                          child: Text(
                                            'From'.tr,
                                            style: TextStyle(
                                                color:
                                                ConstantUtils.isDarkMode
                                                    ? dark_font_grey_color
                                                    : fontGreyColor),
                                          ),
                                        ),
                                        Flexible(
                                            flex: 18,
                                            child: new Theme(
                                                data: new ThemeData(
                                                  primaryColor:
                                                  Colors.orangeAccent,
                                                  primaryColorDark:
                                                  Colors.orange,
                                                ),
                                                child:  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                width: 1.0,
                                                                color:
                                                                ConstantUtils.isDarkMode?dark_font_grey_color:underLineGreyColor

                                                            ))),
                                                    child: new TextField(
                                                        textInputAction:
                                                        TextInputAction.done,
                                                        onSubmitted:
                                                            (onSummitValue) {
                                                          value.setCategoryType(type);
                                                          _showCategoryBottomSheet();
                                                        },
                                                        onTap: () {
                                                          Timer.run(() {
                                                            _showAccountBottomSheet();
                                                          });
                                                        },
                                                        style: TextStyle(
                                                            color: ConstantUtils
                                                                .isDarkMode
                                                                ? Colors.white
                                                                : Colors.black),
                                                        controller:
                                                        _accountController
                                                            .accountController,
                                                        readOnly: true,
                                                        autofocus: false,
                                                        showCursor: true,
                                                        decoration:
                                                        InputDecoration(
                                                          errorText: isFromAccount
                                                              ? 'From Account is empty'
                                                              : null,
                                                          border:
                                                          InputBorder.none,
                                                        )))
                                            ))
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          flex: 5,
                                          child: Text(
                                            'To'.tr,
                                            style: TextStyle(
                                                color:
                                                ConstantUtils.isDarkMode
                                                    ? dark_font_grey_color
                                                    : fontGreyColor),
                                          ),
                                        ),
                                        Flexible(
                                            flex: 18,
                                            child: new Theme(
                                                data: new ThemeData(
                                                  primaryColor:
                                                  Colors.orangeAccent,
                                                  primaryColorDark:
                                                  Colors.orange,
                                                ),
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                width: 1.0,
                                                                color:
                                                                ConstantUtils.isDarkMode?dark_font_grey_color:underLineGreyColor

                                                            ))),
                                                    child:  new TextField(
                                                      focusNode: toAccountFocus,
                                                      textInputAction:
                                                      TextInputAction.done,
                                                      style: TextStyle(
                                                          color: ConstantUtils
                                                              .isDarkMode
                                                              ? Colors.white
                                                              : Colors.black),
                                                      onTap: () {
                                                        Timer.run(() {
                                                          _showToAccountBottomSheet();
                                                          // _showAccountBottomSheet();
                                                        });
                                                      },
                                                      readOnly: true,
                                                      autofocus: false,
                                                      showCursor: true,
                                                      controller:
                                                      _accountController
                                                          .toController,
                                                      decoration: new InputDecoration(
                                                          errorText: isToAccount
                                                              ? 'To Account is empty'
                                                              : null,
                                                          border:
                                                          InputBorder.none),
                                                    ))))
                                      ],
                                    )
                                  ],
                                )
                                    : Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          flex: 5,
                                          child: Text(
                                            'Account'.tr,
                                            style: TextStyle(
                                                color:
                                                ConstantUtils.isDarkMode
                                                    ? dark_font_grey_color
                                                    : fontGreyColor),
                                          ),
                                        ),
                                        Flexible(
                                            flex: 18,
                                            child: new Theme(
                                                data: new ThemeData(
                                                  primaryColor:
                                                  Colors.orangeAccent,
                                                  primaryColorDark:
                                                  Colors.orange,
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              width: 1.0,
                                                              color:
                                                              ConstantUtils.isDarkMode?dark_font_grey_color:underLineGreyColor

                                                          ))),
                                                  child: new TextField(
                                                    textInputAction:
                                                    TextInputAction.done,
                                                    onSubmitted:
                                                        (onSummitValue) {
                                                      value.setCategoryType(type);
                                                      _showCategoryBottomSheet();
                                                    },
                                                    onTap: () {
                                                      Timer.run(() {
                                                        _showAccountBottomSheet();
                                                      });
                                                    },
                                                    style: TextStyle(
                                                        color: ConstantUtils
                                                            .isDarkMode
                                                            ? Colors.white
                                                            : Colors.black),
                                                    controller:
                                                    _accountController
                                                        .accountController,
                                                    focusNode: accountFocus,
                                                    readOnly: true,
                                                    showCursor: true,
                                                    decoration:
                                                    new InputDecoration(
                                                      errorText: isFromAccount
                                                          ? 'Account is empty'
                                                          : null,
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                )))
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          flex: 5,
                                          child: Text(
                                            'Category'.tr,
                                            style: TextStyle(
                                                color:
                                                ConstantUtils.isDarkMode
                                                    ? dark_font_grey_color
                                                    : fontGreyColor),
                                          ),
                                        ),
                                        Flexible(
                                            flex: 18,
                                            child: new Theme(
                                                data: new ThemeData(
                                                  primaryColor:
                                                  Colors.orangeAccent,
                                                  primaryColorDark:
                                                  Colors.orange,
                                                ),
                                                child:  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                width: 1.0,
                                                                color:
                                                                ConstantUtils.isDarkMode?dark_font_grey_color:underLineGreyColor

                                                            ))),
                                                    child:new TextField(
                                                      focusNode: categoryFocus,
                                                      textInputAction:
                                                      TextInputAction.done,
                                                      onSubmitted:
                                                          (onSummitValue) {},
                                                      onTap: () {
                                                        Timer.run(() {
                                                          value.setCategoryType(type);
                                                          _showCategoryBottomSheet();
                                                        });
                                                      },
                                                      style: TextStyle(
                                                          color: ConstantUtils
                                                              .isDarkMode
                                                              ? Colors.white
                                                              : Colors.black),
                                                      readOnly: true,
                                                      showCursor: true,
                                                      controller:
                                                      _accountController
                                                          .categoryController,
                                                      decoration:
                                                      new InputDecoration(
                                                        errorText: isCategory
                                                            ? 'Category is empty'
                                                            : null,
                                                        border: InputBorder.none,
                                                      ),
                                                    ))))
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 5,
                                      child: Text(
                                        'Amount'.tr,
                                        style: TextStyle(
                                            color: ConstantUtils.isDarkMode
                                                ? dark_font_grey_color
                                                : fontGreyColor),
                                      ),
                                    ),
                                    Flexible(
                                        flex: 18,
                                        child: new Theme(
                                            data: new ThemeData(
                                              primaryColor: Colors.orangeAccent,
                                              primaryColorDark: Colors.orange,
                                            ),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            width: 1.0,
                                                            color:
                                                            ConstantUtils.isDarkMode?dark_font_grey_color:underLineGreyColor

                                                        ))),
                                                child: new TextField(
                                                  focusNode: amountFocus,
                                                  style: TextStyle(
                                                      color: ConstantUtils.isDarkMode
                                                          ? Colors.white
                                                          : Colors.black),
                                                  keyboardType: TextInputType.number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  onTap: (){
                                                    setState(() {
                                                      _closeAccountBottomSheet();
                                                      _closeCategoryBottomSheetController();
                                                      _closeDateBottomSheetController();
                                                      _closeToAccountBottomSheet();

                                                    });
                                                  },
                                                  onChanged: (string) {
                                                    try {
                                                      String _formatNumber(String s) =>
                                                                                                              NumberFormat.decimalPattern(
                                                                                                                  'en_US')
                                                                                                                  .format(int.parse(s));
                                                      string =
                                                                                                          '${_formatNumber(string.replaceAll(',', ''))}';
                                                    } catch (e) {
                                                      print(e);
                                                    }
                                                    value.transactionAmountController
                                                        .value = TextEditingValue(
                                                      text: string,
                                                      selection:
                                                      TextSelection.collapsed(
                                                          offset: string.length),
                                                    );
                                                    if (string.isNotEmpty) {
                                                      setState(() {
                                                        isAmount = false;
                                                      });
                                                    }
                                                  },
                                                  controller:
                                                  value.transactionAmountController,
                                                  showCursor: true,
                                                  decoration: new InputDecoration(
                                                      errorText: isAmount
                                                          ? 'Amount is empty'
                                                          : null,
                                                      border: InputBorder.none),
                                                  onSubmitted: (_submmit)async{
                                                    SharedPreferences pref=await SharedPreferences.getInstance();
                                                    String selectedLan=pref.getString(Lang).toString();

                                                    print('Account amountsubmit: $_submmit');
                                                    print('Account amountsubmit userguide: $isUserGuideSelected');

                                                    if(_submmit.isNotEmpty && isUserGuideSelected && isIncomeTypeSave.isEmpty){
                                                      userGuideData(_submmit,selectedLan=='English'?'assets/icon/income/save-eng.svg': 'assets/icon/income/save.svg', 'income-save');
                                                    }else if(_submmit.isNotEmpty && isUserGuideSelected && isIncomeTypeSave== IncomeTypeSave_UserGuide){
                                                      userGuideData(_submmit,selectedLan=='English'?'assets/icon/income/save-eng.svg': 'assets/icon/income/save.svg', 'expense-save');
                                                    }
                                                  },
                                                )
                                            )))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 5,
                                      child: Text(
                                        'Note'.tr,
                                        style: TextStyle(
                                            color: ConstantUtils.isDarkMode
                                                ? dark_font_grey_color
                                                : fontGreyColor),
                                      ),
                                    ),
                                    Flexible(
                                        flex: 18,
                                        child: new Theme(
                                            data: new ThemeData(
                                              primaryColor: Colors.orangeAccent,
                                              primaryColorDark: Colors.orange,
                                            ),
                                            child:  Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            width: 1.0,
                                                            color:
                                                            ConstantUtils.isDarkMode?dark_font_grey_color:underLineGreyColor

                                                        ))),
                                                child:new TextField(
                                                  style: TextStyle(
                                                      color: ConstantUtils.isDarkMode
                                                          ? Colors.white
                                                          : Colors.black),
                                                  controller:
                                                  value.transactionNoteController,
                                                  onTap: (){
                                                    setState(() {
                                                      _closeAccountBottomSheet();
                                                      _closeCategoryBottomSheetController();
                                                      _closeDateBottomSheetController();
                                                      _closeToAccountBottomSheet();
                                                    });
                                                  },
                                                  autofocus: false,
                                                  decoration: new InputDecoration(
                                                      border: InputBorder.none),
                                                ))))
                                  ],
                                ),
                                SizedBox(height: 20,)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Container(
                            color: ConstantUtils.isDarkMode
                                ? dark_nav_color
                                : Colors.white,
                            child: Column(
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Container(
                                      child: TextButton(
                                        style: ButtonStyle(
                                          padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                              EdgeInsets.all(3)),
                                          backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              ConstantUtils.isDarkMode
                                                  ? dark_nav_color
                                                  : Colors.white),
                                          foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10.0),
                                                  side: BorderSide(
                                                      color: Colors.grey))),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _showPicker(context);
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              (_urlImageEncode == null ||
                                                  _urlImageEncode!.isEmpty)
                                                  ? Text(
                                                'Description'.tr,
                                                style: TextStyle(
                                                    color: ConstantUtils
                                                        .isDarkMode
                                                        ? dark_font_grey_color
                                                        : fontGreyColor),
                                              )
                                                  : Container(
                                                width:
                                                getProportionateScreenWidth(
                                                    200),
                                                height:
                                                getProportionateScreenHeight(
                                                    150),
                                                child: Image.memory(
                                                  decodeImage(_urlImageEncode
                                                      .toString()),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Icon(
                                                Icons.photo_camera,
                                                color: fontGreyColor,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )),
                                Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: getProportionateScreenWidth(250),
                                          child: TextButton(
                                              style: ButtonStyle(
                                                padding: MaterialStateProperty.all<
                                                    EdgeInsets>(EdgeInsets.all(3)),
                                                backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                                    ConstantUtils.isDarkMode
                                                        ? dark_nav_color
                                                        : Colors.white),
                                                foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.black),
                                                shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                        side: BorderSide(
                                                            color: saveBtnClick
                                                                ? themeColor
                                                                : Colors.grey))),
                                              ),
                                              onPressed: () async {
                                                isLoading=true;
                                                setState(() {

                                                });
                                                SharedPreferences preferences =
                                                await SharedPreferences
                                                    .getInstance();
                                                var createdBy = await preferences
                                                    .getString(mProfileId);
                                                var createdAt = DateTime.now();
                                                if(isUserGuideSelected && isIncomeTypeSave.isEmpty){
                                                  preferences.setString(IncomeTypeSave_UserGuide,IncomeTypeSave_UserGuide);
                                                } if(isUserGuideSelected && isIncomeTypeSave== IncomeTypeSave_UserGuide){
                                                  preferences.setString(ExpenseTypeSave_UserGuide,ExpenseTypeSave_UserGuide);
                                                  preferences.setBool(isUserGuideWork, false);
                                                }

                                                saveBtnClick = true;
                                                deleteBtnClick = false;

                                                if (_urlImageEncode == null) {
                                                  _urlImageEncode = '';
                                                }
                                                var _monthYear = ConstantUtils
                                                    .monthFormatter
                                                    .format(DateTime.parse(
                                                    selectedDate));
                                                _amount = value
                                                    .transactionAmountController
                                                    .text;

                                                if (_amount.contains(',')) {
                                                  _amount =
                                                      _amount.replaceAll(',', '');
                                                }

                                                if (dailyId.isNotEmpty) {
                                                  dailyId = await value
                                                      .selectDailyId(dailyId);
                                                } else {
                                                  dailyId =
                                                  await value.selectDailyByDate(
                                                      selectedDate);
                                                }
                                                var id = transactionId;
                                                var transferExpenseId;
                                                var transferIncomeId;
                                                if (id.isEmpty) {
                                                  id = Uuid().v1();
                                                  transferExpenseId=Uuid().v1()+'tranEx';
                                                  transferIncomeId=Uuid().v1()+'tranIn';
                                                } else {
                                                  dailyId = await value
                                                      .selectTransactionById(id,
                                                      selectedDate, dailyId);
                                                }
                                                if (type == TransferType) {
                                                  if (_accountController
                                                      .accountController
                                                      .text
                                                      .isEmpty ||
                                                      _accountController
                                                          .toController
                                                          .text
                                                          .isEmpty ||
                                                      value
                                                          .transactionAmountController
                                                          .text
                                                          .isEmpty) {
                                                    setState(() {
                                                      _accountController
                                                          .accountController
                                                          .text
                                                          .isEmpty
                                                          ? isFromAccount = true
                                                          : isFromAccount = false;
                                                      _accountController
                                                          .toController
                                                          .text
                                                          .isEmpty
                                                          ? isToAccount = true
                                                          : isToAccount = false;
                                                      value.transactionAmountController
                                                          .text.isEmpty
                                                          ? isAmount = true
                                                          : isAmount = false;
                                                    });
                                                  } else {
                                                    TBL_DailyDetail transaction = new TBL_DailyDetail(
                                                        id: id,
                                                        date: selectedDate,
                                                        monthYear: _monthYear,
                                                        dailyId: dailyId,
                                                        toAccountName:
                                                        _accountController
                                                            .toController.text,
                                                        toAccountId: _accountController
                                                            .toAccountId,
                                                        accountName:
                                                        _accountController
                                                            .accountController
                                                            .text,
                                                        categoryName: '',
                                                        accountId:
                                                        _accountController
                                                            .accountId,
                                                        categoryId: '',
                                                        amount: _amount,
                                                        note: value
                                                            .transactionNoteController
                                                            .text,
                                                        type: type,
                                                        bookmark: '',
                                                        image: _urlImageEncode
                                                            .toString(),
                                                        isUpload: 'false',
                                                        isActive: '1',
                                                        createdAt:
                                                        createdAt.toString(),
                                                        createdBy:
                                                        createdBy.toString(),
                                                        updatedAt:
                                                        createdAt.toString(),
                                                        updatedBy:
                                                        createdBy.toString(),
                                                        other: '');
                                                    value.saveDailyDetail(
                                                        transaction, context);
                                                    _accountController.accountController.clear();
                                                    _accountController.categoryController.clear();
                                                    _accountController.amountController.clear();
                                                    _accountController
                                                        .toController.clear();
                                                    _commonController.transactionNoteController.clear();
                                                    preferences.setString(selected_date,'');
                                                    preferences.setString(selected_type, '');
                                                    preferences.setString(selected_img, '');

                                                  }
                                                } else {
                                                  if (_accountController
                                                      .accountId.isEmpty  ||
                                                      _accountController
                                                          .categoryId.isEmpty ||
                                                      _amount.isEmpty) {
                                                    _accountController
                                                        .accountController
                                                        .text
                                                        .isEmpty
                                                        ? isFromAccount = true
                                                        : isFromAccount = false;
                                                    _accountController
                                                        .categoryController
                                                        .text
                                                        .isEmpty
                                                        ? isCategory = true
                                                        : isCategory = false;
                                                    value.transactionAmountController
                                                        .text.isEmpty
                                                        ? isAmount = true
                                                        : isAmount = false;
                                                  } else {
                                                    TBL_DailyDetail transaction = new TBL_DailyDetail(
                                                        id: id,
                                                        date: selectedDate,
                                                        monthYear: _monthYear,
                                                        dailyId: dailyId,
                                                        toAccountName: '',
                                                        toAccountId: '',
                                                        accountName:
                                                        _accountController
                                                            .accountController
                                                            .text,
                                                        categoryName:
                                                        _accountController
                                                            .categoryController
                                                            .text,
                                                        accountId: _accountController
                                                            .accountId,
                                                        categoryId:
                                                        _accountController
                                                            .categoryId,
                                                        amount: _amount,
                                                        note: value
                                                            .transactionNoteController
                                                            .text,
                                                        type: type,
                                                        bookmark: '',
                                                        image: _urlImageEncode
                                                            .toString(),
                                                        isUpload: 'false',
                                                        isActive: '1',
                                                        createdAt:
                                                        createdAt.toString(),
                                                        createdBy:
                                                        createdBy.toString(),
                                                        updatedAt:
                                                        createdAt.toString(),
                                                        updatedBy:
                                                        createdBy.toString(),
                                                        other: '');
                                                    value.saveDailyDetail(
                                                        transaction, context);
                                                    _accountController.accountController.clear();
                                                    _accountController.categoryController.clear();
                                                    _accountController.amountController.clear();
                                                    _commonController.transactionNoteController.clear();
                                                    _accountController
                                                        .toController.clear();
                                                    preferences.setString(selected_date,'');
                                                    preferences.setString(selected_type, '');
                                                    preferences.setString(selected_img, '');

                                                  }
                                                }
                                                _sendAnalyticsEvent('Transaction${type}Event');

                                              },
                                              child: Text('Save'.tr,
                                                  style: TextStyle(
                                                      color: saveBtnClick
                                                          ? themeColor
                                                          : fontGreyColor))),
                                        ),
                                        SizedBox(
                                          width: 1,
                                        ),
                                        Container(
                                          width: getProportionateScreenWidth(100),
                                          child: TextButton(
                                              style: ButtonStyle(
                                                padding: MaterialStateProperty.all<
                                                    EdgeInsets>(EdgeInsets.all(3)),
                                                backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                                    ConstantUtils.isDarkMode
                                                        ? dark_nav_color
                                                        : Colors.white),
                                                foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.black),
                                                shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                        side: BorderSide(
                                                            color: deleteBtnClick
                                                                ? themeColor
                                                                : Colors.grey))),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  saveBtnClick = false;
                                                  deleteBtnClick = true;
                                                  if (transactionId.isNotEmpty) {
                                                    value.deleteTransaction(
                                                        transactionId);
                                                  }
                                                });
                                              },
                                              child: Text(
                                                'Delete'.tr,
                                                style: TextStyle(
                                                    color: deleteBtnClick
                                                        ? themeColor
                                                        : ConstantUtils.isDarkMode
                                                        ? dark_font_grey_color
                                                        : Colors.black),
                                              )),
                                        )
                                      ],
                                    ))
                              ],
                            )),

                      ],
                    )
                );
              },
            )));
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
  void _showPicker(context) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext bc) {
          return CupertinoActionSheet(
            actions: <Widget>[
              new Wrap(
                children: <Widget>[
                  CupertinoActionSheetAction(
                    onPressed: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: new Text(
                        'Camera'.tr,
                        style: TextStyle(
                            color: ConstantUtils.isDarkMode
                                ? dark_font_grey_color
                                : Colors.black,
                            fontSize: 14),
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color:
                    ConstantUtils.isDarkMode ? dark_nav_color : Colors.grey,
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: new Text(
                        'Gallery'.tr,
                        style: TextStyle(
                            color: ConstantUtils.isDarkMode
                                ? dark_font_grey_color
                                : Colors.black,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              child: Container(
                alignment: Alignment.center,
                child: new Text(
                  'Cancel'.tr,
                  style: TextStyle(
                      color: ConstantUtils.isDarkMode
                          ? dark_font_grey_color
                          : Colors.black,
                      fontSize: 16),
                ),
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

  void _showToAccountBottomSheet() {
    toAccountBottomSheetController=_scaffoldKey.currentState!.showBottomSheet((context) {
      return Container(
          height: 400,

          color: lightGrey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            //Get.off(()=>
                            // AccountScreen(
                            //               accountList: [],
                            //               transaction: 'transaction'));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AccountScreen(
                                        accountList: [],
                                        transaction: 'transaction'))
                            );
                          },
                          icon: Icon(Icons.edit, color: Colors.black)),
                      Spacer(),
                      Text('To Account'.tr,
                          style: TextStyle(color: Colors.black, fontSize: 18)),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AccountScreen(
                                    accountList: [],
                                    transaction: 'transaction',
                                  )),
                            );
                          },
                          icon: Icon(Icons.add, color: Colors.black)),
                      IconButton(
                          onPressed: () {
                            isDialogShow=false;
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close, color: Colors.black)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GetBuilder<AccountController>(
                  init: AccountController(),
                  builder: (value) {
                    return _accountController.accountList.length > 0
                        ? GridView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: ScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 100,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20),
                        itemCount: _accountController.accountList.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return Padding(
                            padding: EdgeInsets.all(1),
                            child: Container(
                              child: TextButton(
                                style: ButtonStyle(
                                  padding:
                                  MaterialStateProperty.all<EdgeInsets>(
                                      EdgeInsets.all(3)),
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.white),
                                  foregroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.black),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(12.0),
                                          side: BorderSide(
                                              color: themeColor))),
                                ),
                                onPressed: () {
                                  setState(() {
                                    Navigator.pop(context);
                                    setState(() {
                                      _accountController.toController
                                          .clear();
                                      _accountController.setToAccountId(
                                          _accountController
                                              .accountList[index].id);
                                      _accountController.toController.text =
                                          _accountController
                                              .accountList[index].name;
                                      if (_accountController
                                          .toController.text.isNotEmpty) {
                                        isToAccount = false;
                                      }
                                    });
                                  });
                                },
                                child: Padding(
                                    padding: EdgeInsets.all(3),
                                    child: Text(_accountController
                                        .accountList[index].name)),
                              ),
                            ),
                          );
                        })
                        : Container();
                  },
                )
              ],
            ),
          ));
    });

  }

  void _showAccountBottomSheet() {

    accountBottomSheetController=_scaffoldKey.currentState!.showBottomSheet<Null>((context) {
      return Container(
          height: 400,
          color: ConstantUtils.isDarkMode ? dark_background_color : lightGrey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen(selectedMenu: 'accounts', showInterstitial: false,)),
                            );
                          },
                          icon: Icon(Icons.edit,
                              color: ConstantUtils.isDarkMode
                                  ? dark_font_grey_color
                                  : Colors.black)),
                      Spacer(),
                      Text('Account'.tr,
                          style: TextStyle(
                              color: ConstantUtils.isDarkMode
                                  ? dark_font_grey_color
                                  : Colors.black,
                              fontSize: 18)),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            Get.off(()=>
                                AccountScreen(
                                  accountList: [],
                                  transaction: 'transaction',
                                )
                            );
                            setState(() {
                              _sendAnalyticsEvent(account_screen);

                            });

                          },
                          icon: Icon(Icons.add,
                              color: ConstantUtils.isDarkMode
                                  ? dark_font_grey_color
                                  : Colors.black)),
                      IconButton(
                          onPressed: () {
                            isDialogShow=false;
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close,
                              color: ConstantUtils.isDarkMode
                                  ? dark_font_grey_color
                                  : Colors.black)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GetBuilder<AccountController>(
                  init: AccountController(),
                  builder: (value) {
                    return value.accountList.length > 0
                        ? GridView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: ScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 100,
                            childAspectRatio: 3/2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20),
                        itemCount: _accountController.accountList.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return Padding(
                              padding: EdgeInsets.all(1),
                              child: Container(
                                child: TextButton(
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all<
                                        EdgeInsets>(EdgeInsets.all(3)),
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        ConstantUtils.isDarkMode
                                            ? dark_nav_color
                                            : Colors.white),
                                    foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(12.0),
                                            side: BorderSide(
                                                color:
                                                ConstantUtils.isDarkMode
                                                    ? dark_border_color
                                                    : themeColor))),
                                  ),
                                  onPressed: () async{
                                    SharedPreferences pref=await SharedPreferences.getInstance();
                                    String selectedLan=pref.getString(Lang).toString();
                                    setState(() {
                                        _accountController.accountController
                                            .clear();
                                        _accountController.setAccountId(
                                            _accountController
                                                .accountList[index].id);
                                        _accountController
                                            .accountController.text =
                                            _accountController
                                                .accountList[index].name;
                                        if(isUserGuideSelected && isIncomeTypeSave.isEmpty){
                                          userGuideData(_accountController.accountController.text,selectedLan=='English'?'assets/icon/income/income-category-eng.svg':'assets/icon/income/income-category.svg','income-category');
                                        }else if(isUserGuideSelected && isIncomeTypeSave==IncomeTypeSave_UserGuide){
                                          userGuideData(_accountController.accountController.text,selectedLan=='English'?'assets/icon/expense/expense-category-eng.svg':'assets/icon/expense/expense-category.svg','expense-category');
                                        }
                                        if (_accountController
                                            .accountController
                                            .text
                                            .isNotEmpty) {
                                          isFromAccount = false;
                                        }
                                        Navigator.pop(context);

                                    });
                                  },
                                  child: Padding(
                                      padding: EdgeInsets.all(3),
                                      child: Text(
                                        _accountController
                                            .accountList[index].name,
                                        style: TextStyle(
                                            color: ConstantUtils.isDarkMode
                                                ? dark_font_grey_color
                                                : Colors.black),
                                      )),
                                ),
                              ));
                        })
                        : Container();
                  },
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ));
    });
  }
  void userGuideData(String data,String image,String selectedType)async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    String selectedLan=pref.getString(Lang).toString();
    if(data.isNotEmpty){
      Timer(Duration(seconds: 0),(){
        Navigator.of(context).push(UserGuideState(img:image,skipName:selectedType,onCountChange: (bool res) {
          setState(() {
            print('isUserGuide res2: $res');
            if(res){
              if(selectedType.contains('income')){
                type=IncomeType;
                if (type == IncomeType) {
                  isClickedIncome = true;
                  isClickedExpense = false;
                  isClickedTransfer = false;
                } else if (type == ExpenseType) {
                  type=ExpenseType;
                  isClickedIncome = false;
                  isClickedExpense = true;
                  isClickedTransfer = false;
                } else {
                  type=TransferType;
                  isClickedIncome = false;
                  isClickedExpense = false;
                  isClickedTransfer = true;
                }
              }else if(selectedType.contains('expense')){
                type=ExpenseType;
                if (type == ExpenseType) {
                  isClickedIncome = false;
                  isClickedExpense = true;
                  isClickedTransfer = false;
                } else if (type == IncomeType) {
                  type=IncomeType;
                  isClickedIncome = true;
                  isClickedExpense = false;
                  isClickedTransfer = false;
                } else {
                  type=TransferType;
                  isClickedIncome = false;
                  isClickedExpense = false;
                  isClickedTransfer = true;
                }
              }
              if(selectedType=='income-category'){
                categoryFocus!.requestFocus();
                _commonController.setCategoryType(type);
                _showCategoryBottomSheet();
              }
              if(selectedType=='income-amount'){
                amountFocus!.requestFocus();
              }
              if(selectedType=='expense-category'){
                categoryFocus!.requestFocus();
                _commonController.setCategoryType(type);
                _showCategoryBottomSheet();
              }
              if(selectedType=='expense-amount'){
                amountFocus!.requestFocus();
              }

            }
          });
        },
          onSkipChange: (String name)async{
          print('SkipChangedData: $name');
          SharedPreferences prefs=await SharedPreferences.getInstance();
          if(pref.getBool(isUserGuideWork) !=null){
            isUserGuideSelected=pref.getBool(isUserGuideWork)!;
          }
          if(name.contains('income')){
            type=IncomeType;
            if (type == IncomeType) {
              isClickedIncome = true;
              isClickedExpense = false;
              isClickedTransfer = false;
            } else if (type == ExpenseType) {
              type=ExpenseType;
              isClickedIncome = false;
              isClickedExpense = true;
              isClickedTransfer = false;
            } else {
              type=TransferType;
              isClickedIncome = false;
              isClickedExpense = false;
              isClickedTransfer = true;
            }
          }else if(name.contains('expense')){
            type=ExpenseType;
            if (type == ExpenseType) {
              isClickedIncome = false;
              isClickedExpense = true;
              isClickedTransfer = false;
            } else if (type == IncomeType) {
              type=IncomeType;
              isClickedIncome = true;
              isClickedExpense = false;
              isClickedTransfer = false;
            } else {
              type=TransferType;
              isClickedIncome = false;
              isClickedExpense = false;
              isClickedTransfer = true;
            }
          }
          if(name=='expense-account'){
            accountFocus!.requestFocus();
            _showAccountBottomSheet();

          }
            if(name=='income-category'){
              _closeCategoryBottomSheetController();
              _closeAccountBottomSheet();
              userGuideData(name,selectedLan=='English'? 'assets/icon/income/income-amount-eng.svg':'assets/icon/income/income-amount.svg', 'income-amount');

            }
          if(name=='expense-category'){
            _closeCategoryBottomSheetController();
            _closeAccountBottomSheet();
            userGuideData(name,selectedLan=='English'?'assets/icon/expense/expense-amount-eng.svg': 'assets/icon/expense/expense-amount.svg', 'expense-amount');

          }
            if(name=='income-amount'){
              userGuideData(name,selectedLan=='English'?'assets/icon/income/save-eng.svg': 'assets/icon/income/save.svg', 'income-save');

            }
          if(name=='expense-amount'){
            prefs.setString(ExpenseTypeSave_UserGuide,ExpenseTypeSave_UserGuide);
            prefs.setBool(isUserGuideWork, false);
            userGuideData(name, selectedLan=='English'?'assets/icon/income/save-eng.svg':'assets/icon/income/save.svg', 'expense-save');
          }
            if(name=='income-save'){
              String selectedLan=prefs.getString(Lang).toString();
              debugPrint('isUserGuide Income Save: $isUserGuideSelected');

              isUserGuide(selectedLan=='English'?'assets/icon/expense/expense-account-eng.svg':'assets/icon/expense/expense-account.svg',ExpenseType,'expense-account');

            }

          }
        ));
      });
    }

  }

  void _showCategoryBottomSheet() {
    //FocusManager.instance.dispose();
    // FocusScopeNode currentFocus = FocusScope.of(context);
    // if (currentFocus.hasFocus) {
    //   currentFocus.unfocus();
    // }
    categoryBottomSheetController= _scaffoldKey.currentState!.showBottomSheet((context) {
      return new Container(
          color: ConstantUtils.isDarkMode ? dark_background_color : lightGrey,
          height: 400,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CategoryDetailPage(
                                    type: type,
                                  )),
                            );
                          },
                          icon: Icon(Icons.edit,
                              color: ConstantUtils.isDarkMode
                                  ? dark_font_grey_color
                                  : Colors.black)),
                      Spacer(),
                      Text('Category'.tr,
                          style: TextStyle(
                              color: ConstantUtils.isDarkMode
                                  ? dark_font_grey_color
                                  : Colors.black,
                              fontSize: 18)),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            _sendAnalyticsEvent(category_screen);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CategoryScreen(
                                    categoryList: [], type: type, transaction:'transaction',)),
                            );
                          },
                          icon: Icon(Icons.add,
                              color: ConstantUtils.isDarkMode
                                  ? dark_font_grey_color
                                  : Colors.black)),
                      IconButton(
                          onPressed: () {
                            isDialogShow=false;
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close,
                              color: ConstantUtils.isDarkMode
                                  ? dark_font_grey_color
                                  : Colors.black)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GetBuilder<TransactionController>(builder: (value) {
                  return value.categoryList.length > 0
                      ? GridView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: ScrollPhysics(),
                      gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 100,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20),
                      itemCount: value.categoryList.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return Padding(
                            padding: EdgeInsets.all(5),
                            child: Container(
                              child: TextButton(
                                style: ButtonStyle(
                                  padding:
                                  MaterialStateProperty.all<EdgeInsets>(
                                      EdgeInsets.all(3)),
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                      ConstantUtils.isDarkMode
                                          ? Colors.black
                                          : Colors.white),
                                  foregroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.black),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(12.0),
                                          side: BorderSide(
                                              color:
                                              ConstantUtils.isDarkMode
                                                  ? dark_border_color
                                                  : themeColor))),
                                ),
                                onPressed: ()async {
                                  SharedPreferences pref=await SharedPreferences.getInstance();
                                  String selectedLan=pref.getString(Lang).toString();
                                  setState(() {
                                    Navigator.pop(context);
                                    setState(() {
                                      _accountController.categoryController
                                          .clear();
                                      _accountController.setCategoryId(
                                          value.categoryList[index].id);
                                      _accountController
                                          .categoryController.text =
                                          value.categoryList[index].name;
                                      if (_accountController
                                          .categoryController
                                          .text
                                          .isNotEmpty) {
                                        isCategory = false;
                                        if(isUserGuideSelected && isIncomeTypeSave.isEmpty){
                                          userGuideData(_accountController.categoryController.text, selectedLan=='English'?'assets/icon/income/income-amount-eng.svg':'assets/icon/income/income-amount.svg', 'income-amount');
                                        }else if(isUserGuideSelected && isIncomeTypeSave==IncomeTypeSave_UserGuide){
                                          userGuideData(_accountController.categoryController.text,selectedLan=='English'?'assets/icon/expense/expense-amount-eng.svg':'assets/icon/expense/expense-amount.svg','expense-amount');
                                        }
                                      }
                                    });
                                  });
                                },
                                child: Padding(
                                    padding: EdgeInsets.all(3),
                                    child: Text(
                                      value.categoryList[index].name,
                                      style: TextStyle(
                                          color: ConstantUtils.isDarkMode
                                              ? dark_font_grey_color
                                              : Colors.black),
                                    )),
                              ),
                            ));
                      })
                      : Container();
                }),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ));
    });
  }

  void _showDateBottomSheet() {
    FocusManager.instance.primaryFocus?.unfocus();
    dateBottomSheetController=_scaffoldKey.currentState!.showBottomSheet((context) {
      return Container(
        color: ConstantUtils.isDarkMode ? dark_background_color : Colors.white,
        height: 400,
        child: Calendar(
          onDateSelected: _handleNewDate,
          startOnMonday: true,
          weekDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
          events: _events,
          isExpandable: false,
          eventDoneColor: Colors.green,
          selectedColor: Colors.pink,
          todayColor: Colors.red,
          eventColor: ConstantUtils.isDarkMode ? Colors.red : Colors.grey,
          locale: 'en_US',
          todayButtonText: '',
          isExpanded: true,
          expandableDateFormat: 'EEEE, dd. MMMM yyyy',
          dayOfWeekStyle: TextStyle(
              color: ConstantUtils.isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 11),
        ),
      );
    });
  }
}
