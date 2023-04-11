import 'package:flutter/material.dart';
import 'package:my_digital_library/constants/constants.dart';


import '../../widgets/bottomNavBar.dart';

class settingsHome extends StatelessWidget {
  const settingsHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bottomIndex = 2;
    return Scaffold(
      appBar: appBarProperties().buildSideAppBar('Settings'),
      bottomNavigationBar: bottomNavBar(bottomIndex: bottomIndex) ,
      body: Container(
        width: double.infinity,
        height: double.infinity,

        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(


            children: [

              Container(
                width: MediaQuery.of(context).size.width/2*(1.3),
                height: MediaQuery.of(context).size.height/2*(.8),
                //color: Colors.black,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),


                  image: DecorationImage(

                    image: NetworkImage('${settings.settingsImageURL}'),
                    fit: BoxFit.cover,

                  )



                ),

              ),
              SizedBox(height: 20,),
              Divider(color: Colors.black, indent: 10, endIndent: 10, thickness: 3),
              SizedBox(height: 20,),
              Card(child: ListTile(tileColor: Colors.black.withOpacity(.1),

              leading: Icon(Icons.ad_units_outlined,),
                title: Text('Setting 1',

                style: TextStyle(
                  fontWeight: FontWeight.bold,

                ),
                ),

              )


              ),
              Card(child: ListTile(tileColor: Colors.black.withOpacity(.1),

                leading: Icon(Icons.ad_units_outlined,),
                title: Text('Setting 2',

                  style: TextStyle(
                    fontWeight: FontWeight.bold,

                  ),
                ),

              )


              ),
              Card(child: ListTile(tileColor: Colors.black.withOpacity(.1),

                leading: Icon(Icons.ad_units_outlined,),
                title: Text('Setting 3',

                  style: TextStyle(
                    fontWeight: FontWeight.bold,

                  ),
                ),

              )


              ),


            ],
          ),
        ),
      ),


    );
  }
}
