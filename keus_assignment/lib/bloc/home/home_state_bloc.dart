import 'dart:convert';
import 'dart:isolate';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/food_item.dart';

part 'home_state_event.dart';

part 'home_state_state.dart';

class HomeStateBloc extends Bloc<HomeStateEvent, HomeStateState> {
  var _fakeFoodData = <FoodItem>[];

  HomeStateBloc() : super(const HomeStateState(cards: [])) {
    on<RefreshHomeEvent>((event, emit) async {
      final data = await _loadJsonFromAssets('assets/data/fake_food_data.json');
      _fakeFoodData = data;
      emit(await _localFakeState(_fakeFoodData));
    });

    on<FilterEvent>((event, emit) async {
      final cards = state.cards;
      final updatedStateCards = <HomeUiCard>[];
      final recommendedUiCard =
          cards.whereType<RecommendedUiCard>().firstOrNull;
      final filterCard = cards.whereType<FilterCard>().firstOrNull;
      final footer = cards.whereType<EmptyFooter>().firstOrNull;
      if (filterCard != null) {
        if (recommendedUiCard != null) {
          updatedStateCards.add(recommendedUiCard);
        }
        final updatedFilters = filterCard.filters.map((filter) =>
            filter.copyWith(
                isSelected: filter.name == event.filter.name
                    ? !filter.isSelected
                    : filter.isSelected));
        if (updatedFilters.isNotEmpty) {
          updatedStateCards.add(FilterCard(filters: updatedFilters.toList()));
        }
        final appliedFilters = updatedFilters
            .where((filter) => filter.isSelected)
            .map((filter) => filter.name)
            .toSet();

        if (appliedFilters.isNotEmpty) {
          updatedStateCards.addAll(_fakeFoodData
              .where((foodItem) => appliedFilters.contains(foodItem.category))
              .map((item) => FoodItemUiCard(foodItem: item))
              .toList());
        } else {
          updatedStateCards.addAll(_fakeFoodData
              .map((item) => FoodItemUiCard(foodItem: item))
              .toList());
        }
        if (footer != null) {
          updatedStateCards.add(footer);
        }
        emit(HomeStateState(cards: updatedStateCards));
      }
    });
  }
}

Future<HomeStateState> _localFakeState(List<FoodItem> data) async {
  List<RecommendedCardData> recommendedFoods = [];

// Pick 4 random items without duplicates
  while (recommendedFoods.length < 4) {
    final randomIndex = Random().nextInt(data.length);
    final foodItem = data[randomIndex];
    final Random random = Random();
    final item = RecommendedCardData(
        item: foodItem,
        color: Color.fromARGB(
          255, // Alpha
          random.nextInt(256), // Red
          random.nextInt(256), // Green
          random.nextInt(256), // Blue
        ));
    if (!recommendedFoods.contains(item)) {
      recommendedFoods.add(item);
    }
  }

  final filterCard = FilterCard(
      filters: data
          .map((item) => item.category)
          .toSet()
          .map((category) => Filter(name: category))
          .toList());

  RecommendedUiCard recommendedUiCard =
      RecommendedUiCard(foodList: recommendedFoods);
  final foodItemCards =
      data.map((item) => FoodItemUiCard(foodItem: item)).toList();
  return HomeStateState(
      cards: [recommendedUiCard, filterCard, ...foodItemCards, EmptyFooter()]);
}

Future<List<FoodItem>> _loadJsonFromAssets(String filePath) async {
  String jsonString = await rootBundle.loadString(filePath);
  final result = await Isolate.run(() {
    List<dynamic> list = jsonDecode(jsonString);
    return list
        .map((json) => FoodItem.fromJson(json as Map<String, dynamic>))
        .toList();
  });
  return result;
}
