import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:frontend/models/volume.dart';

class Drink {
  final int id;
  final String image;
  final String name;
  final String? description;
  final String? compound;
  final bool? cold;
  final bool? hot;
  final List<Volume>? volumes;
  bool? isFavorite;

  Drink({
    required this.id,
    required this.image,
    required this.name,
    this.description,
    this.compound,
    this.cold,
    this.hot,
    this.volumes,
    this.isFavorite,
  });

  factory Drink.fromJson(Map<String, dynamic> json) {
    var volumesFromJson = json['volumes'] as List? ?? [];
    List<Volume> volumeList = volumesFromJson.map((v) => Volume.fromJson(v)).toList();

    return Drink(
      id: json['drink_id'],
      image: json['image'],
      name: json['name'],
      description: json['description'],
      compound: json['compound'],
      cold: json['is_cold'],
      hot: json['is_hot'],
      volumes: volumeList,
      isFavorite: json['is_favorite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'drink_id': id,
      'name': name,
      'image': image,
      'description': description,
      'compound': compound,
      'is_cold': cold,
      'is_hot': hot,
    };
  }
}
