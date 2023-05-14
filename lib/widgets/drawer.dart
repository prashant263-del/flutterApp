// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_demo_app/pages/auditors/auditors_homepage.dart';
import 'package:flutter_demo_app/pages/login_page.dart';
import '../pages/admin/addAuditorByCompanyAdmin.dart';
import '../pages/admin/addAuditorBySEBIadmin.dart';
import '../pages/auditors/createNewAudit_1.dart';
import '../pages/auditors/testCode.dart';
import '../pages/auditors/testPage.dart';
import '../pages/getData.dart';
import '../pages/profile_old.dart';
import '../pages/auditors/recentAudits.dart';
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
              accountEmail: Text("prashant@metamind.com"),
            ),
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage(
            //         "D:/FlutterApp/flutter_tutorials/flutter_demo_app/assets/images/cats.png"),
            //   ),
            // ),
          ),
          // ListTile(
          //   leading: Icon(
          //     CupertinoIcons.home,
          //     color: Colors.black,
          //   ),
          //   title: Text(
          //     "Home",
          //     textScaleFactor: 1.2,
          //   ),
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.of(context).push(MaterialPageRoute(
          //         builder: (BuildContext context) => HomePage()));
          //   },
          // ),
          // ListTile(
          //   leading: Icon(
          //     CupertinoIcons.news,
          //     color: Colors.black,
          //   ),
          //   title: Text(
          //     "Info",
          //     textScaleFactor: 1.2,
          //   ),
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.of(context).push(MaterialPageRoute(
          //         builder: (BuildContext context) => NewAudit()
          //         // Screen1()
          //         ));
          //   },
          // ),
          // ListTile(
          //   leading: Icon(
          //     CupertinoIcons.info,
          //     color: Colors.black,
          //   ),
          //   title: Text(
          //     "GetData",
          //     textScaleFactor: 1.2,
          //   ),
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.of(context).push(MaterialPageRoute(
          //         builder: (BuildContext context) => GetData()));
          //   },
          // ),
          // ListTile(
          //   leading: Icon(
          //     CupertinoIcons.info,
          //     color: Colors.black,
          //   ),
          //   title: Text(
          //     "TestPage",
          //     textScaleFactor: 1.2,
          //   ),
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.of(context).push(MaterialPageRoute(
          //         builder: (BuildContext context) => testPage()));
          //   },
          // ),
          ListTile(
            leading: Icon(
              CupertinoIcons.house_alt,
              color: Colors.black,
            ),
            title: Text(
              "Auditors Homepage",
              textScaleFactor: 1.2,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      RecentAudits(userID: '1')));
            },
          ),
          ListTile(
            leading: Icon(
              CupertinoIcons.create_solid,
              color: Colors.black,
            ),
            title: Text(
              "Create New Audit",
              textScaleFactor: 1.2,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => NewAudit()));
            },
          ),
          // ListTile(
          //   leading: Icon(
          //     CupertinoIcons.info,
          //     color: Colors.black,
          //   ),
          //   title: Text(
          //     "Auditor Master",
          //     textScaleFactor: 1.2,
          //   ),
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.of(context).push(MaterialPageRoute(
          //         builder: (BuildContext context) => AuditorsDetails()));
          //   },
          // ),
          ListTile(
            leading: Icon(
              CupertinoIcons.person_add,
              color: Colors.black,
            ),
            title: Text(
              "Add Auditor SEBI-Admin",
              textScaleFactor: 1.2,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ExternalAuditorDetails()));
            },
          ),
          ListTile(
            leading: Icon(
              CupertinoIcons.person_add,
              color: Colors.black,
            ),
            title: Text(
              "Add Auditor Company-Admin",
              textScaleFactor: 1.2,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => InternalAuditorDetails()));
            },
          ),
          ListTile(
            leading: Icon(
              CupertinoIcons.return_icon,
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
