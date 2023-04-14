import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class common extends StatefulWidget {
  const common({super.key});

  @override
  State<common> createState() => _commonState();
}

class _commonState extends State<common> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  
  Future<void> _fetchData() async {
    const apiUrl = 'http://127.0.0.1:5000';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'paramsfor': '{"opnfor":"100000", "act":"A-02"}',
      },
    );

    final data = json.decode("[" + response.body + "]");

    setState(() {
      // _loadedData = data[0]['body']['header'];
    });
  }
}