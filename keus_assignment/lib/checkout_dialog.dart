import 'package:flutter/material.dart';
import 'package:keus_assignment/theme/colors.dart';
import 'images.dart';
import 'bloc/cart/cart_bloc.dart';
import 'models/food_item.dart';
import 'utils.dart';
import 'widgets/quantity_widget.dart';

class CheckoutDialog extends StatelessWidget {
  final CartState cartState;
  final Function(FoodItem item, int quentity) onUpdateQuantity;
  final Function(FoodItem item) onDropFood;
  final VoidCallback onClose;
  final VoidCallback onPay;

  const CheckoutDialog(
      {super.key,
      required this.cartState,
      required this.onUpdateQuantity,
      required this.onDropFood,
      required this.onClose,
      required this.onPay});

  @override
  Widget build(BuildContext context) {
    final foodsItems = cartState.cartItemList
        .map((item) => _CartItem(
              cartItem: item,
              onDecrementQuantity: () {
                onUpdateQuantity(item.foodItem, item.quantity - 1);
              },
              onIncrementQuantity: () {
                onUpdateQuantity(item.foodItem, item.quantity + 1);
              },
              onDropFromCart: () {
                onDropFood(item.foodItem);
              },
            ))
        .toList();
    return FractionallySizedBox(
      widthFactor: 1,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 0, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "We will deliver in\n24 minutes to the address",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                          onPressed: onClose,
                          icon: const Icon(
                            Icons.close,
                            color: Colors.black,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text("100A Ealling Road",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 24,
                  ),
                  ...foodsItems,
                  Divider(
                    thickness: 0.5,
                    color: AppColors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: _CutleryWidget(),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: AppColors.grey,
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  _PaymentMethods(),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: ElevatedButton(
              onPressed: onPay,
              child: SizedBox(
                height: 50,
                child: (cartState.cartItemList.isNotEmpty)
                    ? Row(
                        children: [
                          const Text(
                            "Pay",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const Spacer(),
                          Text(
                              "Total : ${cartState.cartItemList.map((item) => item.foodItem.price * item.quantity).reduce((a, b) => a + b).roundToTwoDecimal().toCurrency()}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16))
                        ],
                      )
                    : Container(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onDropFromCart;
  final VoidCallback onDecrementQuantity;
  final VoidCallback onIncrementQuantity;

  const _CartItem(
      {required this.cartItem,
      required this.onDecrementQuantity,
      required this.onIncrementQuantity,
      required this.onDropFromCart});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          AppImages.foodPlaceHolder,
          height: 50,
          width: 50,
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                cartItem.foodItem.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 16),
              child: QuantityWidget(
                  quantity: cartItem.quantity,
                  onDecrementQuantity: onDecrementQuantity,
                  onIncrementQuantity: onIncrementQuantity),
            )
          ],
        )),
        Text(
          (cartItem.foodItem.price * cartItem.quantity).toCurrency(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
            onPressed: onDropFromCart,
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ))
      ],
    );
  }
}

class _CutleryWidget extends StatefulWidget {
  @override
  State<_CutleryWidget> createState() => _CutleryWidgetState();
}

class _CutleryWidgetState extends State<_CutleryWidget> {
  var _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 15,),
        const Icon(Icons.food_bank),
        const SizedBox(width: 30,),
        const Text("Cutlery"),
        const Spacer(),
        QuantityWidget(
            quantity: _quantity,
            onDecrementQuantity: () {
              if (_quantity == 1) return;
              setState(() {
                _quantity = _quantity - 1;
              });
            },
            onIncrementQuantity: () {
              setState(() {
                _quantity = _quantity + 1;
              });
            })
      ],
    );
  }
}

class _PaymentMethods extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Payment method",
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: AppColors.button,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.apple,
                    size: 14,
                  ),
                  Text(
                    "Pay",
                    style: TextStyle(fontSize: 10),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              "Apple pay",
              style: TextStyle(
                  color: AppColors.button, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            const Icon(Icons.navigate_next)
          ],
        ),
      ],
    );
  }
}
