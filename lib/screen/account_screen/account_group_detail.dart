import 'package:AthaPyar/controller/account_group_controller.dart';
import 'package:AthaPyar/helper/size_config.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/screen/account_screen/account.dart';
import 'package:AthaPyar/screen/account_screen/account_group.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AccountGroupDetail extends StatefulWidget {
  String accountScreen;
  AccountGroupDetail({required this.accountScreen});
  @override
  _AccountGroupDetail createState() => _AccountGroupDetail(accountScreen:accountScreen);
}

class _AccountGroupDetail extends State<AccountGroupDetail> {
  String accountScreen;
  _AccountGroupDetail({required this.accountScreen});
  AccountGroupController _accountGroupController =
      Get.put(AccountGroupController());

  Widget onBackPressed(AccountScreen screen) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushReplacement<void, void>(
        //   context,
        //   MaterialPageRoute<void>(
        //     builder: (BuildContext context) =>  screen,
        //   ),
        //);
        Get.off(() => screen);
      },
      child:  Container(
            width: 25,
            height: 25,
            child: SvgPicture.asset(
                'assets/settings/on_back.svg'),
      )
    );
  }

  @override
  void initState() {
    super.initState();
    _accountGroupController.onInit();
    _sendAnalyticsEvent(account_group_detail_screen);

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: app_bar_height,
        automaticallyImplyLeading: false,
        backgroundColor:ConstantUtils.isDarkMode?dark_nav_color:themeColor ,
        title: Row(
          children: [

            Text(
              'Account Group'.tr,
              style: TextStyle(color: Colors.white,fontSize: app_bar_title),
            ),
            Spacer(),

            IconButton(
                onPressed: () {
                  setState(() {
                    _sendAnalyticsEvent(account_screen);
                    Get.off(() => AccountScreen(
                      accountList: [],transaction: '',
                    ));
                  });
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ))
          ],
        ),
        leading: IconButton(onPressed: (){
          setState(() {
            _sendAnalyticsEvent(account_group_screen);
            if(accountScreen==accountScreen){
              Get.off(() => AccountScreen(accountList: [], transaction: '',));

            }else{
              Get.off(() => AccountGroup(accountGroupList: [], accountGroupDetailRoute: accountGroupDetailRoute, accountScreen: '',));

            }
            // Navigator.pushReplacement<void, void>(
            //   context,
            //   MaterialPageRoute<void>(
            //     builder: (BuildContext context) =>  screen,
            //   ),
            // );

          });

        }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,),),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: GetBuilder<AccountGroupController>(
              init: AccountGroupController(),
              builder: (value) {
                return value.accountModelList.length>0?ListView.builder(
                    itemCount: value.accountModelList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actions: <Widget>[
                            IconSlideAction(
                                caption: 'Edit',
                                color: themeColor,
                                icon: Icons.edit,
                                onTap: () {
                                  try {
                                    doEdit(context, value.accountModelList[index].id,_accountGroupController.accountModelList[index].createdBy);
                                  } catch (e) {
                                    print(e);
                                  }
                                }),
                            IconSlideAction(
                                caption: 'Delete',
                                color: redColor,
                                icon: Icons.delete,
                                onTap: () {
                                  //isDeleteButtonClicked=true;

                                 doDelete(context, value.accountModelList[index].id,_accountGroupController.accountModelList[index].createdBy);
                                })
                          ],
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width:
                                        1.0,
                                        color:
                                        underLineColor))),
                            child: Row(
                              children: [
                                Container(
                                  decoration:
                                  BoxDecoration(
                                    color:
                                    redColor,
                                  ),
                                  width: 20,
                                  height:
                                  getProportionateScreenHeight(
                                      50),
                                  child:
                                  Center(
                                    child:
                                    Text(
                                      '',
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: Text(value
                                      .accountModelList[index].name),
                                )
                              ],
                            ),
                          ));
                    }):Container();
              },
            ))
          ],
        ),
      ),
    );
  }
  void doDelete(BuildContext context,String id,String createdBy){
    _accountGroupController.deleteAccountGroupId(id,createdBy);

  }
  void doEdit(BuildContext context,String id,String createdBy)async{
      _accountGroupController.updateAccountGroup(id,createdBy,accountGroupDetailRoute);

  }
}
