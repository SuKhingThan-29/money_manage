import 'package:flutter/material.dart';
import 'package:AthaPyar/helper/size_config.dart';
import 'package:AthaPyar/helper/utils.dart';

class BookMarks extends StatefulWidget{
  const BookMarks({Key? key}) : super(key: key);

  @override
  _BookMarks createState() => _BookMarks();
}
class _BookMarks extends State<BookMarks>{
  @override
  Widget build(BuildContext context){
    return Padding(padding: EdgeInsets.only(right: getProportionateScreenWidth(0)),
        child: IconButton(
          icon:  Icon(Icons.star_border_outlined,color: ConstantUtils.isDarkMode ? ConstantUtils.darkMode.imageBackgroundColor: ConstantUtils.lightMode.imageBackgroundColor,), onPressed: () {  },
        ));
  }
}