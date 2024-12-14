import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/drink.dart';
import '../components/bulleted_list.dart';

class DrinkInfo extends StatelessWidget {
  const DrinkInfo({super.key, required this.drink});

  final Drink drink;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(
              color: const Color.fromRGBO(44, 32, 17, 1.0),
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            child: Image.network(
              drink.image ?? "",
              width: 260,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 10, 15),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(children: [
                  drink.cold ?? false
                      ? Image.network(
                          "https://github.com/loloneme/images/blob/main/cold.png?raw=true",
                          width: 35,
                          height: 35,
                          fit: BoxFit.cover,
                        )
                      : Container(),
                  drink.hot ?? false
                      ? Image.network(
                          "https://github.com/loloneme/images/blob/main/hot.png?raw=true",
                          width: 35,
                          height: 35,
                          fit: BoxFit.cover,
                        )
                      : Container()
                ]),

                // Container(
                //   constraints: const BoxConstraints(maxWidth: 200, maxHeight: 60),
                //   child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: drink.volumes!.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${entry.volume}мл",
                            style: GoogleFonts.sourceSerif4(
                                textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color: Color.fromRGBO(255, 238, 205, 1.0),
                            )),
                          ),
                          Text(
                            '${entry.price}₽',
                            style: GoogleFonts.sourceSerif4(
                                textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(255, 238, 205, 1.0),
                            )),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Text("Состав:",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.sourceSerif4(
                        textStyle: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(44, 32, 17, 1.0),
                    ))),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: BulletedList(items: drink.compound!.split(";")),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                child: Container(
                  width: 220,
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(44, 32, 17, 1.0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(drink.description ?? '',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sourceSerif4(
                      textStyle: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(44, 32, 17, 1.0),
                  )))
            ],
          ),
        ),
      ],
    );
  }
}
