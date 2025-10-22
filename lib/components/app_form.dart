import 'package:flutter/material.dart';

class AppForm extends StatefulWidget {
  final TextEditingController firstInputController;
  final TextEditingController secondInputController;
  final String buttonText;
  final String? firstInputLabel;
  final String? secondInputLabel;
  final Icon? firstInputIcon;
  final Icon? secondInputIcon;

  const AppForm({
    super.key,
    required this.firstInputController,
    required this.secondInputController,
    required this.buttonText,
    this.firstInputLabel,
    this.secondInputLabel,
    this.firstInputIcon,
    this.secondInputIcon,
  });

  @override
  State<AppForm> createState() => _AppFormState();
}

class _AppFormState extends State<AppForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 40),
        TextField(
          key: const ValueKey('firstInput'),
          controller: widget.firstInputController,
          decoration: InputDecoration(
            labelText: widget.firstInputLabel,
            border: OutlineInputBorder(),
            prefixIcon: widget.firstInputIcon,
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 20),
        TextField(
          key: const ValueKey('secondInput'), 
          controller: widget.secondInputController,
          decoration: InputDecoration(
            labelText: widget.secondInputLabel,
            border: OutlineInputBorder(),
            prefixIcon: widget.secondInputIcon,
          ),
          obscureText: true,
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
