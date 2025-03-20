import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:k_app/app_colors.dart';
import 'package:k_app/global.dart';
import 'package:k_app/client/models/home/v1/Nail_model.dart';
//import 'package:k_app/models/home/bottomBarItems.dart';
import 'package:k_app/client/screen-components/home/v1/CustomAppBar.dart';
import 'package:k_app/client/screen-components/home/v1/categoryItems.dart';
import 'package:k_app/client/screen-components/home/v1/categoryItems2.dart';
import 'package:k_app/client/screen-components/home/v1/categorySection.dart';
//import 'package:dot_navigation_bar/dot_navigation_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isList = true;
  IconData listIcon = Icons.list;
  int _selectedIndex = 0;

  //Default list of categories
  List<String> categories = [
    "Dip Powder",
    "Round nails",
    "Stiletto nails",
    "Acrylic manicure",
    "Almond nails",
    "Oval nails",
  ];

  //naviation bar controller
  final _pageController = PageController(initialPage: 0);

  /// Controller to handle bottom nav bar and also handles initial page
  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 0);

  //List of bottom navigation bar items
  List<BottomBarItem> bottomBarItems = [
    BottomBarItem(
      itemLabel: "Home",
      inActiveItem: Icon(
        Icons.home_filled,
        color: Colors.blueGrey,
      ),
      activeItem: Icon(
        Icons.home_filled,
        color: Colors.blueAccent,
      ),
    ),
    BottomBarItem(
      itemLabel: "Favorite",
      inActiveItem: Icon(
        Icons.favorite_border_outlined,
        color: Colors.blueGrey,
      ),
      activeItem: Icon(
        Icons.favorite_border_outlined,
        color: Colors.blueAccent,
      ),
    ),
    BottomBarItem(
      itemLabel: "Profile",
      inActiveItem: Icon(
        Icons.person,
        color: Colors.blueGrey,
      ),
      activeItem: Icon(
        Icons.person,
        color: Colors.blueAccent,
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: "User name",
          showBackArrowLeadingiIcon: false,
          actionIcon: Icons.message_outlined,
        ),
        body: _body(),
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.width * 0.25,
          child: _bottomNav(),
        ),
      ),
    );
  }

  Padding _bottomNav() {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: AnimatedNotchBottomBar(
          notchBottomBarController: _controller,
          bottomBarItems: bottomBarItems,
          onTap: (value) {
            print("Tapped");
          },
          kIconSize: 50,
          kBottomRadius: 28.0,
          shadowElevation: 5,
          textOverflow: TextOverflow.visible,
        ),
      ),
    );
  }

  Padding _body() {
    return Padding(
      padding: EdgeInsets.only(left: marginleft, right: marginRigth),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                //Categories section
                /* CustomCategoryTab(
                  categoryList: categories,
                ), */
                SizedBox(
                  height: 20,
                ),
                //Menu List or Grid
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                    IconButton(
                      icon: isList ? Icon(Icons.grid_view) : Icon(Icons.list),
                      color: AppColors.textColor,
                      onPressed: () {
                        setState(() {
                          isList = !isList; //Toggle between list and grid
                          listIcon = Icons.grid_view;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                //Display the list of categories
                isList ? _oneColumnMenu() : _twoColumsMenu(),
              ],
            ),
          ),
        ],
      ),
    );
  }

/* 
  DotNavigationBar _bottomNav() {
    return DotNavigationBar(
      currentIndex: 0,
      onTap: _onItemTapped,
      backgroundColor: AppColors.textColor,
      enableFloatingNavBar: true,
      marginR: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      items: [
        /// Home
        DotNavigationBarItem(
          icon: Icon(Icons.home),
          selectedColor: Colors.purple,
        ),

        /// Likes
        DotNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          selectedColor: Colors.pink,
        ),

        /// Profile
        DotNavigationBarItem(
          icon: Icon(Icons.person),
          selectedColor: Colors.teal,
        ),
      ],
    );
  }

  DotNavigationBar _bottomNav2() {
    return DotNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      enableFloatingNavBar: true,
      items: [
        /// Home
        DotNavigationBarItem(
          icon: Icon(Icons.home),
          selectedColor: Colors.purple,
        ),

        /// Likes
        DotNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          selectedColor: Colors.pink,
        ),

        /// Profile
        DotNavigationBarItem(
          icon: Icon(Icons.person),
          selectedColor: Colors.teal,
        ),
      ],
    );
  }
 */

// One column menu
  ListView _oneColumnMenu() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: Nail.nails.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: CustomCategoryItems(nail: Nail.nails[index]),
        );
      },
    );
  }

// Two columns menu
  GridView _twoColumsMenu() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: Nail.nails.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        return CustomItemCategories(nail: Nail.nails[index]);
      },
    );
  }
}
