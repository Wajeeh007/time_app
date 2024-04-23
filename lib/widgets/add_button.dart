import 'package:flutter/material.dart';

import '../helpers/constants.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key, required this.onTap, this.icon});

  final IconData? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 15,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: primaryPurple,
              boxShadow: [
                BoxShadow(
                  color: primaryGrey,
                  spreadRadius: 1,
                  blurRadius: 12,
                  offset: Offset(0, 2),
                ),
              ]
          ),
          child: Icon(
            icon ?? Icons.add,
            size: 23,
          ),
        ),
      ),
    );
  }
}