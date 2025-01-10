import 'package:flutter/material.dart';
import 'package:mutabaah_yaumiyah/screen/chart_page.dart';
import 'package:mutabaah_yaumiyah/screen/home_page.dart';

class NavigationWidget extends StatefulWidget {
  const NavigationWidget({super.key});

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  int _index = 0;

  final List<Widget> _pages = [HomePage(), ChartPage()];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= 600) {
        //Large Screen : using drawer
        return Scaffold(
          appBar: AppBar(
            title: Center(
                child: Text(
              "Mutabaah Yaumiyah",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
          ),
          body: _pages[_index],
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text("Mutabaah Yaumiyah"),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text("Home"),
                  onTap: () {
                    setState(() {
                      _index = 0;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.bar_chart),
                  title: const Text("Charts"),
                  onTap: () {
                    setState(() {
                      _index = 1;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      } else {
        //small screen
        return Scaffold(
          appBar: AppBar(
            title: Center(
                child: Text(
              "Mutabaah Yaumiyah",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
          ),
          body: _pages[_index],
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text("Mutabaah Yaumiyah"),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text("Home"),
                  onTap: () {
                    setState(() {
                      _index = 0;
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.bar_chart),
                  title: const Text("Charts"),
                  onTap: () {
                    setState(() {
                      _index = 1;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: _index,
              onTap: (index) {
                setState(() {
                  _index = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: "Home", tooltip: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.bar_chart),
                    label: "Charts",
                    tooltip: "Charts")
              ]),
        );
      }
    });
  }
}
