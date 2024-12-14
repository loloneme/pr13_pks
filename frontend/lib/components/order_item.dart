import 'package:frontend/models/order.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import '../models/cart_item.dart';

class OrderItemWidget extends StatelessWidget {
  final OrderItem orderItem;

  const OrderItemWidget({super.key, required this.orderItem});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              orderItem.temperature == "cold"
                  ? Image.network(
                "https://github.com/loloneme/images/blob/main/cold.png?raw=true",
                width: 15,
                height: 15,
                fit: BoxFit.cover,
              ) : Image.network(
                "https://github.com/loloneme/images/blob/main/hot.png?raw=true",
                width: 15,
                height: 15,
                fit: BoxFit.cover,
              ),
              Text("${orderItem.drinkName} ${orderItem.volume.volume}мл x${orderItem.quantity}",
                  style: GoogleFonts.sourceSerif4(
                      textStyle: const TextStyle(
                        fontSize: 14.0,
                        color: Color.fromRGBO(44, 32, 17, 1.0),
                      ))
              ),
            ],
          ),
          Text("${orderItem.volume.price * orderItem.quantity}₽",
              style: GoogleFonts.sourceSerif4(
                  textStyle: const TextStyle(
                    fontSize: 14.0,
                    color: Color.fromRGBO(44, 32, 17, 1.0),
                  ))
          ),
        ],
    );
  }
}