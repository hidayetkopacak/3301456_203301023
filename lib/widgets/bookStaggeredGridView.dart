import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:my_digital_library/constants/constants.dart';
import 'package:my_digital_library/constants/comicDatas.dart';


import '../constants/responsive.dart';
import '../pages/auth/auth.dart';
import '../pages/details/bookDetails.dart';
import '../pages/sources/funcs.dart';
import 'bookStaggeredGridViewFavorites.dart';


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
            LibraryWidget(),//buildLibrary(context),//gridViewBuilder(myData: myData),
            FavoritesWidget()//buildFavorites(context), // Favorites Sayfası
          ],
        ));
  }




}








class LibraryWidget extends StatefulWidget {
  @override
  _LibraryWidgetState createState() => _LibraryWidgetState();
}

class _LibraryWidgetState extends State<LibraryWidget> {
  late Box<dynamic> myBox;
  late ValueListenable<Box<dynamic>> myBoxListenable;



  @override
  void initState() {
    super.initState();
    myBox = Hive.box('library_v01');
    myBoxListenable = myBox.listenable();
  }

  @override
  Widget build(BuildContext context) {

    var currentWidth=  MediaQuery.of(context).size.width;
    return FutureBuilder<Container>(
      future: fetchLibrary(context),
      builder: (BuildContext context, AsyncSnapshot<Container> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return ValueListenableBuilder(
            valueListenable: myBoxListenable,
            builder: (BuildContext context, Box<dynamic> box, Widget? child) {
              final myBoxList = box.keys.toList();

              return myBoxList.isNotEmpty
                  ? Container(
                    child: Padding(
                      padding: reponsiveFunc(MediaQuery.of(context).size.width) == 4 ? EdgeInsets.fromLTRB(200, 0, 200, 0 ): EdgeInsets.all(0),
                      child: Container(
                child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: reponsiveFunc(currentWidth),
                        childAspectRatio: 0.7,
                      ),
                      itemCount: myBoxList.length,
                      padding: EdgeInsets.all(tabBarAndGridViewMarginPaddin.tabBarMargin / 2),
                      itemBuilder: (_, index) {
                        var bookName = box.get(myBoxList[index])[0]['book_name'];
                        var bookImage = box.get(myBoxList[index])[1]['book_image'];
                        var bookLink = box.get(myBoxList[index])[2]['book_url'];

                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GridTile(
                            child: Ink.image(
                              image: NetworkImage('${bookImage}'),
                              fit: BoxFit.cover,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => bookDetailPageScrap(
                                        comicData: getSingleComicDatas(bookLink, bookName, bookImage),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            footer: Card(
                              color: mainScreenProperties.cardColor,
                              elevation: 0.1,
                              margin: EdgeInsets.all(10),
                              child: Text(
                                bookName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: mainScreenProperties.subtitleFontSize15,
                                  color: mainScreenProperties.fontColorWhite,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                ),
              ),
                    ),
                  )
                  : Container(
                child: Center(
                  child: Text(
                    'No data available. Add some books from sources.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<Container> fetchLibrary(context) async {
    final firebaseApp = Firebase.app();
    final rtdb = FirebaseDatabase.instanceFor(
      app: firebaseApp,
      databaseURL: 'https://digilibv01-default-rtdb.europe-west1.firebasedatabase.app/',
    );
    final User? user = Auth().currentUser;
    String _userId(){
      return user?.email ?? 'User email';
    }
    String userID = _userId().split('@')[0];
    userID = userID
        .replaceAll(".", "")
        .replaceAll("\$", "")
        .replaceAll("[", "")
        .replaceAll("]", "")
        .replaceAll("#", "");



    DatabaseReference ref = rtdb.ref(userID).child('library');
    final snapshot = await ref.get();



    if (snapshot.exists) {
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {

        myBox.put(key as dynamic, value as dynamic);
      });
    } else {
      //print('No data available.');
    }


    return Container();
  }
}



