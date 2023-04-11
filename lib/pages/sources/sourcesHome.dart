import 'package:flutter/material.dart';
import 'package:my_digital_library/constants/constants.dart';

import 'package:my_digital_library/constants/comicDatas.dart';

import '../../widgets/bottomNavBar.dart';

class sourcesHome extends StatelessWidget {
  const sourcesHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bottomIndex = 1;
    return Scaffold(
      appBar: appBarProperties().buildSideAppBar('Sources'),
      bottomNavigationBar: bottomNavBar(bottomIndex: bottomIndex),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Card(
                child: ListTile(

                    leading: Image.network(
                        '${comicDatas().comicDataList[0]['site_icon']}'),
                    title: Text('${comicDatas().comicDataList[0]['base_url']}'),
                    subtitle: Text('English'),
                    tileColor: mainScreenProperties.backgroundColorSecond)),
            Card(child: ListTile(tileColor: mainScreenProperties.backgroundColorSecond)),
            Card(child: ListTile(tileColor: mainScreenProperties.backgroundColorSecond)),
          ],
        ),
      ),
    );
  }
}
