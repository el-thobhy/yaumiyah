import 'package:flutter/material.dart';
import 'package:mutabaah_yaumiyah/navigation.dart';
import 'package:mutabaah_yaumiyah/provider/local_database_provider.dart';
import 'package:mutabaah_yaumiyah/services/sqlite_services.dart';
import 'package:mutabaah_yaumiyah/static/navigation_route.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider(create: (context) => SqliteServices()),
      ChangeNotifierProvider(
          create: (context) =>
              LocalDatabaseProvider(context.read<SqliteServices>()))
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mutabaah Yaumiyah',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: NavigationRoute.mainRoute.name,
      routes: {
        NavigationRoute.mainRoute.name: (context) => const NavigationWidget(),
      },
    );
  }
}
