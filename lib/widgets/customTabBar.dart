import 'package:flutter/material.dart';
import 'package:my_digital_library/constants/constants.dart';

class customTabBar extends StatelessWidget {
  final int selected;
  final Function callback;
  customTabBar({required this.selected,required this.callback,Key? key}) : super(key: key);
  final tabs = tabBar.tabBarList;
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height/20;
    return  _buildContainer(width, height);

  }

  Container _buildContainer(double width, double height) {
    return Container(
    margin: tabBar.margin,
    decoration: tabBar.decoration,
    width: width,
    height: height,
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 5,),
      scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) => GestureDetector(
      onTap: () => callback(index),
      child: Container(
        decoration: BoxDecoration(
          color: selected == index ? Colors.white : Colors.grey[200],
          borderRadius: BorderRadius.circular(5)
        ),
        margin: const EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        width: (width-40)/2-10,
        child: Text(tabBar.tabBarList[index],
        style: TextStyle(
          color: mainScreenProperties.fontColor,
          fontWeight: FontWeight.w500,
        ),
        ),
      ),
    ) , separatorBuilder: (_,index) => const SizedBox(width: 10,), itemCount: tabBar.tabBarList.length),


  );
  }
}
