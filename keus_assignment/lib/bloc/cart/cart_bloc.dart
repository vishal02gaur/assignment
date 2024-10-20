import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/food_item.dart';

part 'cart_event.dart';

part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState(cartItemList: [])) {
    on<AddInCartEvent>((event, emit) {
      final alreadyAddedItem = state.cartItemList
          .firstWhereOrNull((item) => item.foodItem.id == event.foodItem.id);
      if (alreadyAddedItem != null) {
        emit(CartState(
            cartItemList: state.cartItemList
                .map((item) => item.foodItem.id == alreadyAddedItem.foodItem.id
                    ? CartItem(
                        foodItem: item.foodItem,
                        quantity: item.quantity + event.quantity)
                    : item)
                .toList()));
      } else {
        emit(CartState(cartItemList: [
          ...state.cartItemList,
          CartItem(foodItem: event.foodItem, quantity: event.quantity)
        ]));
      }
    });
    on<DeleteFromCart>((event, emit) {
      emit(state.copyWith(
          cartItemList: state.cartItemList
              .where((item) => item.foodItem.id != event.foodItemId)
              .toList()));
    });
    on<UpdateQuantityInCart>((event, emit) {
      late CartState updatedState;
      if (event.quantity <= 0) {
        updatedState = state.copyWith(
            cartItemList: state.cartItemList
                .where((item) => item.foodItem.id != event.foodItemId)
                .toList());
      } else {
        updatedState = state.copyWith(
            cartItemList: state.cartItemList
                .map((item) => item.foodItem.id == event.foodItemId
                    ? CartItem(
                        foodItem: item.foodItem, quantity: event.quantity)
                    : item)
                .toList());
      }
      emit(updatedState);
    });

    on<ClearCartEvent>((event, emit) {
      emit(const CartState(cartItemList: []));
    });
  }
}
