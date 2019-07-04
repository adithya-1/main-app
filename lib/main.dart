import 'package:flutter/material.dart';
import 'package:not_bored/commonnav.dart';

//PAGES
import 'commonnav.dart';
import 'login_page.dart';
import 'package:not_bored/reg_page.dart';
import 'auth.dart';
import 'root_page.dart';
import 'my_friends.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    CommonNavBar.tag: (context) => CommonNavBar(),
    RegPage.tag: (context) => RegPage(),
    MyFriendsPage.tag: (context) => MyFriendsPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RootPage(auth: new Auth()),
      routes: routes,
    );
  }
}