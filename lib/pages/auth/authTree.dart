import 'package:my_digital_library/pages/home/home.dart';

import 'auth.dart';

import 'authPage.dart';
import 'package:flutter/material.dart';
class authTree extends StatefulWidget {
  const authTree({Key? key}) : super(key: key);

  @override
  State<authTree> createState() => _authTreeState();
}

class _authTreeState extends State<authTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot){

          if (snapshot.hasData){
            return homePage();
          } else{
            return const authPage();
          }


        },
    );
  }
}
