import 'package:flutter/material.dart';
import 'package:my_digital_library/constants/constants.dart';

import 'widgets/bookDetailSingle.dart';


class bookDetailPage extends StatelessWidget {
  final Map comicData;

  const bookDetailPage({required this.comicData,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainScreenProperties.backgroundColor,

      appBar: _buildAppBar(context),
      body: bookDetailSingle(comicData: comicData,),
    );
  }
}

AppBar _buildAppBar(BuildContext context){
  return AppBar(
    elevation: 0,
    backgroundColor: appBarProperties.color,
    leading: IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(Icons.arrow_back_ios_outlined,
        color: mainScreenProperties.fontColor,
      ),


    ),
    actions: [
      IconButton(onPressed: (){}, icon: Icon(bookDetailActionButtons.actionButtonList.last,
      color: mainScreenProperties.fontColor,
      ),)
    ],
  );

}
