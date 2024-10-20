import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cards/filter_card_widget.dart';
import 'cards/food_item_card.dart';
import 'cards/recommended_card.dart';
import 'checkout_dialog.dart';
import 'theme/colors.dart';
import 'utils.dart';

import 'bloc/cart/cart_bloc.dart';
import 'bloc/home/home_state_bloc.dart';
import 'food_detail.dart';
import 'images.dart';
import 'models/food_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeStateBloc>(
          create: (BuildContext context) =>
              HomeStateBloc()..add(RefreshHomeEvent()),
        ),
        BlocProvider<CartBloc>(
          create: (BuildContext context) => CartBloc(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(20)),
            child: const Text("100 Ealing Rd . 24 minus",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.normal)),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: AppColors.button,
                ))
          ],
        ),
        drawer: Drawer(
          child: ListView(),
        ),
        body: _FoodUiState(),
      ),
    );
  }
}

class _FoodUiState extends StatelessWidget {
  void _openFoodDetail(BuildContext parentContext, FoodItem item) {
    showModalBottomSheet(
        context: parentContext,
        showDragHandle: true,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) {
          return FoodDetail(
            item: item,
            onAdd: (FoodItem item, int quantity) {
              Navigator.pop(context);
              parentContext
                  .read<CartBloc>()
                  .add(AddInCartEvent(foodItem: item, quantity: quantity));
            },
          );
        });
  }

  void _openCart(BuildContext parentContext) {
    showModalBottomSheet(
        context: parentContext,
        showDragHandle: true,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) {
          return BlocConsumer<CartBloc, CartState>(
            bloc: BlocProvider.of<CartBloc>(parentContext),
            listener: (context, state) {
              if (state.cartItemList.isEmpty) {
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              return CheckoutDialog(
                cartState: state,
                onUpdateQuantity: (FoodItem item, int quantity) {
                  parentContext.read<CartBloc>().add(UpdateQuantityInCart(
                      foodItemId: item.id, quantity: quantity));
                },
                onDropFood: (FoodItem item) {
                  parentContext
                      .read<CartBloc>()
                      .add(DeleteFromCart(foodItemId: item.id));
                },
                onClose: () {
                  Navigator.pop(context);
                },
                onPay: () {
                  parentContext.read<CartBloc>().add(ClearCartEvent());
                  const snackBar = SnackBar(
                    content: Text('Order placed'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final list = context.watch<HomeStateBloc>().state;
    final cart = context.watch<CartBloc>().state;
    return Stack(
      children: [
        ListView.separated(
            itemBuilder: (context, index) {
              final item = list.cards[index];
              switch (item) {
                case FoodItemUiCard():
                  return InkWell(
                    onTap: () => _openFoodDetail(context, item.foodItem),
                    child: FoodItemCard(
                      item: item.foodItem,
                    ),
                  );
                case RecommendedUiCard():
                  return RecommendedCard(
                    foodList: item.foodList,
                    onClick: (FoodItem item) => _openFoodDetail(context, item),
                  );
                case EmptyFooter():
                  return const SizedBox(
                    height: 100,
                  );
                case FilterCard():
                  return FilterCardWidget(
                    card: item,
                    onFilter: (Filter filter) {
                      context
                          .read<HomeStateBloc>()
                          .add(FilterEvent(filter: filter));
                    },
                  );
              }
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 8,
              );
            },
            itemCount: list.cards.length),
        AnimatedPositioned(
            right: 20,
            left: 20,
            bottom: cart.cartItemList.isNotEmpty ? 20 : -50,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: ElevatedButton(
              onPressed: () => _openCart(context),
              child: SizedBox(
                height: 45,
                child: (cart.cartItemList.isNotEmpty)
                    ? Row(
                        children: [
                          const Text(
                            "Cart",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const Spacer(),
                          Text(
                              "Total : ${cart.cartItemList.map((item) => item.foodItem.price * item.quantity).reduce((a, b) => a + b).roundToTwoDecimal().toCurrency()}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16)),
                          const SizedBox(
                            width: 8,
                          ),
                          const Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                          )
                        ],
                      )
                    : Container(),
              ),
            ))
      ],
    );
  }
}
