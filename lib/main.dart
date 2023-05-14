// ignore_for_file: prefer_const_constructors
// import 'package:flutter_demo_app/pages/auditors/createNewAudit_1.dart';
import 'package:flutter_demo_app/pages/admin/addAuditorBySEBIadmin.dart';
import 'package:flutter_demo_app/pages/auditors/createNewAudit.dart';
import 'package:flutter_demo_app/pages/auditors/recentAudits.dart';
import 'package:flutter_demo_app/pages/auditors/testCode.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/pages/auditors/auditors_homepage.dart';
// import 'package:flutter_demo_app/pages/getData.dart';
import 'package:flutter_demo_app/pages/profile.dart';
import 'package:flutter_demo_app/utils/routes.dart';
import 'pages/homepage.dart';
import 'pages/login_page.dart';
// import 'pages/login.dart';
import 'pages/screen1.dart';

// import 'pages/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: HomePage(),
      // themeMode: ThemeMode.light,
      // theme: ThemeData(primarySwatch: Colors.deepPurple),
      // darkTheme: ThemeData(
      //   brightness: Brightness.dark,
      // ),
      title: 'SEBI CSR Audit Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.black),
        canvasColor: Color.fromARGB(255, 250, 250, 250),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => LoginPage(),
        MyRoutes.homeRoute: (context) => HomePage(),
        MyRoutes.homeRoute: (context) => NewAudit(userID: '1'),
        // MyRoutes.loginRoute: (context) => Profile(),
        // MyRoutes.loginRoute: (context) => Screen1(),
        MyRoutes.recentAudits: (context) => RecentAudits(userID: '1')
        // AuditorsHomepage(),
      },
    );
  }
}
