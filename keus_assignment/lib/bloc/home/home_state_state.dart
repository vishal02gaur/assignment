part of 'home_state_bloc.dart';

class Filter extends Equatable {
  final String name;
  final bool isSelected;

  const Filter({required this.name, this.isSelected = false});

  Filter copyWith({
    String? name,
    bool? isSelected,
  }) {
    return Filter(
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [name];
}

sealed class HomeUiCard extends Equatable {}

class FoodItemUiCard extends HomeUiCard {
  final FoodItem foodItem;

  FoodItemUiCard({required this.foodItem});

  @override
  List<Object?> get props => [foodItem];
}

class RecommendedCardData extends Equatable {
  final FoodItem item;
  final Color color;

  const RecommendedCardData({required this.item, required this.color});

  @override
  List<Object?> get props => [item.id];
}

class RecommendedUiCard extends HomeUiCard {
  final List<RecommendedCardData> foodList;

  RecommendedUiCard({required this.foodList});

  @override
  List<Object?> get props => [foodList];
}

class EmptyFooter extends HomeUiCard {
  @override
  List<Object?> get props => [];
}

class FilterCard extends HomeUiCard {
  final List<Filter> filters;

  FilterCard({required this.filters});

  @override
  List<Object?> get props => [filters];
}

class HomeStateState extends Equatable {
  final List<HomeUiCard> cards;

  const HomeStateState({required this.cards});

  HomeStateState copyWith({
    List<HomeUiCard>? cards,
  }) {
    return HomeStateState(
      cards: cards ?? this.cards,
    );
  }

  @override
  List<Object?> get props => [cards];
}
