import 'package:flutter/foundation.dart';

@immutable
class Product {
  const Product({
    required this.id,
    required this.ownerUsername,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.categoryLabel,
    required this.thumbnail,
    required this.isFeatured,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String ownerUsername;
  final String name;
  final double price;
  final String description;
  final String category;
  final String categoryLabel;
  final String thumbnail;
  final bool isFeatured;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      ownerUsername: json['owner_username'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      categoryLabel:
          (json['category_label'] as String?) ?? json['category'] as String,
      thumbnail: json['thumbnail'] as String,
      isFeatured: json['is_featured'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_username': ownerUsername,
      'name': name,
      'price': price,
      'description': description,
      'category': category,
      'category_label': categoryLabel,
      'thumbnail': thumbnail,
      'is_featured': isFeatured,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get formattedPrice {
    return price == price.truncateToDouble()
        ? 'Rp${price.toStringAsFixed(0)}'
        : 'Rp${price.toStringAsFixed(2)}';
  }
}
