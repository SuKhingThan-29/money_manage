
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TutorialOverlay extends ModalRoute<void> {
 // bool isLogin;
  String data;
  String duration;
  String dataURL;

  TutorialOverlay({required this.data,required this.dataURL,required this.duration});
  @override
  Duration get transitionDuration => Duration(milliseconds: 0);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) {
    // This makes sure that text and other content follows the material style
    return Material(
      color: Colors.black,
      //type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  Widget _buildOverlayContent(BuildContext context) {
    var _width=MediaQuery.of(context).size.width;
    int _duration=int.parse(duration);
    print('Duration for : $_duration');
    print('Duration for width: $_width');
    Future.delayed(Duration(seconds: _duration),(){
      if(_duration!=0){
        Navigator.of(context).pop();
      }
    });
    return Center(
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:CrossAxisAlignment.start,
        children: <Widget>[
          IconButton(onPressed: (){
            Navigator.of(context).pop();
          }, icon: SvgPicture.asset('assets/icon/cancel_bg.svg')),
          Spacer(),
          Container(
              height: 480,
              child: WebView(
                initialUrl: data,
                javascriptMode: JavascriptMode.unrestricted,
                javascriptChannels: <JavascriptChannel>[
                  JavascriptChannel(
                      name: 'MessageInvoker',
                      onMessageReceived: (s) {
                        if (s.message!=null && s.message.isNotEmpty) {
                           _launchURL(dataURL);
                        }
                      }),
                ].toSet(),
                gestureNavigationEnabled: true,
              )
          ),
          Spacer()



        ],
      ),
    );
  }

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}