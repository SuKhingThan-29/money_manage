// import 'package:flutter/material.dart';
//
// class SafeTextField extends StatelessWidget {
//   final TextField textField;
//   final FocusNode? focusNode;
//
//   const SafeTextField({required this.textField, required this.focusNode})
//       : super();
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<bool>(
//       future: _isHuawei(),
//       builder: (ctx, snapshot) {
//         if (snapshot.hasData) {
//           if (snapshot.data!) {
//             return _SafeTextField(textField: textField, focusNode: focusNode);
//           }
//         }
//         return textField;
//       },
//     );
//   }
//
//   Future<bool> _isHuawei() async {
//     final info = await SystemInfo().deviceInfo();
//     return info.brand.toLowerCase() == 'huawei';
//   }
// }
//
// class _SafeTextField extends StatefulWidget {
//   final TextField textField;
//   final FocusNode? focusNode;
//
//   const _SafeTextField({required this.textField, required this.focusNode})
//       : super();
//
//   @override
//   _SafeTextFieldState createState() => _SafeTextFieldState();
// }
//
// /// 华为手机上，偶有键盘首次无法唤起及键盘类型不对的情况
// class _SafeTextFieldState extends State<_SafeTextField> {
//   bool hasFocus = false;
//   @override
//   void initState() {
//     widget.focusNode?.addListener(() {
//       if (widget.focusNode!.hasFocus && !hasFocus) {
//         hasFocus = false;
//         if (WidgetsBinding.instance != null) {
//           FocusScope.of(context).unfocus();
//           WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
//             hasFocus = true;
//             FocusScope.of(context).requestFocus(widget.focusNode!);
//           });
//         }
//       } else {
//         hasFocus = false;
//       }
//     });
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     widget.focusNode?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.textField;
//   }
// }
