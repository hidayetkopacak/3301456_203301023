import 'package:flutter/material.dart';
import 'package:my_digital_library/widgets/singleIssue.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;







class bookDetailIssueListScrap {
  final List<dynamic> issueNameLinkList;

  bookDetailIssueListScrap({required this.issueNameLinkList});

  Future<Map<String, dynamic>> getPages(String issueLink, String issueName) async {
    var pageList = <String>[];

    var myPagesRequest = await http.get(Uri.parse(issueLink));
    var myPagesRequestDatas = parser.parse(myPagesRequest.body);
    var myPagesList = myPagesRequestDatas.querySelector("div.full-container");
    var myPages = myPagesList?.querySelectorAll('img') ?? [];

    for (var myPage in myPages) {
      var pageUrl = myPage.attributes['src'];

      if (pageUrl != null) {
        pageList.add(pageUrl);
      }
    }

    var issueDatas = {
      'issue_name': issueName,
      'issue_link': issueLink,
      'issue_pages': pageList,
    };

    return issueDatas;
  }

  Widget buildIssueList() {
    return ListView.builder(
      itemCount: issueNameLinkList.length,
      itemBuilder: (context, index) => Card(
        color: Colors.white,
        elevation: 4,
        child: ListTile(
          onTap: () {
            getPages(
              issueNameLinkList[index]['issue_link'],
              issueNameLinkList[index]['issue_name'],
            ).then((pages) {



              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return singleIssueSlider(
                  issueName: issueNameLinkList[(issueNameLinkList.length - 1) - index]['issue_name'],
                  issuePages: pages['issue_pages'],
                );
              }));
            });
          },
          leading: Text('${(index as int) + 1}'),
          title: Text('${issueNameLinkList[(issueNameLinkList.length - 1) - index]['issue_name']}'),
        ),
      ),
    );
  }
}







