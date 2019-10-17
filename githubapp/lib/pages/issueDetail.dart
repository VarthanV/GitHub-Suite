import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class IssueDetailPage extends StatefulWidget {
  var userName;
  var repoName;
  IssueDetailPage(this.userName, this.repoName);
  @override
  _IssueDetailPageState createState() => _IssueDetailPageState();
}

class _IssueDetailPageState extends State<IssueDetailPage> {
  // https://api.github.com/repos/VarthanV/A-/pulls/ -Pull Request Format
   
  //https://api.github.com/repos/torvalds/linux/pulls- Mock API to build the data
  
  List pullRequests;
  @override
  void initState() {
    super.initState();
    _fetchPullRequests();
  }

  _fetchPullRequests() {
    print(widget.userName);
    print(widget.repoName);
    var url =
        'https://api.github.com/repos/${widget.userName}/${widget.repoName}/pulls'
            .toString()
            .trim();

    http.get(url).then((response) {
      print(response.body);
    });
  }

  Widget _pullRequestCard() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: pullRequests.map((item) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[],
          );
        }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.repoName != null ? widget.repoName : ''),
        backgroundColor: Colors.purple[400],
      ),
      body: Text('Testing'),
    );
  }
}
