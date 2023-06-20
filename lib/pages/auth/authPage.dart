import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';


class authPage extends StatefulWidget {
  const authPage({Key? key}) : super(key: key);

  @override
  State<authPage> createState() => _authPageState();
}

class _authPageState extends State<authPage> {
  String? errorMessage = '';
  bool isLogin = true;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool showPassword = false;
  bool isLoading = false;

  Future<void> signInWithEmailAndPassword() async {
    setState(() {
      isLoading = true; // Show circular progress indicator
      errorMessage = ''; // Clear previous error message
    });

    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    } finally {
      setState(() {
        isLoading = false; // Hide circular progress indicator
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    setState(() {
      isLoading = true; // Show circular progress indicator
      errorMessage = ''; // Clear previous error message
    });

    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    } finally {
      setState(() {
        isLoading = false; // Hide circular progress indicator
      });
    }
  }


  Widget _entryField(
      String title,
      TextEditingController controller,

      ){

  return TextField(
    cursorColor: Colors.black.withOpacity(.1),
    cursorWidth: 1,
    controller: controller,
    style: TextStyle(fontWeight: FontWeight.w500),
    obscureText: title == 'password' && !showPassword ? true : false, // Password'u gizle

    decoration: InputDecoration(
      labelText: title,
        labelStyle: TextStyle(
            color: Colors.black,
          fontWeight: FontWeight.normal,


        ),

      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black,width: 2),
      ),
        suffixIcon: title == 'password' ? suffixIcon() : SizedBox(),





    ),

  );
  }

  IconButton suffixIcon() {
    return IconButton(
          icon: Icon(
            showPassword ? Icons.visibility : Icons.visibility_off,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              showPassword = !showPassword; // Durumu tersine çevirir
            }
            );
          }
          );
  }
  Widget _errorMessage(){
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage',
    style: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w500,


    ),);


  }
  Widget _submitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
      ),
      onPressed: isLoading ? null : (isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword),
      child: isLoading
          ? CircularProgressIndicator( // Show circular progress indicator
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      )
          : Text(isLogin ? 'Login' : 'Register'),
    );
  }


  Widget _loginOrRegisterButton(){
    return TextButton(
        onPressed: (){
          setState(() {
            isLogin = !isLogin;
          });

        },

      style: TextButton.styleFrom(

        foregroundColor: Colors.black,
      ),
      child: Text(isLogin ? 'Register instead' : 'Login instead'),
    );

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/default_gif.gif'),
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(.5), BlendMode.darken),
            fit: BoxFit.cover,



          ),
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 2 * (1.3),
            height: kIsWeb ? MediaQuery.of(context).size.height / 2 * (1.3) : MediaQuery.of(context).size.width / 2 * (2),

            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(.5),
            ),
            child: Column(


              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('DigiLib',

                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,


                  ) ,),
                _entryField('email', _controllerEmail),
                _entryField('password', _controllerPassword),
                _errorMessage(),
                _submitButton(),
                _loginOrRegisterButton(),


              ],

            ),

          ),
        ),
      ),

    );
  }
}
