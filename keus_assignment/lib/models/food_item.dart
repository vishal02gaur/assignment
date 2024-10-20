import 'package:equatable/equatable.dart';
import '../utils.dart';

class FoodItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final String image;
  final int calories;
  final int grams;
  final int proteins;
  final int fats;
  final int carbs;
  final double price;
  final String category;

  const FoodItem(
      {required this.id,
      required this.name,
      required this.description,
      required this.image,
      required this.calories,
      required this.grams,
      required this.proteins,
      required this.fats,
      required this.carbs,
      required this.price,
      required this.category});

  @override
  List<Object?> get props => [id];

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: (json['id'] as int).toString(),
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      calories: json['calories'] as int,
      // Corrected type
      grams: json['grams'] as int,
      proteins: json['proteins'] as int,
      fats: json['fats'] as int,
      carbs: json['carbs'] as int,
      price: (json['price'] as double).roundToTwoDecimal(),
      category: json['category'] as String,
    );
  }
}
