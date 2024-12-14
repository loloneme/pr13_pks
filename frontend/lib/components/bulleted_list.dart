import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BulletedList extends StatelessWidget {
  const BulletedList({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('•  $item',
                style: GoogleFonts.sourceSerif4(
                  textStyle: const TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(44, 32, 17, 1.0)),
                ),
            )],
        );
      }).toList(),
    );  }
}
