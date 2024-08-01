import 'package:digital_vault/const/constants.dart';
import 'package:digital_vault/screen/home/home_screen.dart';
import 'package:digital_vault/service/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onSwitch; // Callback to switch between register and login

  const RegisterScreen({required this.onSwitch, Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();

  Color emailBorderColor = Colors.grey;
  Color passwordBorderColor = Colors.grey;
  Color nameBorderColor = Colors.grey;

  @override
  void initState() {
    super.initState();

    // Add listeners to the focus nodes
    emailFocusNode.addListener(() {
      setState(() {
        emailBorderColor = emailFocusNode.hasFocus ? Colors.blue : Colors.grey;
      });
    });

    passwordFocusNode.addListener(() {
      setState(() {
        passwordBorderColor =
            passwordFocusNode.hasFocus ? Colors.blue : Colors.grey;
      });
    });

    nameFocusNode.addListener(() {
      setState(() {
        nameBorderColor = nameFocusNode.hasFocus ? Colors.blue : Colors.grey;
      });
    });
  }

  // Future<void> _register() async {
  //   User? user = await _authService.registerWithEmailAndPassword(
  //     emailController.text,
  //     passwordController.text,
  //   );
  //
  //   if (user != null) {
  //     // Save the name to Firestore
  //     await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
  //       'name': nameController.text,
  //       'email': emailController.text,
  //     });
  //
  //     Navigator.of(context)
  //         .pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
  //   } else {
  //     // Show error message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Registration failed. Please try again.')));
  //   }
  // }

  Future<void> _register() async {
    // Check if the name is not empty
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter your name.')));
      return;
    }

    User? user = await _authService.registerWithEmailAndPassword(
      emailController.text,
      passwordController.text,
    );

    if (user != null) {
      // Save the name to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': nameController.text,
        'email': emailController.text,
      }).then((value) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
      }).catchError((error) {
        // Show error message if Firestore write fails
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save user data.')));
      });
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed. Please try again.')));
    }
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();

    return Scaffold(
      // appBar: AppBar(title: Text('Register')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100),
            Container(
              margin: EdgeInsets.only(left: 25),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      CupertinoIcons.left_chevron,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(
                    "Sign up",
                    style: TextStyle(
                      fontFamily: myConstants.RobotoM,
                      fontSize: 29,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 55),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                "Sign up with one of following options.",
                style: TextStyle(
                  fontFamily: myConstants.RobotoL,
                  fontSize: 17,
                  color: CupertinoColors.inactiveGray,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Image(
                      color: Colors.black,
                      width: 23,
                      height: 23,
                      image: AssetImage(
                        'assets/images/google.png',
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                    decoration: BoxDecoration(
                      color: CupertinoColors.inactiveGray.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        width: 1.5,
                        color: CupertinoColors.black.withOpacity(0.2),
                      ),
                    ),
                  ),
                  Container(
                    child: Image(
                      color: Colors.black,
                      width: 23,
                      height: 23,
                      image: AssetImage(
                        'assets/images/apple-logo.png',
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                    decoration: BoxDecoration(
                      color: CupertinoColors.inactiveGray.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        width: 1.5,
                        color: CupertinoColors.black.withOpacity(0.2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Name',
                style: TextStyle(
                  fontFamily: myConstants.RobotoR,
                  fontSize: 18,
                  color: CupertinoColors.black.withOpacity(0.7),
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                style: TextStyle(fontFamily: myConstants.RobotoR),
                controller: nameController,
                focusNode: nameFocusNode, // Set the focus node
                decoration: InputDecoration(
                  hintText: '   Enter your name',
                  hintStyle: TextStyle(
                    fontFamily: myConstants.RobotoL,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: emailBorderColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                    ), // Color when focused
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Email',
                style: TextStyle(
                  fontFamily: myConstants.RobotoR,
                  fontSize: 18,
                  color: CupertinoColors.black.withOpacity(0.7),
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                style: TextStyle(fontFamily: myConstants.RobotoR),
                controller: emailController,
                focusNode: emailFocusNode, // Set the focus node
                decoration: InputDecoration(
                  hintText: '   nikhil@gmail.com',
                  hintStyle: TextStyle(
                    fontFamily: myConstants.RobotoL,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: emailBorderColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                    ), // Color when focused
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Password',
                style: TextStyle(
                  fontFamily: myConstants.RobotoR,
                  fontSize: 18,
                  color: CupertinoColors.black.withOpacity(0.7),
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                style: TextStyle(fontFamily: myConstants.RobotoR),
                controller: passwordController,
                focusNode: passwordFocusNode, // Set the focus node
                decoration: InputDecoration(
                  hintText: '   Enter your Password',
                  hintStyle: TextStyle(
                    fontFamily: myConstants.RobotoL,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: emailBorderColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                    ), // Color when focused
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: _register,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent.withOpacity(0.2),
                      Colors.black45.withOpacity(0.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                child: Center(
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontFamily: myConstants.RobotoR,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      fontFamily: myConstants.RobotoR,
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onSwitch,
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: myConstants.PoppinsSB,
                        color: myConstants.secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
