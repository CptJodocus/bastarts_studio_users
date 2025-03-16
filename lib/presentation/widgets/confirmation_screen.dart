import 'package:flutter/material.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hvala za prijavo!', style: TextStyle(fontSize: 48, color: Colors.black), textAlign: TextAlign.center),
            Text(
              'V kratkem boš na email prejel/a potrdilo prijave.\nSe že veselimo trenirati s teboj',
              style: TextStyle(fontSize: 24, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 48),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.black),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              child: Text('Domov'),
            ),
          ],
        ),
      ),
    );
  }
}
