import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import '../models/order.dart';
import 'order_item.dart';


class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(159, 133, 102, 1.0),
      margin: const EdgeInsets.only(bottom: 15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Заказ №${order.orderID}",
                style: GoogleFonts.sourceSerif4(
                    textStyle: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(44, 32, 17, 1.0),
                    ))
            ),
            const SizedBox(height: 15.0),
            ...order.items.map((orderItem) => OrderItemWidget(orderItem: orderItem)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Center(
                child: Container(
                  width: 160,
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(44, 32, 17, 1.0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order.date.split('T')[0],
                    style: GoogleFonts.sourceSerif4(
                        textStyle: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(44, 32, 17, 1.0),
                        ))
                ),
                Text("ИТОГО: ${order.totalCost}₽",
                    style: GoogleFonts.sourceSerif4(
                        textStyle: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(44, 32, 17, 1.0),
                        ))
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
