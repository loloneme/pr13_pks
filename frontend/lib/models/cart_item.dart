import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:frontend/models/volume.dart';
import 'drink.dart';

class CartItem {
  final int cartItemID;
  final String userID;
  final Volume volume;
  final String temperature;
  final int quantity;
  final Drink drink;


  CartItem({
    required this.cartItemID,
    required this.userID,
    required this.volume,
    required this.temperature,
    required this.quantity,
    required this.drink
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartItemID: json['cart_item_id'] as int,
      userID: json['user_id'] as String,
      volume: Volume.fromJson(json['volume']),
      temperature: json['temperature'] as String,
      quantity: json['quantity'] as int,
      drink: Drink.fromJson(json['drink']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_item_id': cartItemID,
      'user_id': userID,
      'volume': volume.toJson(),
      'temperature': temperature,
      'quantity': quantity,
      'drink': drink.toJson(),
    };
  }
}
