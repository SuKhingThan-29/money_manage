import 'package:AthaPyar/controller/transaction_controller.dart';
import 'package:AthaPyar/helper/style.dart';
import 'package:AthaPyar/helper/utils.dart';
import 'package:cell_calendar/cell_calendar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalendarWidget extends StatefulWidget {
  CalendarWidget({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _CalendarWidget createState() => _CalendarWidget();
}
class _CalendarWidget extends State<CalendarWidget> {
  List<CalendarEvent> eventList=[];
  final cellCalendarPageController = CellCalendarPageController();
  @override
  void initState(){
    cellCalendarPageController.setDate(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return GetBuilder<TransactionController>(
        init: TransactionController(),
        builder: (value){
          if(value.dailyList.length>0){
            eventList.clear();
            for(var i in value.dailyList){
              var event=CalendarEvent(eventDate: DateTime.parse(i.date), income: i.incomeAmount, expense: i.expenseAmount, total: i.totalAmount, eventName: '');
              eventList.add(event);
            }
          }
          cellCalendarPageController.setDate(value.selectedDate);
          print('DailyList Calendars: ${value.selectedDate}');
          return Column(
            children: [
              Expanded(child: CellCalendar(
                todayMarkColor:ConstantUtils.isDarkMode?dark_box_background_color:Colors.red,
                todayTextColor: ConstantUtils.isDarkMode?Colors.black:Colors.white,
                dateTextStyle: TextStyle(color: ConstantUtils.isDarkMode?dark_font_grey_color:Colors.black),
                cellCalendarPageController: cellCalendarPageController,
                events: eventList,
                daysOfTheWeekBuilder: (dayIndex) {
                  final labels = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child:Container(
                      padding: EdgeInsets.all(5),
                      child:  Text(
                        labels[dayIndex],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,color: (labels[dayIndex].toString()=='Sun' || labels[dayIndex].toString()=='Sat')?Colors.red:(ConstantUtils.isDarkMode?Colors.white:Colors.black),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
                monthYearLabelBuilder: (datetime) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                      ],
                    ),
                  );
                },
                onCellTapped: (date) {
                  // final eventsOnTheDate = eventList.where((event) {
                  //   final eventDate = event.eventDate;
                  //   return eventDate.year == date.year &&
                  //       eventDate.month == date.month &&
                  //       eventDate.day == date.day;
                  // }).toList();
                  // showDialog(
                  //     context: context,
                  //     builder: (_) => AlertDialog(
                  //       title:
                  //       Text(date.month.monthName + " " + date.day.toString()),
                  //       content: Column(
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: eventsOnTheDate
                  //             .map(
                  //               (event) => Container(
                  //               width: double.infinity,
                  //               padding: EdgeInsets.all(4),
                  //               margin: EdgeInsets.only(bottom: 12),
                  //               color: event.eventBackgroundColor,
                  //               child: Column(
                  //                 children: [
                  //                   Text(
                  //                     event.income,
                  //                     style: TextStyle(color: event.eventTextColor),
                  //                   ),
                  //                   Text(
                  //                     event.expense,
                  //                     style: TextStyle(color: event.eventTextColor),
                  //                   ),
                  //                   Text(
                  //                     event.total,
                  //                     style: TextStyle(color: event.eventTextColor),
                  //                   ),
                  //                 ],
                  //               )
                  //           ),
                  //         )
                  //             .toList(),
                  //       ),
                  //     ));
                },
                onPageChanged: (firstDate, lastDate) {
                  print('PageChangedForCalendar: $firstDate : $lastDate');
                  /// Called when the page was changed
                  /// Fetch additional events by using the range between [firstDate] and [lastDate] if you want
                },
              ))
            ],
          );
        });
  }
}