import 'package:amazon_clone_app/constants/global_variables.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: GlobalVariables.secondaryColor,
        minimumSize: Size(double.infinity, 50),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: GlobalVariables.backgroundColor,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}
