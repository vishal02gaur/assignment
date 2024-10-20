import 'package:flutter/material.dart';
import 'utils.dart';

import 'images.dart';
import 'models/food_item.dart';
import 'widgets/food_nutritional_information_widget.dart';
import 'widgets/quantity_widget.dart';

class FoodDetail extends StatefulWidget {
  final FoodItem item;
  final Function(FoodItem item, int quantity) onAdd;

  const FoodDetail({super.key, required this.item, required this.onAdd});

  @override
  State<FoodDetail> createState() => _FoodDetailState();
}

class _FoodDetailState extends State<FoodDetail> {
  var _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                AppImages.foodPlaceHolder,
                height: 200,
                width: 200,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              widget.item.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              widget.item.description,
              style: const TextStyle(),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FoodNutritionalInformationWidget(
                      quantity: widget.item.calories * _quantity,
                      title: 'kcal',
                    ),
                    FoodNutritionalInformationWidget(
                      quantity: widget.item.grams * _quantity,
                      title: 'grams',
                    ),
                    FoodNutritionalInformationWidget(
                      quantity: widget.item.proteins * _quantity,
                      title: 'proteins',
                    ),
                    FoodNutritionalInformationWidget(
                      quantity: widget.item.fats * _quantity,
                      title: 'fats',
                    ),
                    FoodNutritionalInformationWidget(
                      quantity: widget.item.carbs * _quantity,
                      title: 'carbs',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                QuantityChipWidget(
                  quantity: _quantity,
                  onDecrementQuantity: () {
                    if (_quantity > 1) {
                      setState(() {
                        _quantity--;
                      });
                    }
                  },
                  onIncrementQuantity: () {
                    setState(() {
                      _quantity++;
                    });
                  },
                ),
                const Spacer(),
                ElevatedButton(
                    onPressed: () => widget.onAdd(widget.item, _quantity),
                    child: Text(
                        "Add to cart  ${(widget.item.price * _quantity).toCurrency()}"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
