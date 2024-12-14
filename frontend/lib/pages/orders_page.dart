import 'package:flutter/material.dart';
import 'package:frontend/api_service.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/order_card.dart';
import '../models/order.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key, required this.userID});

  final String userID;

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future<List<Order>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = ApiService().getOrdersForUser(widget.userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text("Мои заказы",
                style: GoogleFonts.sourceSerif4(
                    textStyle: const TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(255, 238, 205, 1.0),
                    )))),
        backgroundColor: const Color.fromRGBO(71, 58, 42, 1.0),
      ),
      backgroundColor: const Color.fromRGBO(71, 58, 42, 1.0),
      body: FutureBuilder<List<Order>>(
          future: _ordersFuture,
          builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Ошибка: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('Невозможно получить корзину'));
                } else {
                  final orders = snapshot.data!;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Center(
                        child: ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, index){
                            return OrderCard(order: orders[index]);
                          },
                        ),
                    ),
                  );
            }
          }
      )
    );
  }
}
