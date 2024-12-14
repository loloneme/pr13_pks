import 'dart:ffi';
import 'package:flutter/material.dart';

class Volume {
  final int volumeID;
  final String volume;
  final int price;

  Volume({
    required this.volumeID,
    required this.volume,
    required this.price,
  });

  factory Volume.fromJson(Map<String, dynamic> json) {
    return Volume(
      volumeID: json['volume_id'] as int,
      volume: json['volume'] as String,
      price: json['price'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'volume_id': volumeID,
      'volume': volume,
      'price': price
    };
  }
}