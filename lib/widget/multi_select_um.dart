import 'package:flutter/material.dart';

class MultiSelectUm extends StatefulWidget {

  final List<String> reportList;
  MultiSelectUm(this.reportList);

  @override
  _MultiSelectUmState createState() => _MultiSelectUmState();
}

class _MultiSelectUmState extends State<MultiSelectUm> {

  bool isSelected = false;
  String selectedChoice = "";

  _buildChoiceList() {
    List<Widget> choices = List();
    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              selectedChoice = item;
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}