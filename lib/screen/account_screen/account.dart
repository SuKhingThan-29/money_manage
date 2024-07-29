import 'dart:async';
import 'package:AthaPyar/controller/account_controller.dart';
import 'package:AthaPyar/controller/account_group_controller.dart';
import 'package:AthaPyar/datatbase/model/tbl_account.dart';
import 'package:AthaPyar/helper/size_config.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/screen/account_screen/account_group_detail.dart';
import 'package:AthaPyar/screen/home_screen/home.dart';
import 'package:AthaPyar/screen/transaction_screen/transaction.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AccountScreen extends StatefulWidget {
  List<TBLAccount> accountList = [];
  String transaction;

  AccountScreen({required this.accountList, required this.transaction});

  @override
  _AccountScreen createState() =>
      _AccountScreen(accountList: accountList, transaction: transaction);
}

class _AccountScreen extends State<AccountScreen> {
  List<TBLAccount> accountList = [];
  String transaction;
  String accountId = '';
  String accountGroupId = '';
  bool isAccountGroup = false;
  bool isAccountName = false;
  bool isAmount = false;

  _AccountScreen({required this.accountList, required this.transaction});

  AccountController _accountController = Get.put(AccountController());
  AccountGroupController _accountGroupController =
      Get.put(AccountGroupController());

  @override
  void initState() {
    super.initState();
    _accountController.groupController.clear();
    _accountController.amountController.clear();
    _accountController.nameController.clear();
    _accountController.noteController.clear();
    _accountController.validateName = true;
    // hideStatusBar();

    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void init() async {
    if (accountList.isNotEmpty && accountList.length > 0) {
      accountId = accountList[0].id;
      accountGroupId = accountList[0].accountGroupId;
      _accountController.setAccountGroupId(accountGroupId);
      var createdBy = accountList[0].createdBy;

      var mGroupList = await _accountGroupController.selectAccountGroupId(
          accountGroupId, createdBy);
      if (mGroupList.length > 0) {
        _accountController.groupController.text = mGroupList[0].name;
        _accountController.nameController.text = accountList[0].name;
        _accountController.amountController.text = accountList[0].subAmount;
        _accountController.noteController.text = accountList[0].note;
      }
    } else {
      accountId = Uuid().v1();
      Timer.run(() {
        _accountGroupBottomSheet();
      });
    }
  }

  Future hideStatusBar() =>
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  void _accountGroupBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext buildContext) {
          return CupertinoActionSheet(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.off(() => AccountGroupDetail(accountScreen:accountScreenRoute));
                  },
                  child: Icon(
                    Icons.edit,
                    color: ConstantUtils.isDarkMode
                        ? dark_font_grey_color
                        : Colors.black,
                  ),
                ),
                Text(
                  'Account Group'.tr,
                  style: TextStyle(
                      color: ConstantUtils.isDarkMode
                          ? dark_font_grey_color
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                GestureDetector(
                  onTap: () {
                    _accountController.goToAccountGroup(accountScreenRoute);
                  },
                  child: Icon(
                    Icons.add,
                    color: ConstantUtils.isDarkMode
                        ? dark_font_grey_color
                        : Colors.black,
                  ),
                )
              ],
            ),
            actions: <Widget>[
              GetBuilder<AccountGroupController>(
                  init: AccountGroupController(),
                  builder: (value) {
                    value.init();
                    return Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: value.accountModelList.length,
                          itemBuilder: (BuildContext _context, int index) {
                            return new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CupertinoActionSheetAction(
                                    onPressed: () {
                                      setState(() {
                                        Navigator.pop(context);
                                        _accountController
                                                .groupController.text =
                                            value.accountModelList[index].name;
                                        _accountController.setAccountGroupId(
                                            value.accountModelList[index].id);
                                        _accountController
                                                .groupController.text.isEmpty
                                            ? isAccountGroup = true
                                            : isAccountGroup = false;
                                      });
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(left: 10, right: 10),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        value.accountModelList[index].name,
                                        style: TextStyle(
                                            color: ConstantUtils.isDarkMode
                                                ? dark_font_grey_color
                                                : Colors.black,
                                            fontSize: 14),
                                      ),
                                    ))
                              ],
                            );
                          }),
                    );
                  })
            ],
            cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              child: Text(
                'Cancel'.tr,
                style: TextStyle(
                    color: ConstantUtils.isDarkMode
                        ? dark_font_grey_color
                        : Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ConstantUtils.isDarkMode
            ? dark_background_color
            : light_background_color,
        appBar: AppBar(
            toolbarHeight: app_bar_height,
            automaticallyImplyLeading: false,
            backgroundColor:
                ConstantUtils.isDarkMode ? dark_nav_color : themeColor,
            centerTitle: true,
            title: Text(
              'Account'.tr,
              style: TextStyle(color: Colors.white, fontSize: app_bar_title),
            ),
            leading: IconButton(
                onPressed: () {
                  _accountController.onBackData(context, transaction);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ))),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(0),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(spaceMedium),
                  child: InkWell(
                    onTap: () {
                      Timer.run(() {
                        _accountGroupBottomSheet();
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 5,
                          child: Text(
                            'Group'.tr,
                            style: TextStyle(
                                color: ConstantUtils.isDarkMode
                                    ? dark_font_grey_color
                                    : Colors.black),
                          ),
                        ),
                        Flexible(
                          flex: 11,
                          child: new Theme(
                              data: new ThemeData(
                                primaryColor: Colors.orangeAccent,
                                primaryColorDark: Colors.orange,
                              ),
                              child: new TextField(
                                style: TextStyle(
                                    color: ConstantUtils.isDarkMode
                                        ? dark_font_grey_color
                                        : Colors.black),
                                textInputAction: TextInputAction.done,
                                onTap: () {
                                  Timer.run(() {
                                    _accountGroupBottomSheet();
                                  });
                                },
                                controller: _accountController.groupController,
                                readOnly: true,
                                autofocus: false,
                                showCursor: true,
                                decoration: new InputDecoration(
                                  errorText: isAccountGroup
                                      ? 'Account Group is empty'
                                      : null,
                                  border: InputBorder.none,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(spaceMedium),
                  height: getProportionateScreenHeight(70),
                  color:
                      ConstantUtils.isDarkMode ? dark_nav_color : Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 5,
                        child: Text(
                          'Name'.tr,
                          style: TextStyle(
                              color: ConstantUtils.isDarkMode
                                  ? dark_font_grey_color
                                  : Colors.black),
                        ),
                      ),
                      Flexible(
                          flex: 11,
                          child: new Theme(
                              data: new ThemeData(
                                primaryColor: Colors.orangeAccent,
                                primaryColorDark: Colors.orange,
                              ),
                              child: new TextField(
                                style: TextStyle(
                                    color: ConstantUtils.isDarkMode
                                        ? dark_font_grey_color
                                        : Colors.black),
                                textInputAction: TextInputAction.done,
                                onSubmitted: (onSummitValue) {},
                                onTap: () {},
                                onChanged: (nameValue) {
                                  setState(() {
                                    if (nameValue.isNotEmpty) {
                                      isAccountName = false;
                                    }
                                  });
                                },
                                autofocus: false,
                                showCursor: true,
                                controller: _accountController.nameController,
                                decoration: new InputDecoration(
                                    errorText:
                                        isAccountName ? 'Name is empty' : null,
                                    border: InputBorder.none),
                              )))
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(spaceMedium),
                  height: getProportionateScreenHeight(70),
                  color: ConstantUtils.isDarkMode
                      ? dark_background_color
                      : light_background_color,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 5,
                        child: Text(
                          'Amount'.tr,
                          style: TextStyle(
                              color: ConstantUtils.isDarkMode
                                  ? dark_font_grey_color
                                  : Colors.black),
                        ),
                      ),
                      Flexible(
                          flex: 11,
                          child: new Theme(
                              data: new ThemeData(
                                primaryColor: Colors.orangeAccent,
                                primaryColorDark: Colors.orange,
                              ),
                              child: new TextField(
                                style: TextStyle(
                                    color: ConstantUtils.isDarkMode
                                        ? dark_font_grey_color
                                        : Colors.black),
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (onSummitValue) {},
                                onChanged: (string) {
                                  setState(() {
                                    try {
                                      String _formatNumber(String s) =>
                                          NumberFormat.decimalPattern('en_US')
                                              .format(int.parse(s));
                                      string =
                                          '${_formatNumber(string.replaceAll(',', ''))}';
                                      _accountController.amountController
                                          .value = TextEditingValue(
                                        text: string,
                                        selection: TextSelection.collapsed(
                                            offset: string.length),
                                      );
                                      if (string.isNotEmpty) {
                                        isAmount = false;
                                      }
                                    } catch (e) {
                                      print(e);
                                    }
                                  });
                                },
                                onTap: () {},
                                autofocus: false,
                                showCursor: true,
                                controller: _accountController.amountController,
                                decoration: new InputDecoration(
                                    errorText:
                                        isAmount ? 'Amount is empty' : null,
                                    border: InputBorder.none),
                              )))
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(spaceMedium),
                  height: getProportionateScreenHeight(70),
                  color: ConstantUtils.isDarkMode ? dark_nav_color : lightGrey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 5,
                        child: Text(
                          'Note'.tr,
                          style: TextStyle(
                              color: ConstantUtils.isDarkMode
                                  ? dark_font_grey_color
                                  : Colors.black),
                        ),
                      ),
                      Flexible(
                          flex: 11,
                          child: new Theme(
                              data: new ThemeData(
                                primaryColor: Colors.orangeAccent,
                                primaryColorDark: Colors.orange,
                              ),
                              child: new TextField(
                                style: TextStyle(
                                    color: ConstantUtils.isDarkMode
                                        ? dark_font_grey_color
                                        : Colors.black),
                                textInputAction: TextInputAction.done,
                                onSubmitted: (onSummitValue) {},
                                onTap: () {},
                                autofocus: false,
                                showCursor: true,
                                controller: _accountController.noteController,
                                decoration: new InputDecoration(
                                    border: InputBorder.none),
                              )))
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    width: getProportionateScreenWidth(360),
                    height: getProportionateScreenHeight(50),
                    child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            primary: Colors.white),
                        onPressed: () {
                          setState(() {
                            if (_accountController
                                    .groupController.text.isEmpty ||
                                _accountController
                                    .nameController.text.isEmpty ||
                                _accountController
                                    .amountController.text.isEmpty) {
                              _accountController.groupController.text.isEmpty
                                  ? isAccountGroup = true
                                  : isAccountGroup = false;
                              _accountController.nameController.text.isEmpty
                                  ? isAccountName = true
                                  : isAccountName = false;
                              _accountController.amountController.text.isEmpty
                                  ? isAmount = true
                                  : isAmount = false;
                            } else {
                              _sendAnalyticsEvent(account_btn);
                              bool isSave=true;
                              if(_accountController.accountList.length>0){
                                for(var acc in _accountController.accountList){
                                  if(acc.name== _accountController
                                      .nameController.text && acc.isActive=='1'){
                                    accountId=acc.id;
                                    print('AccountID : $accountId');
                                    isSave=false;

                                  }
                                }
                              }
                              if(isSave){
                                _accountController.saveAccount(accountId);
                                if (transaction == 'transaction') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TransactionScreen(
                                          transactionId: '',
                                          dailyId: '',
                                        )),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                            selectedMenu: 'accounts',
                                            showInterstitial: false)),
                                  );
                                }
                              }else{
                                ConstantUtils.showToast("Account Name is duplicate so cannot create.");
                              }

                            }
                          });
                        },
                        child: Text('Save'.tr))),
                //   _widgetAds250Type(context)
              ],
            )),
          ),
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

  bool validate() {
    ('validate ${_accountController.nameController.text}');
    if (_accountController.nameController.text.isEmpty) {
      _accountController.validateName = false;
      ('validate bool ${_accountController.validateName}');

      return false;
    }
    return true;
  }
}
