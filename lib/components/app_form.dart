import 'package:flutter/material.dart';

class AppForm extends StatefulWidget {
  final TextEditingController firstInputController;
  final TextEditingController secondInputController;
  final TextEditingController? thirdInputController;
  final TextEditingController? fourthInputController;
  final String? firstInputLabel;
  final String? secondInputLabel;
  final String? thirdInputLabel;
  final String? fourthInputLabel;
  final Icon? firstInputIcon;
  final Icon? secondInputIcon;
  final bool? isMoreThanTwoInput;

  const AppForm({
    super.key,
    required this.firstInputController,
    required this.secondInputController,
    this.thirdInputController,
    this.fourthInputController,
    this.firstInputLabel,
    this.secondInputLabel,
    this.thirdInputLabel,
    this.fourthInputLabel,
    this.firstInputIcon,
    this.secondInputIcon,
    this.isMoreThanTwoInput,
  });

  @override
  State<AppForm> createState() => _AppFormState();
}

class _AppFormState extends State<AppForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          if (widget.isMoreThanTwoInput == true)
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                key: const ValueKey('nameInput'),
                controller: widget.fourthInputController,
                decoration: InputDecoration(
                  labelText: widget.fourthInputLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.account_circle),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(35)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.all(Radius.circular(35)),
                  ),
                ),
              ),
            ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextField(
              key: const ValueKey('emailInput'),
              controller: widget.firstInputController,
              decoration: InputDecoration(
                labelText: widget.firstInputLabel,
                border: const OutlineInputBorder(),
                prefixIcon: widget.firstInputIcon,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextField(
              key: const ValueKey('passwordInput'),
              controller: widget.secondInputController,
              decoration: InputDecoration(
                labelText: widget.secondInputLabel,
                border: const OutlineInputBorder(),
                prefixIcon: widget.secondInputIcon,
              ),
              obscureText: true,
            ),
          ),
          const SizedBox(height: 30),
          if (widget.isMoreThanTwoInput == true)
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                key: const ValueKey('confirmPasswordInput'),
                controller: widget.thirdInputController,
                decoration: InputDecoration(
                  labelText: widget.thirdInputLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                ),
                obscureText: true,
              ),
            ),
        ],
      ),
    );
  }
}
