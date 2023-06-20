import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_digital_library/constants/constants.dart';
import 'package:my_digital_library/pages/details/widgets/bookDetailIssueList.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../constants/responsive.dart';
import '../../auth/auth.dart';


class bookDetailSingleScrap extends StatefulWidget {
  final Future<Map<dynamic, dynamic>> comicData;
  bookDetailSingleScrap({required this.comicData, Key? key}) : super(key: key);

  @override
  State<bookDetailSingleScrap> createState() => _bookDetailSingleScrapState();
}

class _bookDetailSingleScrapState extends State<bookDetailSingleScrap> {
  final User? user = Auth().currentUser;

  String _userId(){
    return user?.email ?? 'User email';
  }



  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return FutureBuilder<Map<dynamic, dynamic>>(
      future: widget.comicData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(

                color: mainScreenProperties.navBarColorSecond,
                backgroundColor:mainScreenProperties.backgroundColorSecond ,
                strokeWidth: 4.0,

              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var comicData = snapshot.data!;
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('${comicData['book_image']}'),
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(.5), BlendMode.darken),

                repeat: ImageRepeat.repeat,
              ),
            ),
            child: Center(
              child: Container(
                width: reponsiveFunc(currentWidth) == 4 ? MediaQuery.of(context).size.width / 2 * (1.3) : MediaQuery.of(context).size.width ,
                color: Colors.white,

                //padding: EdgeInsets.all(tabBarAndGridViewMarginPaddin.tabBarMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: _buildHead(comicData),
                    ),
                    Expanded(flex: 1, child: _buildExpandedActionIcons(comicData)),
                    Expanded(flex: 1, child: _buildDescriptions()),
                    Expanded(flex: 5,child: _buildIssues(comicData)),

                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  // Rest of your code...
  Container _buildHead(Map<dynamic, dynamic> comicData) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('${comicData['book_image']}'),
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(.3), BlendMode.darken),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child: Image.network('${comicData['book_image']}'),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: SizedBox(width: 0),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${comicData['book_name']}',
                        style: _buildHeaderTextStyle(),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${comicData['publisher']} - ${comicData['status']} - ${comicData['artist']}',
                        style: _buildSubtitleTextStyle(),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _buildIssues(Map<dynamic, dynamic> comicData) {
    return Container(
        padding: EdgeInsets.all(5),
        color: mainScreenProperties.backgroundColorSecond,
        width: double.infinity,
        child: bookDetailIssueListScrap(issueNameLinkList: comicData['issues']).buildIssueList
          ());
  }

  Container _buildDescriptions() {
    return Container(
      padding: EdgeInsets.all(10),
      color: mainScreenProperties.backgroundColor,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Text(
          '"Berserk" is a dark fantasy manga series that follows the story of Guts, a skilled warrior who is seeking revenge against his former best friend, Griffith. Along the way, Guts must navigate a world filled with demons, magic, and political intrigue as he struggles to control his own inner demons and uncover the truth about his past. The series explores themes of power, betrayal, morality, and the consequences of unchecked ambition."',
          style: TextStyle(),
        ),
      ),
    );
  }

  Container _buildExpandedActionIcons(Map<dynamic, dynamic> comicData) {


    final myBox = Hive.box('favorites_v01');
    final myBoxLib = Hive.box('library_v01');
    var saveComicName = errorControl(comicData['book_name']);
    bool isAdded = myBoxLib.keys.toList().contains(saveComicName);
    bool isFavorite = myBox.keys.toList().contains(saveComicName);


    return Container(
      color: mainScreenProperties.backgroundColorSecond,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: IconButton(
              onPressed: () async {
                setState(() {
                  isAdded = !isAdded;

                });
                if (isAdded) {



                  final comic = [{'book_name' : comicData['book_name'] },{'book_image':comicData['book_image']},{'book_url': comicData['book_url']}];

                  myBoxLib.put( saveComicName,comic); // Veriyi kutuya ekleyin

                  final firebaseApp = Firebase.app();
                  final rtdb = FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: 'https://digilibv01-default-rtdb.europe-west1.firebasedatabase.app/');
                  String userID = _userId().split('@')[0];
                  userID = userID
                      .replaceAll(".", "")
                      .replaceAll("\$", "")
                      .replaceAll("[", "")
                      .replaceAll("]", "")
                      .replaceAll("#", "");


                  DatabaseReference ref = rtdb.ref(userID).child('library').child(saveComicName);

                  await ref.set([
                    {"book_name": comicData['book_name']},
                    {"book_image": comicData['book_image']},
                    {"book_url": comicData['book_url']},

                  ]);
                }else {
                  String userID = _userId().split('@')[0];
                  userID = userID
                      .replaceAll(".", "")
                      .replaceAll("\$", "")
                      .replaceAll("[", "")
                      .replaceAll("]", "")
                      .replaceAll("#", "");
                  myBoxLib.delete(saveComicName);

                  final firebaseApp = Firebase.app();
                  final rtdb = FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: 'https://digilibv01-default-rtdb.europe-west1.firebasedatabase.app/');

                  DatabaseReference ref = rtdb.ref(userID).child('library').child(saveComicName);

                  await ref.remove();

                }
              },
              icon: Icon(isAdded ? Icons.check : Icons.add),
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: () async {

                setState(() {
                  isFavorite = !isFavorite;


                });
                if (isFavorite) {





                  final comic = [{'book_name' : comicData['book_name'] },{'book_image':comicData['book_image']},{'book_url': comicData['book_url']}];

                  myBox.put( saveComicName,comic); // Veriyi kutuya ekleyin

                  String userID = _userId().split('@')[0];
                  userID = userID
                      .replaceAll(".", "")
                      .replaceAll("\$", "")
                      .replaceAll("[", "")
                      .replaceAll("]", "")
                      .replaceAll("#", "");
                  final firebaseApp = Firebase.app();
                  final rtdb = FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: 'https://digilibv01-default-rtdb.europe-west1.firebasedatabase.app/');

                  DatabaseReference ref = rtdb.ref(userID).child('favorites').child(saveComicName);

                  await ref.set([
                    {"book_name": comicData['book_name']},
                    {"book_image": comicData['book_image']},
                    {"book_url": comicData['book_url']},

                  ]);
                }else {
                  String userID = _userId().split('@')[0];
                  userID = userID
                      .replaceAll(".", "")
                      .replaceAll("\$", "")
                      .replaceAll("[", "")
                      .replaceAll("]", "")
                      .replaceAll("#", "");
                  myBox.delete(saveComicName);

                  final firebaseApp = Firebase.app();
                  final rtdb = FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: 'https://digilibv01-default-rtdb.europe-west1.firebasedatabase.app/');

                  DatabaseReference ref = rtdb.ref(userID).child('favorites').child(saveComicName);

                  await ref.remove();

                }
              },
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            ),
          ),
          Expanded(child: IconButton(onPressed: () {}, icon: Icon(Icons.add_alert_outlined))),
        ],
      ),
    );
  }

  TextStyle _buildHeaderTextStyle() => TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 25,
    color: mainScreenProperties.fontColorWhite,
    backgroundColor: mainScreenProperties.backgroundColorThird,
  );

  TextStyle _buildSubtitleTextStyle() => TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
    color: mainScreenProperties.fontColorWhite,
    backgroundColor: mainScreenProperties.backgroundColorThird,
  );
}



String errorControl(String comicName){
  final pathErrorList = [".", "#", "\$", "[", "]"];
  for (var errorElement in pathErrorList){
    if (comicName.contains(errorElement)){
      comicName = comicName.replaceAll(errorElement, '');

    }
  }


  return comicName;

}
