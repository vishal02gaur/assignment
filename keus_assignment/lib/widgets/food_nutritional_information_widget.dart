import 'package:flutter/material.dart';

import '../theme/colors.dart';

class FoodNutritionalInformationWidget extends StatelessWidget {
  final int quantity;
  final String title;

  const FoodNutritionalInformationWidget(
      {super.key, required this.quantity, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          quantity.toString(),
          style: TextStyle(
              color: AppColors.button,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        Text(
          title,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ],
    );
  }
}