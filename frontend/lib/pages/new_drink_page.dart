import 'package:flutter/material.dart';
import 'package:frontend/components/drink_form.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/drink.dart';

class NewDrinkPage extends StatefulWidget {
  const NewDrinkPage({super.key});

  @override
  State<NewDrinkPage> createState() => _NewDrinkPageState();
}

class _NewDrinkPageState extends State<NewDrinkPage> {
  void _onSubmit(Drink drink) {
      Navigator.pop(context, drink);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text("Новый напиток",
                style: GoogleFonts.sourceSerif4(
                    textStyle: const TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(44, 32, 17, 1.0),
                )))),
        backgroundColor: const Color.fromRGBO(159, 133, 102, 1.0),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
        constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
    ),
    child: DrinkForm(onSubmit: _onSubmit),))
    );
  }
}
