import 'package:flutter/material.dart';

class MultiSelect extends StatefulWidget {

  final List<dynamic> reportList;
  final Function(List<dynamic>) onSelectionChanged;
  MultiSelect(this.reportList,{this.onSelectionChanged});

  @override
  _MultiSelectState createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {

  List<dynamic> selectedChoices = List();

  _buildChoiceList() {

    List<Widget> choices = List();

    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                ? selectedChoices.remove(item)
                : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });
    
    return choices;

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        children: _buildChoiceList(),
      ),
    );
  }
}