import 'package:flutter/material.dart';
import 'package:my_digital_library/widgets/singleIssue.dart';



class bookDetailIssueList{

  final List<Map<String,dynamic>> issueNameLinkList;

  bookDetailIssueList({required this.issueNameLinkList});

  Widget buildIssueList(){
    return ListView.builder(
        itemCount: issueNameLinkList.length,
        itemBuilder: (context, index) => Card(

          color: Colors.white,
          elevation: 4,
          child: ListTile(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
              singleIssueSlider(
                issueName:issueNameLinkList[(issueNameLinkList.length -1) - index]['issue_name'] ,

                issuePages:issueNameLinkList[(issueNameLinkList.length -1) - index]['issue_pages'],


              )

              ));

            },

            leading: Text('${(index as int)+1}'),
            title: Text('${issueNameLinkList[(issueNameLinkList.length -1) - index]['issue_name']}'),

          ),



        ));


  }
}

