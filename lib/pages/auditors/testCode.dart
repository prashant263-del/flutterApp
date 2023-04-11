import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../utils/multiSelectDropdown.dart';
import '../getData.dart';
// import 'package:flutter_demo_app/pages/homepage.dart';

class MyDropDowns extends StatefulWidget {
  // final List<dynamic> items;
  // const MyDropDowns({Key? key, required this.items}) : super(key: key);
  @override
  _MyDropDownsState createState() => _MyDropDownsState();
}

class _MyDropDownsState extends State<MyDropDowns> {
  // String? _selectedItem;
  dynamic _selectedItem;
  List<dynamic> _multiSelectedItems = [];

  List<dynamic> items =
      //  [
      //   'Item 1',
      //   'Item 2',
      //   'Item 3',
      //   'Item 4',
      //   'Item 5',
      // ];

      [
    {'Company ID': '1', 'Company Name': 'HDFC'},
    {'Company ID': '2', 'Company Name': 'AXIS Bank'}
  ];

  final _multiSelectKey = GlobalKey<FormFieldState<List<String>>>();
  dynamic newValue;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          DropdownButton(
            value: _selectedItem,
            hint: Text('Select an item'),
            onChanged: (newValue) {
              setState(() {
                _selectedItem = newValue as dynamic?;
              });
            },
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item['Company Name']),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          MultiSelectDialogField(
            key: _multiSelectKey,
            title: Text('Select multiple items'),
            buttonText: Text('Select'),
            items: items.map((item) {
              return MultiSelectItem<dynamic>(
                  item['Company ID'], item['Company Name']);
            }).toList(),
            initialValue: _multiSelectedItems,
            onConfirm: (values) {
              setState(() {
                _multiSelectedItems = values!;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_multiSelectKey.currentState!.validate()) {
                _multiSelectKey.currentState!.save();
                print('Selected items: $_multiSelectedItems');
              }
            },
            child: Text('Save'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => GetData()));
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
