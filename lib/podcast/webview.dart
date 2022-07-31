import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViews extends StatelessWidget {
  const WebViews(
      {Key? key,
      // required JavascriptMode javascriptMode,
      required String initialUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl:
            'https://www.youtube.com/channel/UCURsvyOjsGMFkH2T8NQQwXA/',
      ),
    );
  }
}

//'https://www.food2050series.com/episodes/foodnerve',