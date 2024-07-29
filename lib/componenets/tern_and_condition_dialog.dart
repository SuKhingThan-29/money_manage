import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAlertDialog extends StatefulWidget {
  const CustomAlertDialog({
    Key? key,

  }) : super(key: key);


  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  var term_eng;
  var term_mm;
  var lang='English';
  @override
  void initState(){
    super.initState();
    init();
  }
  void init()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    setState(() {
      term_eng= pref.getString(termsAndCondition_eng).toString();
      term_mm= pref.getString(termsAndCondition_mm).toString();
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
      child:Column(
        children: [
          Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                              color: ConstantUtils.isDarkMode?dark_border_color:themeColor,
                              width: 1.0,
                            )
                        )
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          child: SvgPicture.asset(
                              'assets/settings/term_condition.svg'),
                        ),
                        SizedBox(width: 5,),
                        Text(
                          'Terms & Condition'.tr,
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  Expanded(child:   SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.all(10),
                    child: Text(
                       lang=='English'?(term_eng!=null && term_eng!=''?term_eng:''):(term_mm!=null && term_mm!=''?term_mm:''),
                      style: TextStyle(
                          fontSize: 12.0,
                          color: ConstantUtils.isDarkMode?dark_font_grey_color:Colors.black
                      ),
                    ),
                  ),),
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
                          "Agree".tr,
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
      )
    );
  }
}