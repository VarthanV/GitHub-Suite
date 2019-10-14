import 'dart:async';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http_server/http_server.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//https://digitalilusion.com/news/embedded-web-server-in-flutter/
//https://www.youtube.com/watch?v=-QvEZoPy96g
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
Future _startWebServer() async {
   final StreamController<String> onCode = new StreamController();
  HttpServer server =
  await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080);
  server.listen((HttpRequest request) async {
    final String code = request.uri.queryParameters["code"];
    print(code);
    request.response
      ..statusCode = 200
      ..headers.set("Content-Type", ContentType.HTML.mimeType)
      ..write("<html><h1>You can now close this window</h1></html>");
    await request.response.close();
    await server.close(force: true);
    onCode.add(code);
    await onCode.close();
  });
  return onCode.stream;
  }
  @override
  void initState(){
    super.initState();
    _startWebServer();
    http.get('http://0.0.0.0:8080/?code=enfekg').then((resp){
      print(resp.body);
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Text('Testing'),
        
      );
    
  }
}