// ignore_for_file: prefer_const_constructors
// import 'package:flutter_demo_app/pages/auditors/createNewAudit_1.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.black),
        canvasColor: Color.fromARGB(255, 250, 250, 250),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => NewAudit(), // HomePage
        // "/": (context) => LoginPage(), // HomePage
        // "/scrren1": (context) => const Screen1(),
        // "/home": (context) => const HomePage(),

        // "/": (context) => getData(),
        // LoginPage(),
        // MyRoutes.homeRoute: (context) => HomePage(),
        // MyRoutes.loginRoute: (context) => Profile(),
        // MyRoutes.loginRoute: (context) => Screen1(),
        // MyRoutes.auditorRoute: (context) => RecentAudits()
        // AuditorsHomepage(),
      },
    );
  }
}

// ignore_for_file: use_build_context_synchronously

// main.dart
// import 'dart:convert';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       // theme: ThemeData(
//       //   // enable Material 3
//       //   useMaterial3: true,
//       //   primarySwatch: Colors.indigo,
//       // ),
//       theme: ThemeData.light().copyWith(
//         scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
//         // scaffoldBackgroundColor: appBarColor,
//         textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
//             .apply(bodyColor: Colors.black),
//         canvasColor: Color.fromARGB(255, 250, 250, 250),
//       ),
//       home: const HomePage(),
//     );
//   }
// }

// // Multi Select widget
// // This widget is reusable
// class MultiSelect extends StatefulWidget {
//   final List<dynamic> items;
//   const MultiSelect({Key? key, required this.items}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _MultiSelectState();
// }

// class _MultiSelectState extends State<MultiSelect> {
//   // this variable holds the selected items
//   final List<dynamic> _selectedItems = [];

// // This function is triggered when a checkbox is checked or unchecked
//   void _itemChange(dynamic itemValue, bool isSelected) {
//     // print(itemValue);
//     setState(() {
//       if (isSelected) {
//         _selectedItems.add(itemValue);
//       } else {
//         _selectedItems.remove(itemValue);
//       }
//       print(_selectedItems);
//     });
//   }

//   // this function is called when the Cancel button is pressed
//   void _cancel() {
//     Navigator.pop(context);
//   }

// // this function is called when the Submit button is tapped
//   void _submit() {
//     Navigator.pop(context, _selectedItems);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Select Industries'),
//       content: SingleChildScrollView(
//         child: ListBody(
//           children: widget.items
//               .map((item) => CheckboxListTile(
//                     value: _selectedItems.contains(item['IndustryVerticalID']),
//                     title: Text(item['Industry Vertical Name']),
//                     controlAffinity: ListTileControlAffinity.leading,
//                     onChanged: (isChecked) => _itemChange(item, isChecked!),
//                   ))
//               .toList(),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: _cancel,
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: _submit,
//           child: const Text('Submit'),
//         ),
//       ],
//     );
//   }
// }

// // Implement a multi select on the Home screen
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   List<dynamic> _selectedItems = [];
//   // final List<dynamic> items = [];
//   // List _loadedIndustryList = [];

//   List<dynamic> items = [];

//   Future<void> _showMultiSelect() async {
//     const apiUrl = 'http://127.0.0.1:5000';

//     // final response = await http.get(Uri.parse(apiUrl));

//     final response = await http.get(
//       Uri.parse(apiUrl),
//       // Send authorization headers to the backend.
//       headers: {
//         'paramsfor': '{"opnfor":"100000", "act":"A-05"}',
//       },
//     );
//     // print(jsonDecode(response.body));
//     final data = json.decode("[" + response.body + "]");
//     // print(data[0]['body']['header']);

//     // print(data[0]['body']['header'].runtimeType);
//     // List<dynamic> items = data[0]['body']['header'];
//     setState(() {
//       items = data[0]['body']['header'];
//       // print(_loadedIndustryList);
//       // print(typeof(items))
//       // print(items);
//     });

//     // final List<String> items = [
//     //   'Automobile',
//     //   'Metal Industry',
//     //   'Information Tech',
//     // ];

//     final List<dynamic>? results = await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return MultiSelect(items: items);
//       },
//     );

//     // Update UI
//     if (results != null) {
//       setState(() {
//         _selectedItems = results;
//         print(results.runtimeType);
//         print('display selected $results');
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Industries Multi Select'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // use this button to open the multi-select dialog
//             ElevatedButton(
//               onPressed: _showMultiSelect,
//               child: const Text('Select Industries'),
//             ),
//             const Divider(
//               height: 30,
//             ),
//             // display selected items
//             Wrap(
//               children: _selectedItems
//                   .map((e) => Chip(
//                         label: Text(e['Industry Vertical Name']),
//                         onDeleted: () {
//                           setState(() {
//                             _selectedItems.removeWhere((e) {
//                               // return _selectedItems;
//                               _selectedItems.remove(e);
//                               return e;
//                               // return entry.name == actor.name;
//                             });
//                           });
//                         },
//                       ))
//                   .toList(),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
