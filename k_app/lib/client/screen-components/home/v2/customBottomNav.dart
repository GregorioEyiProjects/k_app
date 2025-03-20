import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:k_app/app_colors.dart';
import 'package:k_app/global.dart';

class CustomBottomNav extends StatefulWidget {
  final int page;
  const CustomBottomNav({super.key, required this.page});

  @override
  State<CustomBottomNav> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CustomBottomNav> {
  // Global key for CurvedNavigationBar
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // Page index
  int? _pageIndex;

  @override
  void initState() {
    super.initState();
    _pageIndex = widget.page;
  }

  // List of items
  List<Widget> getItems() {
    return [
      Icon(Icons.home,
          size: 25,
          color: _pageIndex == 0
              ? AppColors.lightBlueAccent
              : AppColors.greyColor),
      Icon(Icons.payment,
          size: 25,
          color: _pageIndex == 1
              ? AppColors.lightBlueAccent
              : AppColors.greyColor),
    ];
  }

  void _onTap(int index) async {
    setState(() {
      _pageIndex = index;
    });

    /**/ final CurvedNavigationBarState? navBarState =
        _bottomNavigationKey.currentState;

    Future.delayed(
      Duration(milliseconds: 60),
      () {
        switch (index) {
          case 0:
            navBarState?.setPage(0);
            navigatorKey.currentState?.pushReplacementNamed('/home');

            break;
          case 1:
            navBarState?.setPage(1);
            navigatorKey.currentState?.pushReplacementNamed('/billing');

            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: AppColors.lightBlueAccent,
      index: _pageIndex!,
      onTap: _onTap, // Pass the function reference without calling it
      items: getItems(),
    );
  }

/*   Navigator.pushReplacement(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => YourNewPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  ),
); */
}
