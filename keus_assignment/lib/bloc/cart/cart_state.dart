part of 'cart_bloc.dart';

class CartItem {
  final FoodItem foodItem;
  final int quantity;

  CartItem({required this.foodItem, required this.quantity});

  CartItem copyWith({
    FoodItem? foodItem,
    int? quantity,
  }) {
    return CartItem(
      foodItem: foodItem ?? this.foodItem,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartState extends Equatable {
  final List<CartItem> cartItemList;

  const CartState({required this.cartItemList});

  @override
  List<Object?> get props => [cartItemList];

  CartState copyWith({
    List<CartItem>? cartItemList,
  }) {
    return CartState(
      cartItemList: cartItemList ??
          this.cartItemList,
    );
  }
}