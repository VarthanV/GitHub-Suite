import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:githubapp/pages/homepage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'data.dart';

//https://digitalilusion.com/news/embedded-web-server-in-flutter/
//https://www.youtube.com/watch?v=-QvEZoPy96g
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String data;
  Future _webServer() async {
    final StreamController<String> onCode = new StreamController();
    HttpServer server =
        await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080);
    server.listen((HttpRequest request) async {
      String code = request.uri.queryParameters["code"].toString();
      setState(() {
        data = code.toString();
      });
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
  void initState() {
    super.initState();
  }

  loginFlow() async {
    Stream<String> onCode = await _webServer();
    String url = 'https://github.com/login/oauth/authorize?client_id=$clientId';
    launch(url);
    final String code = await onCode.first;
    print(code);
    http
        .post(
            'https://github.com/login/oauth/access_token?client_id=$clientId&client_secret=$clientSecret&code=$code&format=json')
        .then((res) {
      if (res.statusCode == 200) {
        setState(() {
          SharedPreferences.getInstance().then((prefs) {
            prefs.setString('token', jsonDecode(res.body)['access_token']);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (ctx) => HomePage(prefs.getString('token'))));
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.brown,
      alignment: Alignment.center,
      child: RaisedButton(
        color: Colors.white,
        child: Text('SignIn with Github'),
        onPressed: loginFlow,
      ),
    ));
  }
}
