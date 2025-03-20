import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:k_app/global.dart';
import 'package:k_app/client/screen-components/login/custom_textField.dart';
import 'package:k_app/client/screen-components/login/custom_textField2.dart';
import 'package:k_app/client/screen-components/welcome/button.dart';
import 'package:k_app/client/screens/home/home.dart';
import 'package:k_app/client/screens/register/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool showPassword = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeTextFieldsControllers();
  }

  void initializeTextFieldsControllers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    usernameController.text = ""; //emulatordevice932@gmail.com
    passwordController.text = ""; //securepass123
  }

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
                "Login here",
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
                "Welcome back, 😇 \nReady to get 💅 done?",
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

              //Email TextField
              CustomTextFieldController2(
                hintText: "Email",
                width: MediaQuery.of(context).size.width * 0.8,
                prefixIcon: Icons.email,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                iconColor: Colors.blue,
              ),

              //Password TextField
              CustomTextFieldController2(
                hintText: "Password",
                width: MediaQuery.of(context).size.width * 0.8,
                prefixIcon: Icons.lock_clock,
                controller: passwordController,
                isPassword: true,
                marginTop: 10,
                iconColor: Colors.blue,
              ),

              const SizedBox(
                height: 20,
              ),

              //Forgot password?
              Padding(
                padding: EdgeInsets.only(right: marginRigth),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot password?",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 20,
              ),

              //Login Button
              CustomButton(
                text: "SIGN IN",
                backgroungColor: Colors.lightBlue,
                width: 160,
                onPressed: () {
                  //navigatorKey.currentState?.pushNamed('/home');
                  Navigator.of(context).push(createRoute(Home(), 1.0, 0.0));
                },
              ),

              SizedBox(
                height: 25,
              ),

              //Register an account instead
              GestureDetector(
                onTap: () {
                  //navigatorKey.currentState?.pushNamed('/register');
                  Navigator.of(context).push(createRoute(Register(), 0.0, 1.0));
                },
                child: Text(
                  "Don't have an account?",
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
              )

              /* Expanded(
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
              )*/
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
