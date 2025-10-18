import 'package:flutter/material.dart';
import 'package:van_view_app/components/app_button.dart';

class AppForm extends StatefulWidget {
  final TextEditingController firstInputController;
  final TextEditingController secondInputController;
  final VoidCallback onSubmit;
  final String buttonText;
  final String? firstInputLabel;
  final String? secondInputLabel;
  final Icon? firstInputIcon;
  final Icon? secondInputIcon;

  const AppForm({
    super.key,
    required this.firstInputController,
    required this.secondInputController,
    required this.onSubmit,
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
          controller: widget.secondInputController,
          decoration: InputDecoration(
            labelText: widget.secondInputLabel,
            border: OutlineInputBorder(),
            prefixIcon: widget.secondInputIcon,
          ),
          obscureText: true,
        ),
        SizedBox(height: 30),
        AppButton(
          text: widget.buttonText,
          onPressed: widget.onSubmit,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
