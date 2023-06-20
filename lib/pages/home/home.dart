import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_digital_library/constants/constants.dart';
import 'package:my_digital_library/widgets/customTabBar.dart';
import 'package:my_digital_library/widgets/bookStaggeredGridView.dart';
import '../../widgets/bottomNavBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/auth.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  void initializeHive() async {
    await Hive.initFlutter();
    Hive.openBox('favorites_v01');
    Hive.openBox('library_v01');
  }



  var bottomIndex = 0;
  var tabIndex = 0;
  final  pageController = PageController();
  final User? user = Auth().currentUser;
  Future<void> signOut() async{
    final myBox = Hive.box('favorites_v01');
    final myBoxLib = Hive.box('library_v01');

    myBox.clear();
    myBoxLib.clear();
    await Auth().signOut();
  }

  String _userId(){
    return user?.email!.split('@')[0] ?? 'User email';
  }
  Widget _signOutButton(){
    return Padding(
      padding:EdgeInsets.fromLTRB(8, 8, 0, 8) ,
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.grey[200]!),

          ),

          onPressed: signOut,
          child: const Text('Sign Out',
            style: TextStyle(
              color: mainScreenProperties.fontColor,

            ),
          ),


        ),
      ),
    );

  }

  AppBar _buildBuildAppBar(width,email,) {
    return AppBar(
      //toolbarHeight: height,
      elevation: appBarProperties.elevation,
      backgroundColor: appBarProperties.color,

      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(width: 40, height: 40,child: Image.asset('assets/images/default_image.png')),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text('DigiLib',style: TextStyle(
                      color: Colors.black
                  ),),
                ),
                Container(
                  //margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                  child: Text('$email: $width',style: TextStyle(
                    color: Colors.black.withOpacity(.5),
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),),
                ) ,
              ],
            ),


          ],
        ),
      ) ,

      centerTitle: true,
      actions: [
        //iconButtonAction(),
        _signOutButton(),


      ],

    );
  }


  // json decoder content




  @override
  Widget build(BuildContext context) {
    //final double height = MediaQuery.of(context).size.height/9;
    //final double height = 70;
    final width=  MediaQuery.of(context).size.width;

    return Scaffold(

      backgroundColor: mainScreenProperties.backgroundColor,
      appBar: _buildBuildAppBar(width,_userId()),
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




















