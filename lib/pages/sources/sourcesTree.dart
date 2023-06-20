import 'package:flutter/material.dart';
import 'package:my_digital_library/constants/constants.dart';

import 'package:my_digital_library/constants/comicDatas.dart';
import 'sourcesHome.dart';
import '../../widgets/bottomNavBar.dart';


class sourcesTree extends StatefulWidget {
  const sourcesTree({Key? key}) : super(key: key);

  @override
  State<sourcesTree> createState() => _sourcesTreeState();
}

class _sourcesTreeState extends State<sourcesTree> {
  @override
  Widget build(BuildContext context) {
    var bottomIndex = 1;
    return Scaffold(
      appBar: appBarProperties().buildSideAppBar('Sources'),
      bottomNavigationBar: bottomNavBar(bottomIndex: bottomIndex),
      body: buildContainer(),
    );
  }

  Container buildContainer() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SourcesHome()), // Navigate to the SourcesHome widget
                );
              },
              child: ListTile(
                leading: Image.network('${comicDatas().comicDataList[0]['site_icon']}'),
                title: Text('${comicDatas().comicDataList[0]['base_url']}'),
                subtitle: Text('English'),
                tileColor: mainScreenProperties.backgroundColorSecond,
              ),
            ),
          ),
        ],
      ),
    );
  }
}






