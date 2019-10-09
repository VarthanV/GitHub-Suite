import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var clientId = '7c027a5f8afbac8043f4';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WebView(
      initialUrl:
          'https://github.com/login/oauth/authorize?client_id=' + clientId,
      javascriptMode: JavascriptMode.unrestricted,
    ));
  }
}
