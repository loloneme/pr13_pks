import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterDialog extends StatefulWidget {
  final Map<String, dynamic> currentFilters;

  const FilterDialog({required this.currentFilters, super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late bool isCold;
  late bool isHot;
  late String priceSortOrder;
  late String nameSortOrder;

  final List<String> sortOrderOptions = ['По умолчанию', 'По возрастанию', 'По убыванию'];
  final List<String> nameSortOptions = ['По умолчанию', 'По алфавиту (А-Я)', 'По алфавиту (Я-А)'];

  @override
  void initState() {
    super.initState();
    isCold = widget.currentFilters['isCold'];
    isHot = widget.currentFilters['isHot'];
    priceSortOrder = widget.currentFilters['priceSortOrder'] ?? sortOrderOptions[0];
    nameSortOrder = widget.currentFilters['nameSortOrder'] ?? nameSortOptions[0];
  }


  @override
  Widget build (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color.fromRGBO(159, 133, 102, 1.0),
        title: Text('Фильтрация',
            style: GoogleFonts.sourceSerif4(
            textStyle: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(44, 32, 17, 1.0),
            ))),
        content: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: Text('Холодные',
                    style: GoogleFonts.sourceSerif4(
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      color: Color.fromRGBO(44, 32, 17, 1.0),
                    ))),
                activeColor: const Color.fromRGBO(44, 32, 17, 1.0),
                checkColor: const Color.fromRGBO(255, 238, 205, 1.0),
                value: isCold,
                onChanged: (value) {
                  setState(() {
                    isCold = value!;
                  });
                },
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: Text('Горячие',
                    style: GoogleFonts.sourceSerif4(
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                          color: Color.fromRGBO(44, 32, 17, 1.0),
                        ))),
                activeColor: const Color.fromRGBO(44, 32, 17, 1.0),
                checkColor: const Color.fromRGBO(255, 238, 205, 1.0),
                value: isHot,
                onChanged: (value) {
                  setState(() {
                    isHot = value!;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('По цене:',
                      style: GoogleFonts.sourceSerif4(
                          textStyle: const TextStyle(
                            fontSize: 16.0,
                            color: Color.fromRGBO(44, 32, 17, 1.0),
                          ))),
                  const SizedBox(width: 20),
                  DropdownButton<String>(
                    value: priceSortOrder,
                    onChanged: (value) {
                      setState(() {
                        priceSortOrder = value!;
                      });
                    },
                    items: sortOrderOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option,
                          style: GoogleFonts.sourceSerif4(
                            textStyle: const TextStyle(
                              fontSize: 16.0,
                              color: Color.fromRGBO(44, 32, 17, 1.0),
                            ))),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Название:',
                      style: GoogleFonts.sourceSerif4(
                          textStyle: const TextStyle(
                            fontSize: 16.0,
                            color: Color.fromRGBO(44, 32, 17, 1.0),
                          ))),
                  const SizedBox(width: 20),
                  DropdownButton<String>(
                    value: nameSortOrder,
                    onChanged: (value) {
                      setState(() {
                        nameSortOrder = value!;
                      });
                    },
                    items: nameSortOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option,
                            style: GoogleFonts.sourceSerif4(
                                textStyle: const TextStyle(
                                  fontSize: 16.0,
                                  color: Color.fromRGBO(44, 32, 17, 1.0),
                                ))),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        )),
        actions: [
          TextButton(
            child: Text('Отмена',
                style: GoogleFonts.sourceSerif4(
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(44, 32, 17, 1.0),
                    ))),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(44, 32, 17, 1.0),
            ),
            child: Text('Применить',
                style: GoogleFonts.sourceSerif4(
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(159, 133, 102, 1.0),
                    ))),
            onPressed: () {
              Navigator.of(context).pop({
                'isCold': isCold,
                'isHot': isHot,
                'priceSortOrder': priceSortOrder,
                'nameSortOrder': nameSortOrder,
              });
            },
          ),
        ],
      );
  }
}
