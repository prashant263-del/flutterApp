import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

class MultiSelectDropdownList extends StatefulWidget {
  const MultiSelectDropdownList({Key? key}) : super(key: key);

  @override
  State<MultiSelectDropdownList> createState() => _HomePageState();
}

class _HomePageState extends State<MultiSelectDropdownList> {
  List<String> fruits = ['Apple', 'Banana', 'Graps', 'Orange', 'Mango'];
  List<String> selectedFruits = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multiselect Dropdown'),
      ),
      body: Center(
        child: SizedBox(
          width: 200,
          child: Column(
            children: [
              DropDownMultiSelect(
                options: fruits,
                selectedValues: selectedFruits,
                onChanged: (value) {
                  print('selected fruit $value');
                  setState(() {
                    selectedFruits = value;
                  });
                  print('you have selected $selectedFruits fruits.');
                },
                whenEmpty: 'Select your favorite fruits',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
