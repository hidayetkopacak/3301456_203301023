import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:my_digital_library/constants/constants.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '../constants/responsive.dart';
import '../pages/auth/auth.dart';
import '../pages/details/bookDetails.dart';

import '../pages/sources/funcs.dart';

class FavoritesWidget extends StatefulWidget {
  @override
  _FavoritesWidgetState createState() => _FavoritesWidgetState();
}

class _FavoritesWidgetState extends State<FavoritesWidget> {
  late Box<dynamic> myBox;
  late ValueListenable<Box<dynamic>> myBoxListenable;

  @override
  void initState() {
    super.initState();
    myBox = Hive.box('favorites_v01');
    myBoxListenable = myBox.listenable();
  }

  @override
  Widget build(BuildContext context) {
    var currentWidth=  MediaQuery.of(context).size.width;
    return FutureBuilder<Container>(
      future: fetchFavorites(context),
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
                    'No favorites available.',
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

  Future<Container> fetchFavorites(context) async {
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



    DatabaseReference ref = rtdb.ref(userID).child('favorites');


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
