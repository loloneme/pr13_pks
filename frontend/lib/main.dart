import 'package:flutter/material.dart';
import 'package:frontend/api_service.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/pages/cart_page.dart';
import 'package:frontend/pages/drinks_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth/auth_service.dart';
import 'pages/profile_page.dart';
import 'pages/favorites_page.dart';
import '../models/drink.dart';

void main() async {
  await Supabase.initialize(
    url: "https://zteccgruidzkuehafdfr.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp0ZWNjZ3J1aWR6a3VlaGFmZGZyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE5NTUzMTksImV4cCI6MjA0NzUzMTMxOX0.l32Ojo_N9R2nZ457NRy9UkdmtolhK3oNe82OgUsCRSs",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ПР13 ПКС',
      theme: ThemeData(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromRGBO(44, 32, 17, 1.0),
          selectedItemColor: Color.fromRGBO(181, 139, 80, 1.0),
          unselectedItemColor: Color.fromRGBO(255, 238, 205, 1.0),
        ),
      ),
      home: const HomePage(),
      routes: {
        '/login': (context) => const LoginPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Drink>> _drinksFuture;
  late String _userID;
  // late Map<String, String> _profile = {
  //   'user_id': "",
  //   'name': "Не указано",
  //   'profile_picture': '',
  //   'email': 'Не указано',
  //   'phone': 'Не указано',
  // };

  @override
  void initState(){
    super.initState();
    final session = Supabase.instance.client.auth.currentSession;
    final bool isLoggedIn = session != null;


    if (isLoggedIn){
      _drinksFuture = ApiService().getDrinks(session.user.id);
      _userID = session.user.id;
      _loadProfile();
    } else {
      _drinksFuture = ApiService().getDrinks();
    }

  }

  int _selectedPage = 0;

  // late Map<String, String> _profile = {
  //   'name': "Мрясова Анастасия",
  //   'profile_picture': 'https://github.com/loloneme/images/blob/main/182a9bb9f5b32babe6efc8c7bf4305be.jpg?raw=true',
  //   'email': AuthService.getCurrentUserEmail(),
  //   'phone': '89991111337'
  // };

  // late List<CartItem> _cart = [
  //   CartItem(9, 'Милкшейк',
  //       'https://github.com/loloneme/images/blob/main/milkshake.png?raw=true',
  //       true,
  //       2,
  //       260,
  //       '350'),
  //   CartItem(3, 'Бамбл',
  //       'https://github.com/loloneme/images/blob/main/bumble.png?raw=true',
  //       true,
  //       2,
  //       300,
  //       '350')
  // ];

  Future<void> _loadProfile() async {
    final email = await AuthService().getCurrentUserEmail();
    final session = Supabase.instance.client.auth.currentSession;

    // setState(() {
    //   _profile = {
    //     'user_id': session?.user.id ?? "",
    //     'name': "Мрясова Анастасия",
    //     'profile_picture': 'https://github.com/loloneme/images/blob/main/182a9bb9f5b32babe6efc8c7bf4305be.jpg?raw=true',
    //     'email': email ?? 'Не указано',
    //     'phone': '89991111337',
    //   };
    // });
  }

  void _addNewDrink(Drink drink) async {
    final session = Supabase.instance.client.auth.currentSession;

    try {
      final id = await ApiService().createDrink(drink);
      setState(() {
        _drinksFuture = ApiService().getDrinks(_userID);
      });
    } catch (e) {
      print('Ошибка: $e');
    }
  }

  // void _updateProfile(newProfile){
  //   setState(() {
  //     _profile = newProfile;
  //   });
  // }

  void _removeDrink(index) async {
    try {
      List<Drink> drinks = await _drinksFuture;

      final id = drinks[index].id;
      await ApiService().deleteDrink(id);

      setState(() {
        _drinksFuture = ApiService().getDrinks(_userID);
      });
    } catch (e) {
      print('Ошибка: $e');
    }
  }

  void _toggleFavorite(index) async {
    try {
      List<Drink> drinks = await _drinksFuture;

      if (_userID != ""){
        await ApiService().toggleFavorite(drinks[index].id, _userID);

        setState(() {
          _drinksFuture = ApiService().getDrinks(_userID);
        });
      }
    } catch (e) {
      print('Ошибка: $e');
    }

  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  // void _removeFromCart(int index){
  //   setState(() {
  //     _cart.removeAt(index);
  //   });
  // }
  //
  // void _decrementAmount(int index){
  //   if (_cart[index].amount <= 1){
  //     _removeFromCart(index);
  //   } else {
  //     setState(() {
  //       _cart[index].amount -= 1;
  //     });
  //   }
  // }
  //
  // void _incrementAmount(int index){
  //   setState(() {
  //     _cart[index].amount += 1;
  //   });
  // }
  //
  // void _addToCart(CartItem item){
  //   int index = _cart.indexWhere((el) => el.name == item.name && el.isCold == item.isCold && el.volume == item.volume);
  //   if (index == -1){
  //     setState(() {
  //       _cart.add(item);
  //     });
  //   } else {
  //     setState((){
  //       _cart[index].amount += item.amount;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(),),
            );
          }

          final session = snapshot.data?.session;
          final bool isLoggedIn = session != null;

          return Scaffold(
            backgroundColor: const Color.fromRGBO(44, 32, 17, 1.0),
            body: FutureBuilder<List<Drink>>(
              future: _drinksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Ошибка: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Нет доступных напитков'));
                } else {
                  final drinks = snapshot.data!;

                  List<Widget> pageOptions = isLoggedIn
                      ? [
                    DrinksPage(
                      drinks: drinks,
                      addNewDrink: _addNewDrink,
                      toggleFavorite: _toggleFavorite,
                      removeDrink: _removeDrink,
                    ),
                    FavoritesPage(
                      drinks: drinks,
                      addNewDrink: _addNewDrink,
                      toggleFavorite: _toggleFavorite,
                    ),
                    CartPage(userID: _userID),
                    ProfilePage(
                        userID: _userID
                    ),
                  ]
                      : [
                    DrinksPage(
                      drinks: drinks,
                      addNewDrink: (){},
                      toggleFavorite: (){},
                      removeDrink: (){},
                    ),
                    const LoginPage(),
                  ];

                  return pageOptions.elementAt(_selectedPage % pageOptions.length);
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: isLoggedIn
                  ? const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.coffee_rounded), label: "Напитки"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_rounded), label: 'Избранное'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart_rounded), label: 'Корзина'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Профиль'),
              ]
                  : const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.coffee_rounded), label: "Напитки"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Профиль'),
              ],
              currentIndex: isLoggedIn ? _selectedPage % 4 : _selectedPage % 2,
                selectedItemColor: const Color.fromRGBO(181, 139, 80, 1.0),
              unselectedItemColor: const Color.fromRGBO(255, 238, 205, 1.0),
              backgroundColor: const Color.fromRGBO(44, 32, 17, 1.0),
              selectedLabelStyle:
              GoogleFonts.sourceSerif4(textStyle: const TextStyle()),
              unselectedLabelStyle:
              GoogleFonts.sourceSerif4(textStyle: const TextStyle()),
              onTap: _onItemTapped,
            ),
          );
        }
        );
  }
}
