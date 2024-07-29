import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/screen/home_screen/component/search/search_page.dart';
import 'package:AthaPyar/screen/setting_screen/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:AthaPyar/helper/size_config.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:AthaPyar/screen/home_screen/component/search_field.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({Key? key}) : super(key: key);

  _HomeHeader createState() => _HomeHeader();
}

class _HomeHeader extends State<HomeHeader> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      height: getProportionateScreenHeight(app_bar_height),
      color: ConstantUtils.isDarkMode?dark_nav_color:themeColor,
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              iconSize: app_bar_icon_size,
              icon:  SvgPicture.asset("assets/settings/search.svg",color: Colors.white,), onPressed: () {
            Get.off(() => SearchPage());
          }),
          Text(
            "AThaByar".tr,
            style: TextStyle(
              fontSize: app_bar_title,
                color: ConstantUtils.isDarkMode
                    ? dark_font_grey_color
                    : Colors.white),
          ),
          IconButton(
            iconSize: app_bar_icon_size,
            icon: SvgPicture.asset("assets/settings/setting.svg"), onPressed: () {
            Get.off(() => SettingPage());
          },
          )
        ],
      )
    );
  }
}
