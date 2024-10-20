import 'package:flutter/material.dart';
import 'package:keus_assignment/utils.dart';

import '../images.dart';
import '../models/food_item.dart';
import '../theme/colors.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItem item;

  const FoodItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Image.asset(
            AppImages.foodPlaceHolder,
            height: 100,
            width: 100,
          ),
        ),
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Container(
                      padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                          color: AppColors.grey,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(item.price.toCurrency(),
                          style: TextStyle(
                              color: AppColors.button,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${item.calories} Kcal",
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                )
              ],
            ))
      ],
    );
  }
}