import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:k_app/global.dart';
import 'package:k_app/client/screen-components/login/custom_textField2.dart';
import 'package:k_app/client/screen-components/welcome/button.dart';
import 'package:k_app/client/screens/login/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(allMargin),
        child: SafeArea(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Login message

              Text(
                "Create an account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                  color: Colors.black,
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              //Welcome message
              Text(
                "Welcome to our 💅 community",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Poppins",
                  color: Colors.grey,
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              //Username TextField
              CustomTextFieldController2(
                hintText: "Username",
                width: MediaQuery.of(context).size.width * 0.8,
                prefixIcon: Icons.person,
                controller: usernameController,
                iconColor: Colors.pinkAccent,
              ),

              //Email TextField
              CustomTextFieldController2(
                hintText: "Email",
                width: MediaQuery.of(context).size.width * 0.8,
                prefixIcon: Icons.email,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                iconColor: Colors.pinkAccent,
                marginTop: 10,
              ),

              //Password TextField
              CustomTextFieldController2(
                hintText: "Password",
                width: MediaQuery.of(context).size.width * 0.8,
                prefixIcon: Icons.lock_clock,
                controller: passwordController,
                isPassword: true,
                marginTop: 10,
                iconColor: Colors.pinkAccent,
              ),

              const SizedBox(
                height: 40,
              ),

              //Login Button
              CustomButton(
                text: "SIGN UP",
                backgroungColor: Colors.pinkAccent,
                width: 160,
                onPressed: () {},
              ),

              SizedBox(
                height: 25,
              ),

              //Login instead
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(createRoute(Login(), 0.0, -1.0));
                  //navigatorKey.currentState?.pushNamed('/login');
                },
                child: Text(
                  "Already have an account?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              /**/ Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Or continue with
                    Text(
                      "Or continue with",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _signUpWith2("assets/svgs/gmail.svg"),
                        SizedBox(
                          width: 20,
                        ),
                        _signUpWith2("assets/svgs/phone.svg"),
                      ],
                    )
                  ],
                ),
              ),

              /*  Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Or continue with
                    Text(
                      "Or ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //Register with gmail
                    _signUpWith("assets/svgs/gmail.svg", "Register with Gmail",
                        marginTop: 20),
                    //Register with phone number
                    _signUpWith(
                        "assets/svgs/phone.svg", "Register with Phone number",
                        marginTop: 10),
                  ],
                ),
              ) */
            ],
          ),
        ),
      ),
    );
  }

  Container _signUpWith2(String svgPath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.blue,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 20),
      child: SvgPicture.asset(
        svgPath,
        width: 30,
      ),
    );
  }

  Padding _signUpWith(String svgPath, String text, {double marginTop = 0}) {
    return Padding(
      padding: EdgeInsets.only(left: marginleft, right: marginRigth),
      child: Container(
        margin: EdgeInsets.only(top: marginTop),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.blue,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              svgPath,
              width: 30,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              text,
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
