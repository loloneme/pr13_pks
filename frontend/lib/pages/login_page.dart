import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/pages/profile_page.dart';
import 'package:frontend/pages/register_page.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = AuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;



  void login() async{
    final email = _emailController.text;
    final password = _passwordController.text;


    try{
      await authService.signIn(email, password);
    }

    catch (e){
      if (mounted){
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: const Color.fromRGBO(44, 32, 17, 1.0),
              content: Text('Ошибка: $e',
                style: GoogleFonts.sourceSerif4(
                textStyle: const TextStyle(
                fontSize: 18.0,
                color: Color.fromRGBO(255, 238, 205, 1.0)))
          ))
    );
    }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(71, 58, 42, 1.0),
      body: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Добро пожаловать!",
          style: GoogleFonts.sourceSerif4(
              textStyle: const TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(255, 238, 205, 1.0),
              ))),
          const SizedBox(height: 50),
          SizedBox(
            width: 260,
            child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.sourceSerif4(
                    textStyle: const TextStyle(
                        fontSize: 18.0,
                        color: Color.fromRGBO(255, 238, 205, 1.0))),
                decoration: InputDecoration(
                    counterText: '',
                    isDense: true,
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            color:
                            Color.fromRGBO(44, 32, 17, 1.0),
                            width: 2.0)),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            color:
                            Color.fromRGBO(44, 32, 17, 1.0),
                            width: 2.0)),
                    contentPadding: const EdgeInsets.all(5),
                    labelText: "Адрес эл. почты",
                    labelStyle: GoogleFonts.sourceSerif4(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 18.0,
                            color: Color.fromRGBO(255, 238, 205, 1.0)
                        )
                    ),
                ),
            ),
          ),
          const SizedBox(
            height: 10
          ),
          SizedBox(
            width: 260,
            child: TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              style: GoogleFonts.sourceSerif4(
                  textStyle: const TextStyle(
                      fontSize: 18.0,
                      color: Color.fromRGBO(255, 238, 205, 1.0))),
              decoration: InputDecoration(
                counterText: '',
                isDense: true,
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                        color:
                        Color.fromRGBO(44, 32, 17, 1.0),
                        width: 2.0)),
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                        color:
                        Color.fromRGBO(44, 32, 17, 1.0),
                        width: 2.0)),
                contentPadding: const EdgeInsets.all(5),
                labelText: "Пароль",
                labelStyle: GoogleFonts.sourceSerif4(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 18.0,
                        color: Color.fromRGBO(255, 238, 205, 1.0)
                    )
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: const Color.fromRGBO(255, 238, 205, 1.0),
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
              const Color.fromRGBO(44, 32, 17, 1.0),
            ),
            onPressed: login,
            child: Text('Войти',
                style: GoogleFonts.sourceSerif4(
                    textStyle: const TextStyle(
                        fontSize: 20.0,
                        color: Color.fromRGBO(
                            255, 238, 205, 1.0)))),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RegisterPage())
              );
              },
            child: Text('Нет аккаунта? Регистрация',
                style: GoogleFonts.sourceSerif4(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w300,
                        fontSize: 14.0,
                        color: Color.fromRGBO(
                            255, 238, 205, 1.0)
                    )
                )
            ),
          )
        ],
      ),
    ));
  }
}
