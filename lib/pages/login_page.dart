// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously

import 'package:flutter/material.dart';
import '../utils/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = '';
  bool changeButton = false;

  final _formkey = GlobalKey<FormState>();
  moveToHome(BuildContext context) async {
    setState(() {
      changeButton = true;
    });
    await Future.delayed(Duration(seconds: 1));
    await Navigator.pushNamed(context, MyRoutes.recentAudits);
    setState(() {
      changeButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    width: 330,
                    child: Image.asset(
                      "assets/images/sebi.png",
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  Text(
                    "Welcome $name",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                    child: SizedBox(
                      width: 350,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: "Enter username",
                              labelText: "Username",
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Username cannot be empty";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              name = value;
                              setState(() {});
                            },
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Enter password",
                              labelText: "Password",
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          // ElevatedButton(
                          Material(
                            color: Colors.deepPurple,
                            borderRadius:
                                BorderRadius.circular(changeButton ? 50 : 8),
                            child: InkWell(
                              splashColor: Colors.red,
                              onTap: () => moveToHome(context),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 100),
                                width: changeButton ? 50 : 150,
                                height: 50,
                                alignment: Alignment.center,
                                child: changeButton
                                    ? Icon(
                                        Icons.done,
                                        color: Colors.white,
                                      )
                                    : Text(
                                        'Login',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
