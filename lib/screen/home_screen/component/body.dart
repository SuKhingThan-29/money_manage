
import 'package:AthaPyar/helper/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:AthaPyar/screen/home_screen/component/date_selection.dart';
import 'package:AthaPyar/screen/home_screen/component/tab_bar_selection.dart';
import 'home_header.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  _Body createState() => _Body();
}
class _Body extends State<Body>{
  String filePath = 'file:///android_asset/flutter_assets/assets/files/file_360_50.html';
  @override
  Widget build(BuildContext context){
    return SafeArea(

        child: Container(
          color: ConstantUtils.isDarkMode
              ? ConstantUtils.darkMode.backgroundColor
              : ConstantUtils.lightMode.backgroundColor,
          child: Column(
            children: [
              HomeHeader(),
              DateSelection(),
              TabBarSelection(),
            ],

          ),
        )
    );
  }
}