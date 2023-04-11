import 'package:flutter/material.dart';

import 'package:my_digital_library/constants/constants.dart';
import 'package:my_digital_library/constants/comicDatas.dart';


import '../pages/details/bookDetails.dart';

class bookStaggeredGridView extends StatelessWidget {
  final int selected;
  final PageController pageController;
  final Function callBack;
  bookStaggeredGridView(
      {required this.selected,
      required this.pageController,
      required this.callBack,
      Key? key})
      : super(key: key);

  final myData = comicDatas().comicDataList[0];

  //final myData = comicDatas().comicDataList[0];
  //final myClassData = site(jsonData: myData);

  @override
  Widget build(BuildContext context) {

    return bookItem(pageController: pageController, callBack: callBack, myData: myData);
  }
}

class bookItem extends StatelessWidget {
  const bookItem({
    super.key,
    required this.pageController,
    required this.callBack,
    required this.myData,
  });

  final PageController pageController;
  final Function callBack;
  final Map<String, dynamic> myData;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: PageView(
          controller: pageController,
          onPageChanged: (index) => callBack(index),
          children: [
            gridViewBuilder(myData: myData),
            Container(), // Favorites Sayfası
          ],
        ));
  }
}

class gridViewBuilder extends StatelessWidget {
  const gridViewBuilder({
    super.key,
    required this.myData,
  });

  final Map<String, dynamic> myData;


  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.7),
      itemCount: myData['properties'].length,
      padding: EdgeInsets.all(tabBarAndGridViewMarginPaddin.tabBarMargin/2),
      itemBuilder: (_, index) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: GridTile(
            child: Ink.image(
              image: NetworkImage(
                  '${myData['base_url']}${myData['properties'][index]['book_url']}'),
              fit: BoxFit.cover,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
                  bookDetailPage(comicData: myData['properties'][index])

                  ));

                },

              ),
            ),
            header: Row(
              children: [
                Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      '${myData['properties'][index]['issues'].length}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: mainScreenProperties.fontColor,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child:
                        SizedBox()), // Yanına bir şey eklemak istiyorsan
              ],
            ),
            footer: Card(
              color: mainScreenProperties.cardColor,
              elevation: 0.1,
              margin: EdgeInsets.all(10),
              child: Text(
                myData['properties'][index]['book_name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: mainScreenProperties.subtitleFontSize15,
                  color: mainScreenProperties.fontColorWhite,
                  //backgroundColor: Colors.grey,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


