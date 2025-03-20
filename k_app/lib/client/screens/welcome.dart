import 'package:flutter/material.dart';
import 'package:k_app/app_colors.dart';
import 'package:k_app/global.dart';
import 'package:k_app/client/screen-components/welcome/button.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: 88.0, right: marginRigth, left: marginleft),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomButton(
                text: "Login",
                backgroungColor: Colors.blue,
                onPressed: () {
                  navigatorKey.currentState?.pushNamed('/login');
                },
              ),
            ),
            Expanded(
              child: CustomButton(
                text: "Register",
                backgroungColor: AppColors.textColor,
                onPressed: () {
                  navigatorKey.currentState?.pushNamed('/register');
                },
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: Column(
            children: [
              //Logo
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/images/welcome.jpg",
                  ),
                ),
              ),

              const SizedBox(
                height: 24,
              ),
              Text(
                "Welcome to K-App",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 35,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 24,
              ),
              Text(
                "We are here to help you to find the best for you",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
