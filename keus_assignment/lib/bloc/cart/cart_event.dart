part of 'cart_bloc.dart';

sealed class CartEvent {}

class AddInCartEvent extends CartEvent {
  final FoodItem foodItem;
  final int quantity;

  AddInCartEvent({required this.foodItem, required this.quantity});
}

class DeleteFromCart extends CartEvent {
  final String foodItemId;

  DeleteFromCart({required this.foodItemId});
}

class UpdateQuantityInCart extends CartEvent {
  final String foodItemId;
  final int quantity;

  UpdateQuantityInCart({required this.foodItemId, required this.quantity});
}

class ClearCartEvent extends CartEvent {}
