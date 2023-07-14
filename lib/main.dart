import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/pages/createtask_page.dart';
import 'package:todoapp/pages/home_page.dart';

void main() async {
  //hive init
  await Hive.initFlutter();

  //create hive box
  var box = await Hive.openBox('todo');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        'home': (context) => const HomePage(),
        'create': (context) => const CreateTaskPage()
      },
    );
  }
}
