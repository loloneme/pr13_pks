import 'package:flutter/material.dart';
import 'package:frontend/components/search_and_filter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/pages/info_page.dart';
import '../components/drink_item.dart';
import '../models/drink.dart';
import '../pages/new_drink_page.dart';

class DrinksPage extends StatefulWidget {
  final List<Drink> drinks;
  final Function addNewDrink;
  final Function toggleFavorite;
  final Function removeDrink;

  const DrinksPage({
  required this.drinks,
  required this.addNewDrink,
  required this.toggleFavorite,
  required this.removeDrink,  super.key});

  @override
  State<DrinksPage> createState() => _DrinksPageState();
}

class _DrinksPageState extends State<DrinksPage>{
  List<Drink> originalDrinks = [];

  List<Drink> filteredDrinks = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredDrinks = widget.drinks;
    originalDrinks = widget.drinks;
  }

  void _handleSearchChange(String searchQuery) {
    setState(() {
      if (searchQuery.isNotEmpty) {
        filteredDrinks = widget.drinks.where((drink) {
          final nameMatches = drink.name.toLowerCase().contains(searchQuery.toLowerCase());
          final descriptionMatches = drink.description?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false;
          return nameMatches || descriptionMatches;
        }).toList();
      } else {
        filteredDrinks = originalDrinks;
      }
    });
  }


 void _handleFilterChange(Map<String, dynamic> filters) {
    print(originalDrinks[1].cold);
    print(originalDrinks[1].hot);
  setState(() {

    if (filters['priceSortOrder'] == 'По возрастанию') {
      filteredDrinks.sort((a, b) {
        final minPriceA = a.volumes?.map((v) => v.price).reduce((value, element) => value < element ? value : element) ?? 0;
        final minPriceB = b.volumes?.map((v) => v.price).reduce((value, element) => value < element ? value : element) ?? 0;
        return minPriceA.compareTo(minPriceB);
      });
    } else if (filters['priceSortOrder'] == 'По убыванию') {
      filteredDrinks.sort((a, b) {
        final maxPriceA = a.volumes?.map((v) => v.price).reduce((value, element) => value > element ? value : element) ?? 0;
        final maxPriceB = b.volumes?.map((v) => v.price).reduce((value, element) => value > element ? value : element) ?? 0;
        return maxPriceB.compareTo(maxPriceA);
      });
    } else if (filters['priceSortOrder'] == 'По умолчанию') {
      filteredDrinks = originalDrinks;
    }

    if (filters['nameSortOrder'] == 'По алфавиту (А-Я)') {
      filteredDrinks.sort((a, b) => a.name.compareTo(b.name));
    } else if (filters['nameSortOrder'] == 'По алфавиту (Я-А)') {
      filteredDrinks.sort((a, b) => b.name.compareTo(a.name));
    } else if (filters['nameSortOrder'] == 'По умолчанию') {
      filteredDrinks = originalDrinks;
    }

    filteredDrinks = filteredDrinks.where((drink) {

      if (!filters['isCold'] && !filters['isHot']) {
        return true;
      }

      if (filters['isCold'] && filters['isHot']){
        if (drink.cold != null && drink.cold == true && drink.hot != null && drink.hot == true){
          return true;
        }
        return false;
      }

      if (filters['isCold']){
        if (drink.cold != null && drink.cold == true){
          return true;
        }
        return false;
      }

      if (filters['isHot']){
        if (drink.hot != null && drink.hot == true){
          return true;
        }
        return false;
      }
      return false;
    }).toList();


  });
}


  void _navigateToNewDrinkPage(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const NewDrinkPage()));

    if (result != null) {
      widget.addNewDrink(result);
    }
  }

  void _navigateToInfoPage(BuildContext context, int index) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InfoPage(
              drinkID: filteredDrinks[index].id,
              isDeletable: true,
            )));

    if (result == true) {
      widget.removeDrink(index);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(71, 58, 42, 1.0),
      appBar: AppBar(
        title: Center(
            child: Text("Напитки",
                style: GoogleFonts.sourceSerif4(
                    textStyle: const TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(255, 238, 205, 1.0),
                    )))),
        backgroundColor: const Color.fromRGBO(71, 58, 42, 1.0),
      ),
      body: Column(
          children: [
            SearchAndFilter(
              onSearchChange: _handleSearchChange,
              onFilterChange: _handleFilterChange,
            ),
            Expanded(
              child: filteredDrinks.isNotEmpty
                  ? GridView.count(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 15,
                      children: List.generate(filteredDrinks.length, (index) {
                        return GestureDetector(
                          onTap: () => _navigateToInfoPage(context, index),
                          child: DrinkItem(
                            drink: filteredDrinks[index],
                            onFavoriteToggle: () => widget.toggleFavorite(index),
                          ),
                        );
                      }),
                    )
                  : Center(
                      child: Text(
                        'Пока что здесь пусто...',
                        style: GoogleFonts.sourceSerif4(
                          textStyle: const TextStyle(
                            fontSize: 24,
                            color: Color.fromRGBO(255, 238, 205, 1.0),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToNewDrinkPage(context),
        backgroundColor: const Color.fromRGBO(44, 32, 17, 1.0),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Color.fromRGBO(233, 183, 123, 1)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
