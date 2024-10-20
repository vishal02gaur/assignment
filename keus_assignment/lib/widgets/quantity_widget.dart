import 'package:flutter/material.dart';

import '../theme/colors.dart';

class QuantityChipWidget extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrementQuantity;
  final VoidCallback onIncrementQuantity;

  const QuantityChipWidget(
      {super.key,
      required this.quantity,
      required this.onDecrementQuantity,
      required this.onIncrementQuantity});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.grey, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              iconSize: 18,
              onPressed: onDecrementQuantity,
              icon: const Icon(Icons.remove)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '$quantity',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
              iconSize: 18,
              onPressed: onIncrementQuantity,
              icon: const Icon(Icons.add))
        ],
      ),
    );
  }
}

class QuantityWidget extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrementQuantity;
  final VoidCallback onIncrementQuantity;

  const QuantityWidget(
      {super.key,
      required this.quantity,
      required this.onDecrementQuantity,
      required this.onIncrementQuantity});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
              color: AppColors.grey, borderRadius: BorderRadius.circular(8)),
          child: IconButton(
              iconSize: 18,
              padding: EdgeInsets.zero,
              onPressed: onDecrementQuantity,
              icon: Icon(
                Icons.remove,
                color: AppColors.button,
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '$quantity',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.button,
            ),
          ),
        ),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
              color: AppColors.grey, borderRadius: BorderRadius.circular(8)),
          child: IconButton(
              iconSize: 18,
              padding: EdgeInsets.zero,
              onPressed: onIncrementQuantity,
              icon: Icon(
                Icons.add,
                color: AppColors.button,
              )),
        ),
      ],
    );
  }
}
