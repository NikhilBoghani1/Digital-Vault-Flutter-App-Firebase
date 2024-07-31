import 'package:digital_vault/const/constants.dart';
import 'package:digital_vault/screen/home/home_screen.dart';
import 'package:digital_vault/screen/navigation/navigation_bar.dart';
import 'package:digital_vault/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onSwitch; // Callback to switch between login and register

  const LoginScreen({required this.onSwitch, Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  Color emailBorderColor = Colors.grey;
  Color passwordBorderColor = Colors.grey;

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
  }

  Future<void> _login() async {
    User? user = await _authService.signInWithEmailAndPassword(
      emailController.text,
      passwordController.text,
    );

    if (user != null) {
      // Login successful, navigate to HomeScreen
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => NavigationBarView()));
    } else {
      // Show error message if login failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed. Please check your credentials.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
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
                      "Log in",
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
                  "Login with one of the following options.",
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 14),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 14),
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
              // Center(
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       padding: EdgeInsets.symmetric(horizontal: 150, vertical: 15),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(5),
              //       ),
              //     ),
              //     child: Text(
              //       'Login',
              //       style: TextStyle(
              //         fontFamily: myConstants.RobotoR,
              //       ),
              //     ),
              //     onPressed: _login,
              //   ),
              // ),
              GestureDetector(
                onTap: _login,
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
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  child: Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: myConstants.RobotoR,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              // Center(
              //   child: TextButton(
              //     child: Text(
              //       'Don’t have an account? Register',
              //       style: TextStyle(
              //         color: CupertinoColors.black,
              //         fontFamily: myConstants.RobotoR,
              //       ),
              //     ),
              //     onPressed: widget.onSwitch,
              //   ),
              // ),
              SizedBox(height: 30),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Don’t have an account?",
                      style: TextStyle(
                        fontFamily: myConstants.RobotoR,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: widget.onSwitch,
                      child: Text(
                        "Register",
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
      ),
    );
  }
}
