import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:switch_app/widgets/textWidget.dart';

import '../constants/colors.dart';

class CustomDropdownMenu extends StatefulWidget {
  final List<String> items;
  final ValueChanged<String> onSelected;
  final String? header;
  final String? subheader;

  const CustomDropdownMenu({
    Key? key,
    required this.items,
    required this.header,
    required this.subheader,
    required this.onSelected,
  }) : super(key: key);

  @override
  _CustomDropdownMenuState createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButton<String>(
        hint: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: widget.header,
              fontSize: 12,
            ),
            TextWidget(
              text: widget.subheader,
              textColor: greyColor,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ],
        ),
        value: selectedValue,
        isExpanded: true,
        underline: SizedBox(), // Remove default underline
        icon: Icon(FontAwesomeIcons.chevronDown,
            size: 20, color: Colors.grey.shade700),
        style: TextStyle(color: Colors.black, fontSize: 16),
        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
          widget.onSelected(value!);
        },
        dropdownColor: Colors.white,
        items: widget.items.map<DropdownMenuItem<String>>((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: TextWidget(text: item),
          );
        }).toList(),
      ),
    );
  }
}
