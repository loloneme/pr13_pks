import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Incrementor extends StatelessWidget {
  final Function onDecrement;
  final Function onIncrement;
  final int count;

  const Incrementor(
      {super.key,
      required this.onDecrement,
      required this.onIncrement,
      required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.0,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(44, 32, 17, 1.0),
        borderRadius: BorderRadius.circular(5.0),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => onDecrement(),
            icon: const Icon(
              Icons.remove,
              size: 20.0,
              color: Color.fromRGBO(255, 238, 205, 1.0),
            ),
          ),
          Text(
            "$count",
            style: GoogleFonts.sourceSerif4(
                textStyle: const TextStyle(
              fontSize: 18.0,
              color: Color.fromRGBO(255, 238, 205, 1.0),
            )),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => onIncrement(),
            icon: const Icon(
              Icons.add,
              size: 20.0,
              color: Color.fromRGBO(255, 238, 205, 1.0),
            ),
          ),
        ],
      ),
    );
  }
}
