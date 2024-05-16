import 'package:flutter/material.dart';

class PopupMessageDialog extends StatefulWidget {
  final String message;
  const PopupMessageDialog({
    super.key,
    required this.message,
  });

  @override
  State<PopupMessageDialog> createState() => _PopupMessageDialogState();
}

class _PopupMessageDialogState extends State<PopupMessageDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.message,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
            fontFamily: "Epilogue"),
      ),
      content: null,
      actions: <Widget>[
        TextButton(
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(const Size(50, 50)),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
