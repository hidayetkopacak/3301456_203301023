import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:my_digital_library/constants/constants.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';



import 'package:my_digital_library/pages/details/bookDetails.dart';

import '../../constants/responsive.dart';
import '../../widgets/bottomNavBar.dart';
import 'funcs.dart';





class SourcesHome extends StatefulWidget {
  const SourcesHome({Key? key}) : super(key: key);

  @override
  State<SourcesHome> createState() => _SourcesHomeState();
}

class _SourcesHomeState extends State<SourcesHome> {
  List<Map<String, dynamic>> parsedData = [];
  List<Map<String, dynamic>> filteredData = [];
  TextEditingController _searchController = TextEditingController();
  bool textFieldControl = false;
  bool _showClearButton = false;
  //final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchControllerListener);
    checkCacheData();
  }
  @override
  void dispose() {
    _searchController.removeListener(_searchControllerListener);
    _searchController.dispose();
    super.dispose();
  }


  void _searchControllerListener() {
    setState(() {
      _showClearButton = _searchController.text.isNotEmpty;
    });
  }

  Widget _buildClearButton() {
    return IconButton(
      icon: Icon(Icons.clear, color: Colors.black),
      onPressed: () {
        setState(() {
          _searchController.clear();
          filterData('');
        });
      },
    );
  }


  Future createUserDeneme({required String book_image, required String book_name, required String book_url, required var is_added, required var is_favorite}) async{
    final docComicsMode = FirebaseFirestore.instance.collection("ComicsMode").doc('000a-deneme');
    DocumentSnapshot snapshot = await docComicsMode.get();
    final json = {
      'book_image': book_image,
      'book_name': book_name,
      'book_url': book_url,
      'is_added' : is_added,
      'is_favorite' : is_favorite,
    };

    if (snapshot.exists) {
      List<dynamic>? comics = (snapshot.data() as Map<String, dynamic>)['comics']?.cast<dynamic>();

      if (comics != null) {
        comics.add(json); // Add the new JSON data to the comics list
        await docComicsMode.update({'comics': comics});

        bool alreadyExists = false;
        for (Map comic in comics) {
          if (comic['book_name'] == json['book_name']) {
            alreadyExists = true;
            break;
          }
        }

        if (!alreadyExists) {
          comics.add(json); // Add the new JSON data to the comics list
          await docComicsMode.update({'comics': comics}); // Update the 'comics' field in Firestore
        }
      }
    }




    //snapshot.data() == null ? [] : snapshot.data()['liste'] ;

    //liste.add(json);

    //await docComicsMode.set(liste);



  }
  Future createUser({required String book_image, required String book_name, required String book_url, required var is_added, required var is_favorite}) async{
    final docComicsMode = FirebaseFirestore.instance.collection("ComicsMode").doc('$book_name');
    final json = {
      'book_image': book_image,
      'book_name': book_name,
      'book_url': book_url,
      'is_added' : is_added,
      'is_favorite' : is_favorite,
    };

    await docComicsMode.set(json);



  }

  Future<void> checkCacheData() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedComicDatas = prefs.getString('comicDatas');

    if (cachedComicDatas != null) {
      final List<dynamic> cachedData = jsonDecode(cachedComicDatas);
      final List<Map<String, dynamic>> comicDatas = [];

      for (final data in cachedData) {
        comicDatas.add({
          'book_name': data['book_name'],
          'book_image': data['book_image'],
          'book_url': data['book_url'],
          'is_added': data['is_added'],
          'is_favorite': data['is_favorite'],
        });
      }

      setState(() {
        parsedData.addAll(comicDatas);
      });
    }

    readData();
  }

  Future<void> readData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final collectionRef = FirebaseFirestore.instance.collection("ComicsMode");
      final querySnapshot = await collectionRef.get();
      print(querySnapshot);

      if (querySnapshot.size > 0) {
        final List<Map<String, dynamic>> comicDatas = [];

        for (final doc in querySnapshot.docs) {

          if (doc.id == '000a-deneme') {
            continue;
          }

          final data = doc.data();
          comicDatas.add({
            'book_name': data['book_name'],
            'book_image': data['book_image'],
            'book_url': data['book_url'],
            'is_added': data['is_added'],
            'is_favorite': data['is_favorite'],
          });
        }

        await prefs.setString('comicDatas', jsonEncode(comicDatas));
        setState(() {
          parsedData.addAll(comicDatas);
        });
      } else {
        // Veritabanında hiç kayıt yoksa yapılacak işlemler
      }
    } catch (e) {
      print(e);
      getData();
      // Hata durumunda yapılacak işlemler
      //print('Veri okuma hatası: $e');
    }
  }

  Future<void> getData() async {
    var comicDatas = <Map<String, dynamic>>[];
    var base_url = 'https://www.comicsmode.com';
    var request_url = '$base_url/comics';
    var next_page_url = request_url;

    while (next_page_url.isNotEmpty) {
      var response = await http.get(Uri.parse(next_page_url));
      var document = parser.parse(response.body);
      var next_page = (document.querySelectorAll("a.page-link").last.attributes["href"]) ?? '';
      next_page_url = base_url + next_page;
      var all_comics = document.getElementsByClassName('tcs-wrap');

      var tempComicDatas = <Map<String, dynamic>>[];

      for (var comic in all_comics) {
        var comic_link = base_url + comic.getElementsByTagName('a')[0].attributes['href']!;
        var comic_name = comic.getElementsByTagName('img')[0].attributes['alt']!.trim();
        comic_name = comic_name.replaceAll('/', ' ');
        var comic_url = base_url + comic.getElementsByTagName('img')[0].attributes['src']!;
        var is_added = false;
        var is_favorite = false;

        createUser(book_image:comic_url, book_name:comic_name,book_url: comic_link ,is_added:is_added, is_favorite: is_favorite );

        tempComicDatas.add({
          'book_name': comic_name,
          'book_image': comic_url,
          'book_url': comic_link,
          'is_added' : is_added,
          'is_favorite' : is_favorite,
        });
      }

      comicDatas.addAll(tempComicDatas);

      if (mounted) {
        setState(() {
          parsedData.addAll(tempComicDatas);
        });
      }

      // Veritabanında hiç kayıt yoksa yapılacak işlemler
      if (comicDatas.isEmpty) {
        //print('getData sonlandırıldı');
        break;
      }
    }

    //var json_object = jsonEncode(comicDatas); sonra lazım olacak
  }




  void filterData(String query) {
    //print(query);
    final List<Map<String, dynamic>> results = [];
    if (query.isNotEmpty) {
      parsedData.forEach((data) {
        final String bookName = data['book_name'];
        if (bookName.toLowerCase().contains(query.toLowerCase())) {
          results.add(data);
        }
      });
    } else {
      results.addAll(parsedData);
    }
    setState(() {
      filteredData = results;
    });
  }

  @override
  Widget build(BuildContext context)  {
    var currentWidth=  MediaQuery.of(context).size.width;
    var bottomIndex = 1;
    return Scaffold(
      appBar: appBarProperties().buildSideAppBar('ComicsMode',automaticallyImplyLeading: 'yes'),
      bottomNavigationBar: bottomNavBar(bottomIndex: bottomIndex),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
            child: TextField(
              controller: _searchController,

              cursorColor: Colors.black.withOpacity(.1),
              cursorWidth: 1,

              onTap: (){
                textFieldControl = true;

              },
              onChanged: (value) {
                filterData(value);
              },

              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black,width: 2),
                ),
                labelText: 'Search',
                prefixIcon: Icon(Icons.search, color: Colors.black),
                suffixIcon: _showClearButton ? _buildClearButton() : null,
                border: UnderlineInputBorder(),
                filled: true, // Set filled to true
                fillColor: mainScreenProperties.navBarColorFirst,
                labelStyle: TextStyle(color: mainScreenProperties.fontColor),
                hintStyle: TextStyle(color: mainScreenProperties.fontColor),
                // Specify the background color
              ),
            ),
          ),
          Expanded(child: buildTapped(context,currentWidth))






        ],
      ),
    );
  }

  Container buildTapped(BuildContext context,currentWidth) {
    if (textFieldControl){
      return Container(
        margin: reponsiveFunc(currentWidth) == 4 ? EdgeInsets.fromLTRB(200, 0, 200, 0 ): EdgeInsets.all(0),

        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: reponsiveFunc(currentWidth),
            childAspectRatio: 0.7,
          ),
          itemCount: filteredData.length,
          padding: EdgeInsets.all(tabBarAndGridViewMarginPaddin.tabBarMargin / 2),
          itemBuilder: (_, index) {
            var bookName = filteredData[index]['book_name'];
            var bookImage = filteredData[index]['book_image'];
            var bookLink = filteredData[index]['book_url'];
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: GridTile(
                child: Ink.image(
                  image: NetworkImage('$bookImage'),
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
      );

    }else{
      return parsedData.length!= 0 ? Container(

        child: Padding(
          padding: reponsiveFunc(currentWidth) == 4 ? EdgeInsets.fromLTRB(200, 0, 200, 0 ): EdgeInsets.all(0),
          child: Container(


            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: reponsiveFunc(currentWidth),
                  childAspectRatio: 0.7),
              itemCount: parsedData.length,
              padding: EdgeInsets.all(tabBarAndGridViewMarginPaddin.tabBarMargin/2),
              itemBuilder: (_, index) {
                var bookName = parsedData[index]['book_name'];
                var bookImage = parsedData[index]['book_image'];
                var bookLink = parsedData[index]['book_url'];
                //print(bookLink);
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GridTile(

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
                          //backgroundColor: Colors.grey,
                        ),
                      ),
                    ),
                    child: Ink.image(
                      image: NetworkImage(
                          '${bookImage}'),
                      fit: BoxFit.cover,
                      child: InkWell(
                        onTap: () {

                          Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
                              bookDetailPageScrap(comicData:getSingleComicDatas(bookLink,bookName,bookImage) )

                          ));

                        },

                      ),

                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ) : Container(width:double.infinity,height:double.infinity,child: Center(child: Text('[cloud_firestore/resource-exhausted] Quota exceeded. 50.000 okuma limiti geçildi. Sitenin kendisinden veri çekmeye hazırlanılıyor...')));
    }

  }
}








/* -------------------------------------------------- */



