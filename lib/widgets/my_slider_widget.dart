import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SliderWidget extends StatefulWidget {
  final Function getSize;
  final double max;

  const SliderWidget({super.key, required this.max, required this.getSize});

  @override
  State<SliderWidget> createState() => SliderWidgetState();
}

class SliderWidgetState extends State<SliderWidget> {
  double currentSliderValue = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          child: Text(
            '${currentSliderValue.toInt()}/${widget.max.toInt()}',
          ),
        ),
        Slider(
          inactiveColor: const Color(0xffd0d4ec),
          activeColor: const Color(0xff647ebb),
          value: currentSliderValue,
          max: widget.max,
          divisions: widget.max.toInt(),
          label: currentSliderValue.round().toString(),
          onChanged: (double value) {
            if (value < 1) {
              currentSliderValue = 1;
            } else {
              setState(() {
                currentSliderValue = value;
                widget.getSize(value.toInt());
              });
            }
          },
        ),
      ],
    );
  }
}
