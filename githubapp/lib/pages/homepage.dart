import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'issueDetail.dart';

class HomePage extends StatefulWidget {
  final token;
  HomePage(this.token);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List repos;
  @override
  void initState() {
    super.initState();
    _fetchRepos();
  }

  Widget homeCard() {
    return repos.length != 0
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: repos.map((item) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: ListTile(
                        title: Text(item['name']),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => IssueDetailPage(
                                      repos[0]['owner']['login'],
                                      item['name'])));
                        },
                        subtitle: Text(item['description'] != null
                            ? item['description']
                            : 'No Description Provided'),
                      ))
                ],
              );
            }).toList())
        : Container(
            alignment: Alignment.center,
            child: Text("No Repos Found"),
          );
  }

  _fetchRepos() {
    String token = widget.token.toString();
    Map<String, String> header = {'Authorization': 'token $token'};
    print(token);
    http
        .get('https://api.github.com/user/repos?private=true', headers: header)
        .then((response) {
      setState(() {
        repos = jsonDecode(response.body);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[400],
          title: Text('Github App'),
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 30.0),
              child: Column(
                children: <Widget>[
                  Card(
                      child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                              child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      repos.length != 0
                                          ? repos[0]['owner']['avatar_url']
                                          : ''))),
                          Container(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(repos[0]['owner']['login'].toString()),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text("Repositories :" + repos.length.toString()),
                      )
                    ],
                  )),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            homeCard(),
          ],
        ));
  }
}
