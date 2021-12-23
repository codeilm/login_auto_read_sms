import 'package:flutter/material.dart';

myAlertDialog(context, msg) async {
  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(msg),
          content: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        );
      });
}
