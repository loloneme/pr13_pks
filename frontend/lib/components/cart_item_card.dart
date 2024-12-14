import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/components/incrementor.dart';
import 'package:frontend/models/cart_item.dart';


class CartItemCard extends StatelessWidget {
  final CartItem item;
  final Function onChange;
  final Function onDelete;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onChange});

  void _incrementQuantity() {
    final updatedItem = CartItem(
      cartItemID: item.cartItemID,
      userID: item.userID,
      volume: item.volume,
      temperature: item.temperature,
      quantity: item.quantity + 1,
      drink: item.drink,
    );
    onChange(updatedItem);
  }

  void _decrementQuantity() {
      final updatedItem = CartItem(
        cartItemID: item.cartItemID,
        userID: item.userID,
        volume: item.volume,
        temperature: item.temperature,
        quantity: item.quantity - 1,
        drink: item.drink,
      );
      onChange(updatedItem);
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Dismissible(
        key: ValueKey(item),
        background: Container(
          color: const Color.fromRGBO(202, 63, 63, 1.0),
          alignment: AlignmentDirectional.centerEnd,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(
            Icons.delete,
            color: Color.fromRGBO(255, 238, 205, 1.0),
          ),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          onDelete();
        },
        child: Row(
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
                child: Image.network(
                  item.drink.image,
                  width: 120,
                  height: 96,
                  fit: BoxFit.cover,
                )),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      item.temperature == 'cold'
                          ? Image.network(
                        "https://github.com/loloneme/images/blob/main/snow-flake.png?raw=true",
                        width: 20,
                        height: 20,
                        fit: BoxFit.cover,
                      )
                          : Image.network(
                        "https://github.com/loloneme/images/blob/main/air.png?raw=true",
                        width: 20,
                        height: 20,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          "${item.drink.name} ${item.volume.volume}мл",
                          textAlign: TextAlign.left,
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          style: GoogleFonts.sourceSerif4(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(255, 238, 205, 1.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                      textAlign: TextAlign.left,
                      "${item.quantity * item.volume.price}₽",
                      style: GoogleFonts.sourceSerif4(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(255, 238, 205, 1.0),
                          ))),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 10),
                      Incrementor(
                            onDecrement: _decrementQuantity,
                            onIncrement: _incrementQuantity,
                            count: item.quantity
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
