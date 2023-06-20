import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_digital_library/constants/constants.dart';
import '../../constants/responsive.dart';
import '../../widgets/bottomNavBar.dart';
import '../auth/auth.dart';

class settingsHome extends StatefulWidget {
  const settingsHome({Key? key}) : super(key: key);

  @override
  _settingsHomeState createState() => _settingsHomeState();
}

class _settingsHomeState extends State<settingsHome> {
  File? _selectedImage;
  bool switchValue = false;
  final User? user = Auth().currentUser;

  String _userEmail(){
    return user?.email ?? '';
  }



  @override
  void initState() {
    super.initState();
    _loadLastSavedImage();
  }


  Future<void> _loadLastSavedImage() async {
    final appDir = await getApplicationDocumentsDirectory();
    final directory = Directory(appDir.path);
    final files = directory.listSync();

    if (files.isEmpty) return; // No saved images

    final lastImage = files.lastWhere(
          (file) => file is File && file.path.endsWith('.png'),
      orElse: () => File(''), // Return an empty file as the fallback
    ) as File?;

    if (lastImage != null) {
      setState(() {
        _selectedImage = lastImage;
      });
    }
  }

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return; // User cancelled image picking

    final imageFile = File(pickedImage.path);

    final appDir = await getApplicationDocumentsDirectory();

    // Delete previously saved images
    final directory = Directory(appDir.path);
    final files = directory.listSync();

    for (final file in files) {
      if (file is File && file.path.endsWith('.png')) {
        file.deleteSync();
      }
    }

    final fileName = DateTime.now().millisecondsSinceEpoch.toString();

    final savedImage = await imageFile.copy('${appDir.path}/$fileName.png');

    setState(() {
      _selectedImage = savedImage;
    });
  }

  ImageProvider<Object> osController(_selectedImage){
  try {
  if (_selectedImage != null) {
    ImageProvider<Object> imageProvider = FileImage(_selectedImage!);
  return imageProvider;
  } else {
    ImageProvider<Object> imageProvider = AssetImage('assets/images/default_gif.gif');
  return imageProvider;
  }
  } catch (e) {

    ImageProvider<Object> imageProvider = AssetImage('assets/images/default_gif.gif');
    return imageProvider;
  // Hata durumunda yapılacaklar

  }

}


  @override
  Widget build(BuildContext context) {
    var currentWidth=  MediaQuery.of(context).size.width;
    var currentHeight=  MediaQuery.of(context).size.height;


    var bottomIndex = 2;
    return Scaffold(
      appBar: appBarProperties().buildSideAppBar('Settings'),
      bottomNavigationBar: bottomNavBar(bottomIndex: bottomIndex),
      body: _buildWebImagePicker(context,currentWidth,currentHeight),//kIsWeb ? _buildWebImagePicker(context) : _buildMobileImagePicker(context),
    );
  }

  Container _buildWebImagePicker(BuildContext context,currentWidth,currentHeight ) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child:  !kIsWeb ? _buildMobileImagePicker(context) : reponsiveFunc(currentWidth) == 2 ? smallSizeBodyColumn() : bigSizeBodyColumn(currentWidth,currentHeight),
      ),
    );
  }
  Container bigSizeBodyColumn(currentWidth,currentHeight) {
    return Container(
      margin: EdgeInsets.fromLTRB(100, 0, 100, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(

                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    width: currentWidth < 1000   ? currentWidth/3 : currentWidth/5 ,
                    height: currentHeight >500 ? currentHeight/2 * 1.3 : currentHeight >345 ? currentHeight/2 : currentHeight >262 ? currentHeight/3 :currentHeight/3 ,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: kIsWeb ? NetworkImage('${settings.settingsImageURL}') : osController(_selectedImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0) ,
                    child: Text(_userEmail(),style: TextStyle(fontWeight: FontWeight.w500, fontSize: mainScreenProperties.subtitleFontSize15),),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 20,),
          VerticalDivider(color: Colors.black, indent: 10, endIndent: 10, thickness: 3),
          SizedBox(width: 20,),
          
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Card(
                    child: ListTile(
                      tileColor: Colors.black.withOpacity(.1),
                      leading: Icon( Icons.dark_mode_outlined, ),
                      trailing: Switch(
                        activeColor: Colors.black,
                        value: switchValue,
                        onChanged: (newValue) {
                          setState(() {
                            switchValue = newValue;
                          });
                        },
                      ),
                      title: Text(
                        'Dark Theme (in development)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      tileColor: Colors.black.withOpacity(.1),
                      leading: Icon(Icons.ad_units_outlined),
                      title: Text(
                          'Change Password (in development)',//'Setting 2',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      tileColor: Colors.black.withOpacity(.1),
                      leading: Icon(Icons.ad_units_outlined),
                      title: Text(
                        'Change Email (in development)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          
           
        ],
      ),
    );
  }


  SingleChildScrollView smallSizeBodyColumn() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: 200,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: kIsWeb ? NetworkImage('${settings.settingsImageURL}') : osController(_selectedImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0) ,
            child: Text(
              _userEmail(),
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: mainScreenProperties.subtitleFontSize15),
            ),
          ),
          SizedBox(height: 20,),
          Divider(color: Colors.black, indent: 10, endIndent: 10, thickness: 3),
          SizedBox(height: 20,),
          SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    tileColor: Colors.black.withOpacity(.1),
                    leading: Icon( Icons.dark_mode_outlined, ),
                    trailing: Switch(
                      activeColor: Colors.black,
                      value: switchValue,
                      onChanged: (newValue) {
                        setState(() {
                          switchValue = newValue;
                        });
                      },
                    ),
                    title: Text(
                      'Dark Theme (in development)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    tileColor: Colors.black.withOpacity(.1),
                    leading: Icon(Icons.ad_units_outlined),
                    title: Text(
                      'Change Password (in development)',//'Setting 2',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    tileColor: Colors.black.withOpacity(.1),
                    leading: Icon(Icons.ad_units_outlined),
                    title: Text(
                      'Change Email (in development)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }




  Container _buildMobileImagePicker(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 200,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: osController(_selectedImage),
                    fit: BoxFit.cover,
                  ),
                ),
                child: TextButton(
                  onPressed: _pickImage,
                  child: Text(
                    '',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0) ,
                child: Text(
                  _userEmail(),
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: mainScreenProperties.subtitleFontSize15),
                ),
              ),
              SizedBox(height: 20,),
              Divider(color: Colors.black, indent: 10, endIndent: 10, thickness: 3),
              SizedBox(height: 20,),
              SingleChildScrollView(

                child: Column(
                  children: [
                    Card(
                      child: ListTile(
                        tileColor: Colors.black.withOpacity(.1),
                        leading: Icon( Icons.dark_mode_outlined, ),
                        trailing: Switch(
                          activeColor: Colors.black,
                          value: switchValue,
                          onChanged: (newValue) {
                            setState(() {
                              switchValue = newValue;
                            });
                          },
                        ),
                        title: Text(
                          'Dark Theme (in development)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        tileColor: Colors.black.withOpacity(.1),
                        leading: Icon(Icons.ad_units_outlined),
                        title: Text(
                          'Change Password (in development)',//'Setting 2',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        tileColor: Colors.black.withOpacity(.1),
                        leading: Icon(Icons.ad_units_outlined),
                        title: Text(
                          'Change Email (in development)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}