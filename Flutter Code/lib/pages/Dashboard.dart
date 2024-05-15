import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'package:expenso/pages/budget_page.dart';
import 'package:expenso/pages/create_page.dart';
import 'package:expenso/pages/daily_page.dart';
import 'package:expenso/pages/Profile.dart';
import 'package:expenso/pages/stats_page.dart';
import 'package:expenso/theme/colors.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int pageIndex = 0;
  List<Widget> pages = [
    DailyPage(),
    StatsPage(),
    const BudgetPage(),
    ProfilePage(),
    const CreateExpenseBudgetPage()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: getBody(),
          bottomNavigationBar: getFooter(),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                selectedTab(4);
              },
              child: Icon(
                Icons.add,
                size: 25,color: Colors.white,
              ),
              backgroundColor: primary
              //params
              ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked),
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  Widget getFooter() {
    List<IconData> iconItems = [
      Icons.calendar_month,
      Icons.add_chart,
      Icons.wallet,
      Icons.person
      
    ];

    return AnimatedBottomNavigationBar(
      activeColor: primary,
      splashColor: secondary,
      inactiveColor: Colors.black.withOpacity(0.5),
      icons: iconItems,
      activeIndex: pageIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 10,
      iconSize: 25,
      rightCornerRadius: 10,
      onTap: (index) {
        selectedTab(index);
      },
      //other params
    );
  }

  selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
