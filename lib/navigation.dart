import 'package:flutter/material.dart';
import 'package:mutabaah_yaumiyah/screen/chart_page.dart';
import 'package:mutabaah_yaumiyah/screen/home_page.dart';

class NavigationWidget extends StatefulWidget {
  const NavigationWidget({super.key});

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  int _indexBottomNavBar = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: switch (_indexBottomNavBar) { 0 => HomePage(), _ => ChartPage() },
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _indexBottomNavBar,
          onTap: (index) {
            setState(() {
              _indexBottomNavBar = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: "Home", tooltip: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart), label: "Charts", tooltip: "Charts")
          ]),
    );
  }
}
