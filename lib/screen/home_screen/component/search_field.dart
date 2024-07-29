import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/screen/home_screen/component/search/search_page.dart';
import 'package:flutter/material.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:get/get.dart';

class SearchField extends StatefulWidget{
  const SearchField({Key? key}) : super(key: key);

  @override
  _SearchField createState() => _SearchField();
}
class _SearchField extends State<SearchField>{
  @override
  Widget build(BuildContext context){
    return  IconButton(
        iconSize: app_bar_icon_size,
        icon:  Icon(Icons.search,color: ConstantUtils.isDarkMode ? ConstantUtils.darkMode.imageBackgroundColor: Colors.white,), onPressed: () {
    Get.off(() => SearchPage());
    });
  }
}