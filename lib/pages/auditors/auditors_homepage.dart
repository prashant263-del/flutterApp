// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import '../../../constants.dart';
import 'package:flutter_demo_app/pages/auditors/recentAudits_old.dart';
import '../../responsive.dart';
import '../../widgets/drawer.dart';

class AuditorsHomepage extends StatelessWidget {
  const AuditorsHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    // key: context.read<MenuAppController>().scaffoldKey,
    // drawer: const MyDrawer(),
    // body: SafeArea(
    //   child: SingleChildScrollView(
    //     primary: false,
    //     padding: EdgeInsets.all(defaultPadding),
    //     child: Column(
    //       children: [
    //         // Header(),
    //         SizedBox(height: defaultPadding),
    //         Row(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Expanded(
    //               flex: 5,
    //               child: Column(
    //                 children: [
    //                   // MyFiles(),
    //                   SizedBox(height: defaultPadding),
    //                   RecentAudits(),
    //                   if (Responsive.isMobile(context))
    //                     SizedBox(height: defaultPadding),
    //                   // if (Responsive.isMobile(context)) StarageDetails(),
    //                 ],
    //               ),
    //             ),
    //             if (!Responsive.isMobile(context))
    //               SizedBox(width: defaultPadding),
    //             // On Mobile means if the screen is less than 850 we dont want to show it
    //             if (!Responsive.isMobile(context))
    //               Expanded(
    //                 flex: 2,
    //                 child: RecentAudits(),
    //               ),
    //           ],
    //         )
    //       ],
    //     ),
    //   ),
    // ),
//     );
//   }
// }

    return Scaffold(
      body: SafeArea(child: RecentAudits()),
    );
  }
}
