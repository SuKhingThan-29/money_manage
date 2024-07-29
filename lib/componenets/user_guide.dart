
import 'package:AthaPyar/helper/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
class UserGuideState extends ModalRoute<void> {
  String img;
  String skipName;
  Function(bool) onCountChange;
  Function(String) onSkipChange;
  UserGuideState({required this.img,required this.skipName,required this.onCountChange,required this.onSkipChange});
  @override
  Duration get transitionDuration => Duration(milliseconds: 200);

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
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child:  SafeArea(
        child:  _buildOverlayContent(context)
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.all(18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: ()async{
                    Navigator.of(context).pop();
                    onSkipChange(skipName);
                    print('Skip click: $skipName');
                  },
                  child: Container(
                    width: 100,
                    child: Text('Skip',style: TextStyle(color: Colors.white,fontSize: 14),
                  ),
                  )
                ),
                GestureDetector(
                  onTap: ()async{
                    SharedPreferences pref=await SharedPreferences.getInstance();
                    setState(() {
                      pref.setBool(isUserGuideWork,false);
                      onCountChange(false);
                      Navigator.of(context).pop();

                    });

                  },
                  child: Container(
                    width: 50,
                    child: Text('Close',style: TextStyle(color: Colors.white,fontSize: 14)),
                  ),
                )

              ],
            ),
          ),
      Spacer(),
      IconButton(onPressed: ()async{
        SharedPreferences pref=await SharedPreferences.getInstance();
        bool isUserGuideWork=true;
        if(pref.getBool('isUserGuideWork') !=null){
          isUserGuideWork=pref.getBool('isUserGuideWork')!;
        }
        debugPrint('isUserGuide in: $isUserGuideWork');

        setState(() {
              Navigator.of(context).pop();
              if(isUserGuideWork){
                onCountChange(true);

              }else{
                onCountChange(false);

              }

            });

          }, icon: SvgPicture.asset(img),iconSize: 550,),
          SizedBox(height: 30,)
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
// class OverlayDialogPage extends ModalRoute<void> {
//   @override
//   Duration get transitionDuration => Duration(milliseconds: 100);
//
//   @override
//   bool get opaque => false;
//
//   @override
//   bool get barrierDismissible => false;
//
//   @override
//   Color get barrierColor => Colors.black.withOpacity(0.5);
//
//   @override
//   String? get barrierLabel => null;
//
//   @override
//   bool get maintainState => true;
//
//   @override
//   Widget buildPage(
//       BuildContext context,
//       Animation<double> animation,
//       Animation<double> secondaryAnimation,
//       ) {
//     return Material(
//       type: MaterialType.transparency,
//       child: SafeArea(
//         child: _buildOverlayContent(context),
//       ),
//     );
//   }
//
//   Widget _buildOverlayContent(BuildContext context) {
//     return Center(
//       child: dialogContent(context),
//     );
//   }
//
//   @override
//   Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
//     return FadeTransition(
//       opacity: animation,
//       child: ScaleTransition(
//         scale: animation,
//         child: child,
//       ),
//     );
//   }
//
//   // ダイアログ
//   Widget dialogContent(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.all(32.0),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
//             decoration: new BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 10.0,
//                   offset: const Offset(0.0, 10.0),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Text(
//                   "Text Widget",
//                   style: TextStyle(
//                     fontSize: 18.0,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.blue[800],
//                   ),
//                 ),
//                 SizedBox(height: 8.0),
//                 Text(
//                   "Text Widget",
//                   style: TextStyle(
//                     fontSize: 24.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 16.0),
//                 Container(
//                   height: 130.0,
//                   child: Placeholder(),
//                 ),
//                 SizedBox(height: 16.0),
//                 Container(
//                   height: 130.0,
//                   child: Placeholder(),
//                 ),
//                 SizedBox(height: 16.0),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     height: 50.0,
//                     width: double.infinity,
//                     child: RaisedButton(
//                       onPressed: () {
//                         Navigator.of(context).pop(); // To close the dialog
//                       },
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                       ),
//                       color: Colors.blue[800],
//                       child: Text(
//                         "次へ",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18.0,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Positioned(
//           bottom: 0,
//           right: -30,
//           child: IgnorePointer(
//             child: FlutterLogo(
//               size: 150,
//               textColor: Colors.orange,
//             ),
//           ),
//         ),
//         Positioned(
//           top: 0,
//           bottom: 0,
//           left: -30,
//           child: IgnorePointer(
//             child: FlutterLogo(
//               size: 150,
//             ),
//           ),
//         ),
//         Positioned(
//           top: -10,
//           right: 0,
//           left: 0,
//           child: IgnorePointer(
//             child: FlutterLogo(
//               size: 150,
//               textColor: Colors.orange,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
