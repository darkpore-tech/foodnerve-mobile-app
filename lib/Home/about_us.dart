import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutUs extends StatelessWidget {
  const AboutUs(
      {Key? key,
      // required JavascriptMode javascriptMode,
      required String initialUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const WebView(
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl: 'https://www.food2050series.com/episodes/foodnerve',
    );
  }
}
