import 'package:flutter/material.dart';
import 'package:my_digital_library/constants/constants.dart';
import '../constants/comicDatas.dart';
import '../pages/details/bookDetails.dart';

class gridViewSearch extends StatefulWidget {
  const gridViewSearch({Key? key}) : super(key: key);

  @override
  State<gridViewSearch> createState() => _gridViewSearchState();
}

class _gridViewSearchState extends State<gridViewSearch> {
  List<dynamic> myData = comicDatas().comicDataList[0]['properties'];

  late List<String> comicDatasSearchList;
  List<String>? itemListSearch;
  final FocusNode _textFocusNode = FocusNode();
  final TextEditingController? _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    comicDatasSearchList = [];
    for (var element in myData) {
      comicDatasSearchList.add(element['book_name']);
    }
  }

  @override
  void dispose() {
    _textFocusNode.dispose();
    _textEditingController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(.1),
          title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: TextField(
                controller: _textEditingController,
                focusNode: _textFocusNode,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  prefix: Icon(Icons.search),
                  hintText: 'Search Here',
                  border: InputBorder.none,
                ),

                // search etmek için
                onChanged: (value) {
                  setState(() {
                    itemListSearch = comicDatasSearchList
                        .where((element) =>
                            element.toLowerCase().contains(value.toLowerCase()))
                        .toList();

                    if (_textEditingController!.text.isNotEmpty &&
                        itemListSearch!.isEmpty) {
                      print('itemsListSearch length ${itemListSearch!.length}');
                    }
                  });
                },
              ),
            ),
          ),
        ),
        body: _textEditingController!.text.isNotEmpty && itemListSearch!.isEmpty
            ? Container(
                child: Text('No Result Found'),
              )
            : ListView.builder(
                itemCount: _textEditingController!.text.isNotEmpty
                    ? itemListSearch!.length
                    : comicDatasSearchList.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    

                    child: ListTile(


                        visualDensity: VisualDensity(vertical:4),

                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => bookDetailPage(
                                  comicData: _textEditingController!
                                          .text.isNotEmpty
                                      ? myData[myData.indexOf(myData.firstWhere(
                                          (element) =>
                                              element['book_name'] ==
                                              itemListSearch![index]))]
                                      : myData[myData.indexOf(myData.firstWhere(
                                          (element) =>
                                              element['book_name'] ==
                                              comicDatasSearchList![index]))],
                                ) // comicData: myData['properties'][index]

                            ));
                      },
                      leading: Image.network(
                        _textEditingController!.text.isNotEmpty
                            ? (dataProperties.baseUrl +
                                (myData.firstWhere((element) =>
                                    element['book_name'] ==
                                    itemListSearch![index]))['book_url'])
                            : (dataProperties.baseUrl +
                                (myData.firstWhere((element) =>
                                    element['book_name'] ==
                                    comicDatasSearchList![index]))['book_url']),
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        _textEditingController!.text.isNotEmpty
                            ? (itemListSearch?[index] ?? 'null')
                            : comicDatasSearchList[index],
                      ),
                    ),
                  );
                }));
  }
}
