import 'package:frontend/models/cart_item.dart';
import 'package:frontend/models/volume.dart';

class Order{
  final int orderID;
  final String userID;
  final List<OrderItem> items;
  final String date;
  final int totalCost;

  Order({
    required this.orderID,
    required this.userID,
    required this.date,
    required this.totalCost,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderID: json['order_id'] as int,
      userID: json['user_id'] as String,
      date: json['date'] as String,
      totalCost: json['total_cost'] as int,
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderID,
      'date': date,
      'total_cost': totalCost,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItem{
  final int orderItemID;
  final Volume volume;
  final String temperature;
  final int quantity;
  final String drinkName;

  OrderItem({
    required this.orderItemID,
    required this.volume,
    required this.temperature,
    required this.quantity,
    required this.drinkName,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      orderItemID: json['order_item_id'] as int,
      volume: Volume.fromJson(json['volume']),
      temperature: json['temperature'] as String,
      quantity: json['quantity'] as int,
      drinkName: json['drink_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_item_id': orderItemID,
      'volume': volume.toJson(),
      'temperature': temperature,
      'quantity': quantity,
      'drink_name': drinkName,
    };
  }}