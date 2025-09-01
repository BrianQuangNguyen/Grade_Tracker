import 'package:flutter/material.dart';
import '../utils/colors.dart';

class ColorDropDown extends StatefulWidget {
  final Function(String) onColorSelected;
  const ColorDropDown({super.key, required this.onColorSelected});

  @override
  State<ColorDropDown> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ColorDropDown> {
  String? selectedColorName = "Red";

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: DropdownButton<String>(
        hint: Text('Select a Color'),
        value: selectedColorName,
        onChanged: (String? newValue) {
          setState(() {
            selectedColorName = newValue;
          });
          widget.onColorSelected(newValue!);
        },
        items: colorOptions.keys.map((String colorName) {
          return DropdownMenuItem<String>(
            value: colorName,
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  color: colorOptions[colorName],
                  margin: const EdgeInsets.only(right: 8),
                ),
                Text(colorName),
              ],
            ),
          );
        }).toList(), 
      ),
    );
  }
}