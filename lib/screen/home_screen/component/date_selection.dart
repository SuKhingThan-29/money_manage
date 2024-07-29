import 'package:AthaPyar/controller/status_controller.dart';
import 'package:AthaPyar/controller/transaction_controller.dart';
import 'package:AthaPyar/controller/weekly_controller.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:cell_calendar/cell_calendar.dart';
import 'package:flutter/material.dart';
import 'package:AthaPyar/helper/size_config.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:get/get.dart';

class DateSelection extends StatefulWidget {
  const DateSelection({Key? key}) : super(key: key);

  _DateSelection createState() => _DateSelection();
}
class _DateSelection extends State<DateSelection> {
  TransactionController _transactionController=Get.put(TransactionController());
  StatusController _statusController=Get.put(StatusController());
  WeeklyController _weeklyController=Get.put(WeeklyController());
  final cellCalendarPageController = CellCalendarPageController();
  late String currentMonthYear;
  var _selectedDate = DateTime.now();

  @override
  void initState(){
    super.initState();
    _transactionController.onInit();
    _statusController.onInit();
    _weeklyController.onInit();
    init();
  }
  void init()async{
    var dateTimeSelection=DateTime(
        DateTime.now().year,DateTime.now().month, DateTime.now().day);
    currentMonthYear=ConstantUtils.monthFormatter.format(dateTimeSelection);
    _transactionController.sendMonthYear(currentMonthYear);
    _transactionController.setDate(dateTimeSelection);
    _transactionController.setYear(ConstantUtils.yearFormatter.format(_selectedDate));
    _statusController.sendMonthYear(currentMonthYear,IncomeType);
  }

  @override
  Widget build(BuildContext context){
    return GetBuilder<TransactionController>(
      init: TransactionController(),
      builder: (value){
        return Container(
          color: ConstantUtils.isDarkMode?ConstantUtils.darkMode.backgroundColor:light_tab_bar_color,
          child: _transactionController.isMonthly?Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              Padding(padding: EdgeInsets.only(right: getProportionateScreenWidth(1)),
                  child: IconButton(
                    icon:  Icon(Icons.arrow_back_ios_outlined,size: 22,color: ConstantUtils.isDarkMode ? ConstantUtils.darkMode.imageBackgroundColor: ConstantUtils.lightMode.imageBackgroundColor,), onPressed: () {
                    _selectedDate=DateTime(_selectedDate.year - 1,_selectedDate.month,_selectedDate.day);
                    value.setYear(ConstantUtils.yearFormatter.format(_selectedDate));
                    currentMonthYear=ConstantUtils.monthFormatter.format(_selectedDate);
                    value.sendMonthYear(currentMonthYear);
                    setState(() {

                    });

                  },
                  )),
              Text( '${ConstantUtils.yearFormatter.format(_selectedDate)}',style: TextStyle(color: ConstantUtils.isDarkMode ?Colors.white: Colors.black,fontSize: 20),),
              Padding(padding: EdgeInsets.only(right: getProportionateScreenWidth(1)),
                  child: IconButton(
                    icon:  Icon(Icons.arrow_forward_ios_outlined,size: 22,color: ConstantUtils.isDarkMode ? ConstantUtils.darkMode.imageBackgroundColor: ConstantUtils.lightMode.imageBackgroundColor,), onPressed: () {
                    _selectedDate=DateTime(_selectedDate.year + 1,_selectedDate.month,_selectedDate.day);

                    value.setYear(ConstantUtils.yearFormatter.format(_selectedDate));
                    currentMonthYear=ConstantUtils.monthFormatter.format(_selectedDate);
                    value.sendMonthYear(currentMonthYear);
                    setState(() {

                    });

                  },
                  ))
            ],

          ):Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              Padding(padding: EdgeInsets.only(right: getProportionateScreenWidth(1)),
                  child: IconButton(
                    icon:  Icon(Icons.arrow_back_ios_outlined,size: 22,color: ConstantUtils.isDarkMode ? ConstantUtils.darkMode.imageBackgroundColor: ConstantUtils.lightMode.imageBackgroundColor,), onPressed: () {
                    _selectedDate = DateTime(_selectedDate.year,_selectedDate.month - 1,_selectedDate.day);
                    value.setDate(_selectedDate);
                    currentMonthYear=ConstantUtils.monthFormatter.format(_selectedDate);
                    value.sendMonthYear(currentMonthYear);
                    _statusController.isIncomeClick=true;
                    _statusController.isExpenseClick=false;
                    _statusController.sendMonthYear(currentMonthYear,IncomeType);
                    _weeklyController.getInit(_selectedDate);
                    setState(() {

                    });

                  },
                  )),
              Text( ConstantUtils.monthFormatter.format(_selectedDate),style: TextStyle(color: ConstantUtils.isDarkMode ? Colors.white: Colors.black,fontSize: 20),),
              Padding(padding: EdgeInsets.only(right: getProportionateScreenWidth(1)),
                  child: IconButton(
                    icon:  Icon(Icons.arrow_forward_ios_outlined,size: 22,color: ConstantUtils.isDarkMode ? ConstantUtils.darkMode.imageBackgroundColor: ConstantUtils.lightMode.imageBackgroundColor,), onPressed: () {
                    _selectedDate = DateTime(_selectedDate.year,_selectedDate.month + 1,_selectedDate.day);
                       value.setDate(_selectedDate);
                    currentMonthYear=ConstantUtils.monthFormatter.format(_selectedDate);
                    value.sendMonthYear(currentMonthYear);
                    _statusController.isIncomeClick=true;
                    _statusController.isExpenseClick=false;
                    _statusController.sendMonthYear(currentMonthYear,IncomeType);
                      _weeklyController.getInit(_selectedDate);
                    setState(() {

                    });

                  },
                  ))
            ],

          ),
        );
      },
    );
  }
}