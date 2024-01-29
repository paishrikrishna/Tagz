import 'package:flutter/material.dart';


class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  List<String> selectedReportList;
  final Function(List<String>)? onSelectionChanged;

  MultiSelectChip(this.reportList,this.selectedReportList, {this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
  
}


class _MultiSelectChipState extends State<MultiSelectChip> {

  List<String> selectedChoices = [];


  _buildChoiceList() {
    List<Widget> choices = [];

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
              widget.onSelectionChanged?.call(selectedChoices);
            });
            },
          ),
        ));
      }
    );

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    selectedChoices = widget.selectedReportList;
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}