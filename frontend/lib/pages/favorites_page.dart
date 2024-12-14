import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/pages/info_page.dart';
import '../data.dart';
import '../components/drink_item.dart';
import '../models/drink.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({
    super.key,
    required this.drinks,
    required this.addNewDrink,
    required this.toggleFavorite,
  });

  final List<Drink> drinks;
  final Function addNewDrink;
  final Function toggleFavorite;

  void _navigateToInfoPage(BuildContext context, int index) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                InfoPage(
                  drinkID: drinks[index].id,
                  isDeletable: false,
                )
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text("Избранное",
                style: GoogleFonts.sourceSerif4(
                    textStyle: const TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(255, 238, 205, 1.0),
                    )))),
        backgroundColor: const Color.fromRGBO(71, 58, 42, 1.0),
      ),
        backgroundColor: const Color.fromRGBO(71, 58, 42, 1.0),
        body: Container(
        child: drinks.where((d) => d.isFavorite == true).toList().isNotEmpty
            ? GridView.count(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 15,
          children: List.generate(drinks.where((d) => d.isFavorite == true).toList().length, (index) {
            final favoriteDrink = drinks.where((drink) => drink.isFavorite ?? false).elementAt(index);

            return GestureDetector(
              onTap: () => _navigateToInfoPage(context, drinks.indexOf(favoriteDrink)),
              child: DrinkItem(drink: favoriteDrink, onFavoriteToggle: () => toggleFavorite(drinks.indexOf(favoriteDrink)),),
            );
          }),
        )
            : Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              textAlign: TextAlign.center,
              'Вы еще ничего не добавили в Избранное',
              style: GoogleFonts.sourceSerif4(
                  textStyle: const TextStyle(
                    fontSize: 24,
                    color: Color.fromRGBO(255, 238, 205, 1.0),
                  )),
            ),
          ),
        ),
      )
    );
  }
}
