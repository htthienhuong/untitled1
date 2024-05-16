import 'package:flutter/material.dart';

class SwitchWidget extends StatefulWidget {
  final Function getValue;
  const SwitchWidget({super.key, required this.getValue});

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  bool selectedValue = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Row(
        children: [
          Text(selectedValue ? 'Back Side' : 'Front Side'),
          const SizedBox(
            width: 8,
          ),
          Switch(
            activeColor: Colors.blueAccent,
            value: selectedValue,
            onChanged: (value) {
              setState(() {
                setState(() {
                  selectedValue = value;
                });
                widget.getValue(selectedValue);
              });
            },
          ),
        ],
      ),
    );
  }
}
