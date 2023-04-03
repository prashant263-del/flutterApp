// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/pages/login_page.dart';
// import '../pages/profile.dart';
import '../pages/getData.dart';
import '../pages/profile_old.dart';
import '../pages/screen1.dart';
import '../pages/homepage.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: UserAccountsDrawerHeader(
              accountName: Text("Hello Prashant"),
              accountEmail: Text("prashant@metamiind.com"),
            ),
          ),
          ListTile(
            leading: Icon(
              CupertinoIcons.home,
              color: Colors.black,
            ),
            title: Text(
              "Home",
              textScaleFactor: 1.2,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => HomePage()));
            },
          ),
          ListTile(
            leading: Icon(
              CupertinoIcons.info,
              color: Colors.black,
            ),
            title: Text(
              "Info",
              textScaleFactor: 1.2,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Screen1()));
            },
          ),
          ListTile(
            leading: Icon(
              CupertinoIcons.info,
              color: Colors.black,
            ),
            title: Text(
              "GetData",
              textScaleFactor: 1.2,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => GetData()));
            },
          ),
          ListTile(
            leading: Icon(
              CupertinoIcons.info,
              color: Colors.black,
            ),
            title: Text(
              "Profile",
              textScaleFactor: 1.2,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Profile()));
            },
          ),
          ListTile(
            leading: Icon(
              CupertinoIcons.info,
              color: Colors.black,
            ),
            title: Text(
              "Logout",
              textScaleFactor: 1.2,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage()));
            },
          )
        ],
      ),
    );
  }
}
