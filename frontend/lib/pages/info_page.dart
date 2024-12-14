import 'package:flutter/material.dart';
import 'package:frontend/components/drink_form.dart';
import 'package:frontend/components/incrementor.dart';
import 'package:frontend/models/cart_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../api_service.dart';
import '../models/drink.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/drink_info.dart';
import '../models/volume.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({
    super.key,
    required this.drinkID,
    required this.isDeletable,
  });

  final int drinkID;
  final bool isDeletable;

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  late bool isEditMode = false;
  late Future<Drink> _drinkFuture;
  final userID = Supabase.instance.client.auth.currentSession?.user.id;


@override
  void initState(){
    super.initState();
    _drinkFuture = ApiService().getDrinkByID(widget.drinkID);
  }

  Future<void> _addToCart(CartItem cartItem)async {
    try {
      await ApiService().addToCart(cartItem, userID!);
    } catch (e) {
      print('Ошибка: $e');
    }
  }

  Future<void> _onSubmit(Drink drink)async {
    try {
      isEditMode = false;

      Drink drinks = await _drinkFuture;

      await ApiService().updateDrink(drink);

      setState(() {
        _drinkFuture = ApiService().getDrinkByID(widget.drinkID);
      });
    } catch (e) {
      print('Ошибка: $e');
    }
  }

  void _showConfirmDelete() async {
    final drink = await _drinkFuture;

    if (!mounted) return;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromRGBO(44, 32, 17, 1.0),
            title: Text("Удалить напиток?",
                style: GoogleFonts.sourceSerif4(
                    textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(255, 238, 205, 1.0),
                ))),
            content: Text("Отменить это действие будет невозможно",
                style: GoogleFonts.sourceSerif4(
                    textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: Color.fromRGBO(255, 238, 205, 1.0),
                ))),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Отмена",
                      style: GoogleFonts.sourceSerif4(
                          textStyle: const TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(255, 238, 205, 1.0),
                      )))),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text("OK",
                      style: GoogleFonts.sourceSerif4(
                          textStyle: const TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(255, 238, 205, 1.0),
                      ))))
            ],
          );
        }).then((result) {
      if (result == true) {
        Navigator.of(context).pop(true);
      }
    });
  }

  void _showAddToCartModal() async {
    final drink = await _drinkFuture;

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromRGBO(159, 133, 102, 1.0),
      builder: (BuildContext context) {
        List<String> temperatureOptions = [];
        List<Volume> volumeOptions = drink.volumes ?? [];

        if (drink.cold == true) {
          temperatureOptions.add("Холодный");
        }

        if (drink.hot == true) {
          temperatureOptions.add("Горячий");
        }

        Volume selectedVolume = volumeOptions.isNotEmpty ? volumeOptions[0] : Volume(volumeID: 0, volume: "", price: 0);
        String temperature = "hot";

        if (temperatureOptions.length == 1 && temperatureOptions.contains("Холодный")){
          temperature = "cold";
        }

        int quantity = 1;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Выберите опции для напитка",
                        style: GoogleFonts.sourceSerif4(
                            textStyle: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(44, 32, 17, 1.0),
                        ))),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        temperatureOptions.length > 1 ? DropdownButton<String>(
                          value: temperatureOptions.contains("Холодный") ? "Холодный" : "Горячий",
                          items: temperatureOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: GoogleFonts.sourceSerif4(
                                      textStyle: const TextStyle(
                                    fontSize: 18.0,
                                    color: Color.fromRGBO(44, 32, 17, 1.0),
                                  ))),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setModalState(() {
                              if (newValue == "Холодный"){
                                temperature = "cold";
                              } else {
                                temperature = "hot";
                              }
                            });
                          },
                        ) : Text(temperatureOptions.contains("Холодный") ? "Холодный" : "Горячий",
                            style: GoogleFonts.sourceSerif4(
                                textStyle: const TextStyle(
                                  fontSize: 18.0,
                                  color: Color.fromRGBO(44, 32, 17, 1.0),
                                ))),
                         DropdownButton<Volume>(
                            value: selectedVolume,
                            items: volumeOptions.map((Volume vol) {
                              return DropdownMenuItem<Volume>(
                                value: vol,
                                child: Text("${vol.volume} мл",
                                    style: GoogleFonts.sourceSerif4(
                                        textStyle: const TextStyle(
                                          fontSize: 18.0,
                                          color: Color.fromRGBO(44, 32, 17, 1.0),
                                        ))),
                              );
                            }).toList(),
                            onChanged: (Volume? newVol) {
                              setModalState(() {
                                selectedVolume = newVol!;
                              });
                          },
                        ),
                       Incrementor(
                           onDecrement: (){
                             if (quantity > 1){
                               setModalState((){
                                 quantity -= 1;
                               });
                             }
                           },
                           onIncrement: (){
                             setModalState((){
                               quantity += 1;
                             });
                           },
                           count: quantity)
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text(
                        "Стоимость: ${selectedVolume.price * quantity}₽",
                        style: GoogleFonts.sourceSerif4(
                            textStyle: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(44, 32, 17, 1.0),
                        ))),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(44, 32, 17, 1.0),
                      ),
                      onPressed: () {
                        CartItem newItem = CartItem(
                          cartItemID: 0,
                          userID: userID!,
                          volume: selectedVolume,
                          temperature: temperature,
                          quantity: quantity,
                          drink: drink,
                      );

                        _addToCart(newItem);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                          backgroundColor: const Color.fromRGBO(44, 32, 17, 1.0),
                            content: Text('${drink.name} добавлен в корзину!',
                                style: GoogleFonts.sourceSerif4(
                                    textStyle: const TextStyle(
                                        fontSize: 18.0,
                                        color: Color.fromRGBO(255, 238, 205, 1.0)))
                            )));
                        Navigator.pop(context);
                      },
                      child: Text('Добавить',
                          style: GoogleFonts.sourceSerif4(
                              textStyle: const TextStyle(
                                  fontSize: 18.0,
                                  color: Color.fromRGBO(255, 238, 205, 1.0)))),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(159, 133, 102, 1.0),
        appBar: AppBar(
          title: Center(
            child: FutureBuilder<Drink>(
              future: _drinkFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Ошибка');
                } else if (!snapshot.hasData) {
                  return const Text('Напиток не найден');
                } else {
                  final drink = snapshot.data!;
                  return Text(
                    isEditMode ? "Редактирование" : drink.name,
                    style: GoogleFonts.sourceSerif4(
                      textStyle: const TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(44, 32, 17, 1.0),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          backgroundColor: const Color.fromRGBO(159, 133, 102, 1.0),
        ),
        body: FutureBuilder<Drink>(
          future: _drinkFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Ошибка: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('Невозможно получить напиток'));
            } else {
      final drink = snapshot.data!;

      return SingleChildScrollView(
            child: isEditMode ?
            DrinkForm(onSubmit: _onSubmit, drink: drink,)
                :
            Container(
              width: double.infinity,
              color: const Color.fromRGBO(159, 133, 102, 1.0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(35, 15, 35, 15),
                child: Column(
                  children: [
                    DrinkInfo(drink: drink),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              widget.isDeletable
                                  ? IconButton(
                                      icon: const Icon(Icons.delete_rounded),
                                      color: const Color.fromRGBO(44, 32, 17, 1.0),
                                      iconSize: 30,
                                      onPressed: _showConfirmDelete)
                                  : const SizedBox.shrink(),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromRGBO(44, 32, 17, 1.0),
                                  ),
                                  onPressed: _showAddToCartModal,
                                  child: Text('В корзину',
                                      style: GoogleFonts.sourceSerif4(
                                          textStyle: const TextStyle(
                                              fontSize: 20.0,
                                              color: Color.fromRGBO(255, 238, 205, 1.0)))),
                                ),
                              const SizedBox(width: 10),
                              widget.isDeletable ?
                              IconButton(
                                  icon: const Icon(Icons.mode_edit_rounded),
                                  color: const Color.fromRGBO(44, 32, 17, 1.0),
                                  iconSize: 30,
                                  onPressed: () => {
                                    setState(() {
                                      isEditMode = !isEditMode;
                                    }
                                    )
                              }
                              )
                                  : const SizedBox.shrink()
                            ],
                          ),
                      ),
                    )
                  ],
                ),
              ),
            ),
        );}})
    );
  }
}
