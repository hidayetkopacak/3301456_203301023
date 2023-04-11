import 'package:flutter/material.dart';
import 'package:my_digital_library/constants/constants.dart';
import 'package:my_digital_library/pages/home/widgets/iconButtonAction.dart';

import 'package:my_digital_library/widgets/customTabBar.dart';
import 'package:my_digital_library/widgets/bookStaggeredGridView.dart';

import '../../widgets/bottomNavBar.dart';


//import 'package:deneme/ui/appbar/appbar.dart';


class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {


  var bottomIndex = 0;
  var tabIndex = 0;
  final  pageController = PageController();

  // json decoder content




  @override
  Widget build(BuildContext context) {
    //final double height = MediaQuery.of(context).size.height/9;
    //final double height = 70;
    final width=  MediaQuery.of(context).size.width;

    return Scaffold(

      backgroundColor: mainScreenProperties.backgroundColor,
      appBar: _buildBuildAppBar(width),
      body: _buildBody(),
    bottomNavigationBar: bottomNavBar(bottomIndex: bottomIndex)  ,//_buidBottomNavigationBar(width),

    );
  }

  Column _buildBody() {
    return Column(
      children: [
        customTabBar(selected:tabIndex ,callback: (int index){
          setState(() {
            tabIndex = index;
          });
          pageController.jumpToPage(index);
        } ,),
        Expanded(child: bookStaggeredGridView(
          selected: tabIndex,
          pageController: pageController ,
          callBack: (int index) => setState((){
            tabIndex = index;
          }) ,
        ))


      ],

    );
  }



}


AppBar _buildBuildAppBar(width) {
  return AppBar(
    //toolbarHeight: height,
    elevation: appBarProperties.elevation,
    backgroundColor: appBarProperties.color,
    title: Text('screen width: $width',style: TextStyle(
      color: Colors.black
    ),) ,//appBarProperties.title,
    centerTitle: true,
    actions: [
      iconButtonAction(),

    ],

  );
}


















/*

  Widget _buidBottomNavigationBar(width) {
     final List bottoms = bottomNavigationBar.navBarItems;


    return Container(
      color: Colors.grey[200],
      width: width,
      height: 56,

      child: ListView.separated(


          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) => GestureDetector(
            onTap: () {

              if (index == 1){
                Navigator.push(context, MaterialPageRoute(builder: (context) => sourcesHome()));

              }
              else if (index == 2){
                Navigator.push(context, MaterialPageRoute(builder: (context) => sourcesHome()));

              }
              else{

                setState(() {
                  bottomIndex = index;

                });

              }


            } ,
            child: Container(


              width: (width-40)/bottoms.length,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: bottomIndex == index ?
              const BoxDecoration(
                border: Border(
                  bottom: BorderSide(

                    width: 3,
                    color: Colors.deepOrange,
                  ),
                ),
              ):null,
              child: Icon(bottoms[index],

              size:30,
                color: bottomIndex == index ? mainScreenProperties.fontColor: Colors.grey[400] ,
              ),

            ),
          ),
          separatorBuilder: (_, index) => const SizedBox(width: 10,),
          itemCount: bottoms.length),
    );
  }



 */