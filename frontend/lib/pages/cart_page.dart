import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/components/cart_item_card.dart';
import '../api_service.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    required this.userID,
    super.key});

  @override
  State<CartPage> createState() => _CartPageState();

  final String userID;
}

class _CartPageState extends State<CartPage> {
  late Future<List<CartItem>> _cartFuture;

  @override
  void initState(){
    super.initState();
    _cartFuture = ApiService().getCart(widget.userID);
  }

  void _updateCart(CartItem cartItem) async{
    try {
      if (cartItem.quantity <= 0) {
        _deleteFromCart(cartItem.cartItemID);
        return;
      }
      await ApiService().updateCart(cartItem, widget.userID);
      setState(() {
        _cartFuture = ApiService().getCart(widget.userID);
      });
    } catch (e) {
      print('Ошибка: $e');
    }
  }

  void _deleteFromCart(int cartItemID) async{
    try {
     await ApiService().deleteFromCart(cartItemID, widget.userID);
      setState(() {
        _cartFuture = ApiService().getCart(widget.userID);
      });
    } catch (e) {
      print('Ошибка: $e');
    }
  }

  void _createOrder(Order order) async{
    try{
      await ApiService().createOrder(order);
      setState(() {
        _cartFuture = ApiService().getCart(widget.userID);
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
          backgroundColor: const Color.fromRGBO(44, 32, 17, 1.0),
          content: Text('Заказ успешно оформлен!',
              style: GoogleFonts.sourceSerif4(
                  textStyle: const TextStyle(
                      fontSize: 18.0,
                      color: Color.fromRGBO(255, 238, 205, 1.0)))
          )));

      return;
    } catch (e){
      print('Ошибка: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text("Корзина",
                  style: GoogleFonts.sourceSerif4(
                      textStyle: const TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(255, 238, 205, 1.0),
                  )))),
          backgroundColor: const Color.fromRGBO(71, 58, 42, 1.0),
        ),
        backgroundColor: const Color.fromRGBO(71, 58, 42, 1.0),
        body: FutureBuilder<List<CartItem>>(
              future: _cartFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Ошибка: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('Невозможно получить корзину'));
                } else {
                final cart = snapshot.data!;

                int totalCost = cart.fold<int>(0, (sum, item) => sum + (item.quantity * item.volume.price));

                return Container(
                  height: MediaQuery.of(context).size.height,
                  color: const Color.fromRGBO(71, 58, 42, 1.0),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Expanded(
                          child:
                          ListView.builder(
                              itemCount: cart.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CartItemCard(
                                    item: cart[index],
                                    onDelete: () => _deleteFromCart(cart[index].cartItemID),
                                    onChange: _updateCart);
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                          child: Container(
                            width: double.infinity,
                            height: 3,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 238, 205, 1.0),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "Итого:",
                                style: GoogleFonts.sourceSerif4(
                                    textStyle: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(255, 238, 205, 1.0),
                                    ))),
                            Text(
                                "$totalCost₽",
                                style: GoogleFonts.sourceSerif4(
                                    textStyle: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromRGBO(255, 238, 205, 1.0),
                                    )))
                          ]
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                          child: ElevatedButton(
                              onPressed: (){
                                if (cart.isNotEmpty){
                                  _createOrder(Order(orderID: 0, date: "", totalCost: totalCost,
                                      items: cart.map((cartItem) {
                                    return OrderItem(
                                      orderItemID: 0,
                                      volume: cartItem.volume,
                                      temperature: cartItem.temperature,
                                      quantity: cartItem.quantity,
                                      drinkName: cartItem.drink.name,
                                    );
                                  }).toList(), userID: widget.userID));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromRGBO(44, 32, 17, 1.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 4,
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 50),
                                ),
                            child: Text(
                                "Оформить заказ",
                                style: GoogleFonts.sourceSerif4(
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      color: Color.fromRGBO(255, 238, 205, 1.0),
                                    )
                                )
                            )
                          )
                        )
                      ],
                    ),
                  )
                );
              }
            }
      )
    );
  }
}
