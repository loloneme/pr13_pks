import 'package:flutter/material.dart';
import 'package:frontend/models/profile.dart';
import 'package:google_fonts/google_fonts.dart';

import '../api_service.dart';
import '../auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authService = AuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _avatarUrlController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;



  void signUp() async{
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: const Color.fromRGBO(44, 32, 17, 1.0),
            content: Text('Пароли не совпадают!',
                style: GoogleFonts.sourceSerif4(
                    textStyle: const TextStyle(
                        fontSize: 18.0,
                        color: Color.fromRGBO(255, 238, 205, 1.0)))
            ))
      );
    }


    try{
      final response = await authService.signUp(email, password);
      final user = response.user;

      if (user == null) {
        throw Exception('couldnt get user information');
      }

      await ApiService().register(Profile(
          userID: user.id,
          fullname: _nameController.text,
          image: _avatarUrlController.text,
          email: email,
          phone: _phoneController.text)
      );

      Navigator.pop(context);
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
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(71, 58, 42, 1.0),
      ),
      body: SingleChildScrollView(
    child: Center(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Регистрация",
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
              controller: _avatarUrlController,
              keyboardType: TextInputType.url,
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
                labelText: "URL Вашей аватарки",
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
              controller: _nameController,
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
                labelText: "Ваше имя",
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
              controller: _phoneController,
              keyboardType: TextInputType.phone,
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
                labelText: "Ваш номер телефона",
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
          const SizedBox(
              height: 10
          ),
          SizedBox(
            width: 260,
            child: TextFormField(
              controller: _confirmPasswordController,
              obscureText: !_isConfirmPasswordVisible,
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
                labelText: "Подтвердите пароль",
                labelStyle: GoogleFonts.sourceSerif4(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 18.0,
                        color: Color.fromRGBO(255, 238, 205, 1.0)
                    )
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: const Color.fromRGBO(255, 238, 205, 1.0),
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
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
            onPressed: signUp,
            child: Text('Зарегистрироваться',
                style: GoogleFonts.sourceSerif4(
                    textStyle: const TextStyle(
                        fontSize: 20.0,
                        color: Color.fromRGBO(
                            255, 238, 205, 1.0)))),
          ),
        ],
      ),
    )));
  }
}
