import 'package:flutter/material.dart';

class NotificationBadget extends StatelessWidget{
  final int totalNotification;
  const NotificationBadget({Key? key,required this.totalNotification}):super(key: key);
  @override
  Widget build(BuildContext context){

    return Container(
      width: 40,
      height:  40,
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Text("$totalNotification",style:TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}