import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '_count.dart';

class CounterPage extends StatefulWidget {

  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int count = 0;
  int result=1;

  String _message = '';

  void setMessage(String message) {
    setState(() {
      _message = message;
    });
  }
  Future<void> _sendAnalyticsEvent() async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'Counter_Event',

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
    setMessage('logEvent succeeded');

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

 //  Future<void> _testSetCurrentScreen() async {
 //    await widget.analytics.setCurrentScreen(
 //      screenName: 'CounterPage Event',
 //      screenClassOverride: 'Home View',
 //    );
 //    setMessage('Screen View is success');
 // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Widget Communication")),
      body: Center(
        child: Column(
          children: [
            MaterialButton(
              onPressed: _sendAnalyticsEvent,
              child: const Text('Test sendAnalyticsEvent'),
            ),
            Text(
              _message,
              style: const TextStyle(color: Color.fromARGB(255, 0, 155, 0)),
            ),

            // Count(count: count,
            //   onCountChanged: (int val){
            //   setState(() => count +=val);
            //   },
            //   onCountSelected: (){
            //     debugPrint('Count was selected: $result');
            //   },),
            //Text('OnPress from child: $result'),
          ],
        ),
      ),
    );
  }
}
