import 'package:flutter/material.dart';
// AppBar customization
class appBarProperties{
  static Color color = Colors.white;
  static  const double elevation = 0;

  static TextStyle appBarTextStyle = TextStyle(
    color: mainScreenProperties.fontColor,
    fontSize: mainScreenProperties.headerFontSize,
  );

  //Leading Soldaki Buton
  static Text title = Text("My Digital Library",
  style: appBarTextStyle
  );

  AppBar? buildSideAppBar(title){
    return AppBar(
      elevation: elevation,
      backgroundColor: color,
      centerTitle: true,

      title: Text(
        title,
        style: appBarTextStyle,

      ),


    );


  }

}

// Ana ekran Main Screen Scaffold içi
class mainScreenProperties{
  static Color backgroundColor = Colors.white;
  static Color backgroundColorSecond = Colors.black.withOpacity(.1);
  static Color backgroundColorThird = Colors.black.withOpacity(.5);
  static Color cardColor = Colors.transparent;
  static const Color fontColor = Colors.black;
  static const Color fontColorWhite = Colors.white;
  static const double headerFontSize =  18;
  static const double subtitleFontSize15 = 15;
  static  Color navBarColorFirst = Colors.grey.shade200;
  static Color navBarColorSecond = Colors.grey.shade400;



}

class tabBarAndGridViewMarginPaddin{
  static double tabBarMargin = 20;

}


class tabBar{
  static const List<String> tabBarList = ['All Books', 'Favorites'];
  static final margin = EdgeInsets.symmetric(horizontal: tabBarAndGridViewMarginPaddin.tabBarMargin);
  static BoxDecoration decoration = BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(5),
      );
}

class bottomNavigationBar{
  static const List navBarItems = [
    Icons.home_outlined,
    Icons.analytics_outlined,
    Icons.settings,

  ];
}


class bookDetailActionButtons{
  static const List actionButtonList = [

    Icons.share,
    Icons.download,
    Icons.more_vert_outlined,

  ];

}


class dataProperties{
  static const String baseUrl = "https://www.comicsmode.com";

}

class settings{
  static const String settingsImageURL = "https://media.discordapp.net/attachments/1002331255112745021/1095258473597509662/scottjonsson_instagram.gif?width=261&height=465";


}




