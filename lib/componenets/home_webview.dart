import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeWebView extends StatefulWidget{
  const HomeWebView({Key? key}):super(key: key);
  _HomeWebView createState() => _HomeWebView();
}
class _HomeWebView extends State<HomeWebView>{
  String filePath = 'file:///android_asset/flutter_assets/assets/files/file_360_50.html';
  late WebViewController _webViewController;
  _loadHtmlFromAssets() async {
    String fileHtmlContents = await rootBundle.loadString(filePath);
    _webViewController.loadUrl(Uri.dataFromString(fileHtmlContents,
        mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
          Container(
              height: 50,
              child:
              WebView(
                initialUrl: filePath,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _webViewController = webViewController;
                 // _loadHtmlFromAssets();
                },
              ),
          ),
      ],
    );
  }
}