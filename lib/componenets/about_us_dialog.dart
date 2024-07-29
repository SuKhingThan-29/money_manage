import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CustomAboutUsAlertDialog extends StatefulWidget {
  const CustomAboutUsAlertDialog({
    Key? key,
  }) : super(key: key);


  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAboutUsAlertDialog> {
  var term_eng;
  var term_mm;
  var lang='';
  @override
  void initState(){
    super.initState();
    init();
  }
  void init()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    setState(() {
      term_eng= pref.getString(about_us_eng).toString();
      term_mm= pref.getString(about_us_mm).toString();
      lang = pref.getString(Lang).toString();
    });

  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: ConstantUtils.isDarkMode?dark_background_color:Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          Expanded(child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1.0,
                            color: ConstantUtils.isDarkMode?dark_border_color:themeColor
                        )
                    )
                ),
                padding: EdgeInsets.all(10),
                child:  Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      //  margin: EdgeInsets.only(left: 10,top: 15),
                      child: SvgPicture.asset(
                          'assets/settings/about_us.svg'),
                    ),
                    SizedBox(width: 5,),
                    Text(
                      'About Us'.tr,
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
              Expanded(
                child:    SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    lang=='English'?term_eng:term_mm,
                    style: TextStyle(
                        fontSize: 12.0,
                        color: ConstantUtils.isDarkMode?dark_font_grey_color:Colors.black
                    ),
                  ),
                ),
              ),

              Divider(
                height: 1,
              ),
              Container(
                // color: themeColor,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border:Border.all(color:  ConstantUtils.isDarkMode?dark_border_color:themeColor),
                    color: ConstantUtils.isDarkMode?dark_background_color:themeColor,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15))
                ),

                height: 50,
                child: InkWell(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0),
                  ),
                  highlightColor: Colors.grey[200],
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Center(
                    child: Text(
                      "OK".tr,
                      style: TextStyle(
                        color: ConstantUtils.isDarkMode?themeColor:Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ))
        ],
      ),



    );
  }
}