import 'package:flutter/material.dart';
import 'package:my_digital_library/constants/constants.dart';


class bottomNavBar extends StatefulWidget {
  int bottomIndex;

  bottomNavBar({required this.bottomIndex,Key? key}) : super(key: key);

  @override
  State<bottomNavBar> createState() => _bottomNavBarState();
}

class _bottomNavBarState extends State<bottomNavBar> {
  final List bottoms = bottomNavigationBar.navBarItems;

  @override
  Widget build(BuildContext context) {
    final width=  MediaQuery.of(context).size.width;
    return Container(
      color: mainScreenProperties.navBarColorFirst,
      width: width,
      height: 56,

      child: _buildListView(context, width),
    );
  }



  ListView _buildListView(BuildContext context, double width) {
    return ListView.separated(


        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) => GestureDetector(
          onTap: () {

            if (index == 0 && widget.bottomIndex != 0){
              Navigator.pushReplacementNamed(context, '/home');

            }

            if (index == 1 && widget.bottomIndex != 1){
              Navigator.pushReplacementNamed(context, '/sources');

            }
            else if (index == 2 && widget.bottomIndex != 2){
              Navigator.pushReplacementNamed(context, '/settings');

            }
            else{

              setState(() {
                widget.bottomIndex = index;

              });

            }


          } ,
          child: Container(


            width: (width-40)/bottoms.length,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: widget.bottomIndex == index ?
            const BoxDecoration(
              border: Border(
                bottom: BorderSide(

                  width: 3,
                  color: mainScreenProperties.fontColor,
                ),
              ),
            ):null,
            child: Icon(bottoms[index],

              size:30,
              color: widget.bottomIndex == index ? mainScreenProperties.fontColor: mainScreenProperties.navBarColorSecond , //grey[400]
            ),

          ),
        ),
        separatorBuilder: (_, index) => const SizedBox(width: 10,),
        itemCount: bottoms.length);
  }
}



