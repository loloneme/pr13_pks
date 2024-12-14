import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'filter_dialog.dart';


class SearchAndFilter extends StatefulWidget {
  final Function(String searchQuery) onSearchChange;
  final Function(Map<String, dynamic> filters) onFilterChange;


  const SearchAndFilter({required this.onSearchChange, required this.onFilterChange, super.key});

  @override
  State<SearchAndFilter> createState() => _SearchAndFilterState();
}

class _SearchAndFilterState extends State<SearchAndFilter> {
  String searchQuery = '';
  Map<String, dynamic> filters = {
    'isCold': false,
    'isHot': false,
    'priceSortOrder': 'По умолчанию',
    'nameSortOrder': 'По умолчанию'
  };


  void _openFilterDialog() async {
    final updatedFilters = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => FilterDialog(currentFilters: filters),
    );

    if (updatedFilters != null) {
      setState(() {
        filters = updatedFilters;
      });
      widget.onFilterChange(filters);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  style: GoogleFonts.sourceSerif4(
                  textStyle: const TextStyle(
                  fontSize: 18.0,
                  color: Color.fromRGBO(255, 238, 205, 1.0)
                  )),
                  decoration: InputDecoration(
                  labelText: 'Поиск',
                  labelStyle: GoogleFonts.sourceSerif4(
                    textStyle: const TextStyle(
                    fontSize: 18.0,
                    color: Color.fromRGBO(159, 133, 102, 1.0),
                  )),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color.fromRGBO(159, 133, 102, 1.0),
                  ),
                  isDense: true,
                  // fillColor: const Color.fromRGBO(159, 133, 102, 1.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Color.fromRGBO(255, 238, 205, 1.0), width: 1.0)
                  ),
                  focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color.fromRGBO(255, 238, 205, 1.0), width: 1.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),),
                  // contentPadding: const EdgeInsets.symmetric(
                  //   vertical: 5.0,
                  //   horizontal: 5.0,
                  // )),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                    widget.onSearchChange(searchQuery);
                  },
                ),
              ),
              IconButton(
                icon: const Icon(
                    Icons.filter_list_rounded,
                    color: Color.fromRGBO(255, 238, 205, 1.0),
                ),
                onPressed: _openFilterDialog,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
