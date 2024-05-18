import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.label, this.onPressed});
  final String label;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.maxFinite,
        height: 42,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Color(0xff647ebb)),
          ),
            onPressed: onPressed,
            child: Text(
              label,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            )));
  }
}
