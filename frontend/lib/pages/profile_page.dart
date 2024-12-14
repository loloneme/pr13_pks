import 'package:flutter/material.dart';
import 'package:frontend/api_service.dart';
import 'package:frontend/models/profile.dart';
import 'package:frontend/pages/orders_page.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage(
      {super.key, required this.userID});

  final String userID;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditMode = false;
  String _uploadedImage = '';

  late Future<Profile> _profileFuture;

  @override
  void initState(){
    super.initState();
    _profileFuture = ApiService().getProfile(widget.userID);
    _uploadedImage = '';
    _nameController = TextEditingController(text: "");
    _phoneController = TextEditingController(text: "");
    _avatarUrlController = TextEditingController(text: "");
  }

  final authService = AuthService();


  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _avatarUrlController;

  void _navigateToMyOrdersPage(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                OrdersPage(
                  userID: widget.userID,
                )
        ));
  }

  void _logout() async{
     try {
    await authService.signOut();

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Ошибка при выходе: $e',
          style: GoogleFonts.sourceSerif4(
            textStyle: const TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
  }

  void _updateProfile(Profile profile) async{
    try{
      await ApiService().updateProfile(profile);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ошибка при обновлении: $e',
            style: GoogleFonts.sourceSerif4(
              textStyle: const TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _turnOnTheEditMode() {
    setState(() {
      _isEditMode = true;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _avatarUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text("Профиль",
                  style: GoogleFonts.sourceSerif4(
                      textStyle: const TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(255, 238, 205, 1.0),
                  )))),
          backgroundColor: const Color.fromRGBO(71, 58, 42, 1.0),
          actions: [
            IconButton(onPressed: _logout,
                icon: const Icon(
                  Icons.logout_rounded,
                  color: Color.fromRGBO(255, 238, 205, 1.0),
                )
            )
          ],
        ),
        backgroundColor: const Color.fromRGBO(71, 58, 42, 1.0),
        body: FutureBuilder<Profile>
          (future: _profileFuture, 
            builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Ошибка: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('Невозможно получить пользователя'));
                } else {
                final profile = snapshot.data!;
                return SingleChildScrollView(
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: const Color.fromRGBO(71, 58, 42, 1.0),
                    child: Center(
                      child: _isEditMode
                          ? Column(children: [
                              const SizedBox(height: 40),
                              Container(
                                width: 200,
                                height: 200,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(_uploadedImage != ''
                                          ? _uploadedImage
                                          : 'https://github.com/loloneme/images/blob/main/c0749b7cc401421662ae901ec8f9f660%20(1).jpg?raw=true'),
                                      fit: BoxFit.cover
                                    ),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color:
                                            const Color.fromRGBO(44, 32, 17, 1.0),
                                        width: 3)),
                              ),
                              const SizedBox(height: 30),
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
                                      labelText: "URL аватарки",
                                      labelStyle: GoogleFonts.sourceSerif4(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 18.0,
                                              color: Color.fromRGBO(
                                                  217, 217, 217, 1.0)))),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Введите URL";
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      _uploadedImage = value;
                                    });
                                  }
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: 260,
                                child: TextFormField(
                                  controller: _nameController,
                                  maxLength: 50,
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
                                      labelText: "Фамилия и имя",
                                      labelStyle: GoogleFonts.sourceSerif4(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 18.0,
                                              color: Color.fromRGBO(
                                                  217, 217, 217, 1.0)))),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Введите Ваши Фамилию и имя!";
                                    }
                                    return null;
                                  }
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(profile.email,
                                  style: GoogleFonts.sourceSerif4(
                                      textStyle: const TextStyle(
                                        fontSize: 20.0,
                                        color: Color.fromRGBO(255, 238, 205, 1.0),
                                      ))),
                              // SizedBox(
                              //   width: 260,
                              //   child: TextFormField(
                              //     controller: _emailController,
                              //     keyboardType: TextInputType.emailAddress,
                              //     style: GoogleFonts.sourceSerif4(
                              //         textStyle: const TextStyle(
                              //             fontSize: 18.0,
                              //             color: Color.fromRGBO(255, 238, 205, 1.0))),
                              //     decoration: InputDecoration(
                              //         counterText: '',
                              //         isDense: true,
                              //         enabledBorder: const UnderlineInputBorder(
                              //             borderSide: BorderSide(
                              //                 color:
                              //                     Color.fromRGBO(44, 32, 17, 1.0),
                              //                 width: 2.0)),
                              //         focusedBorder: const UnderlineInputBorder(
                              //             borderSide: BorderSide(
                              //                 color:
                              //                     Color.fromRGBO(44, 32, 17, 1.0),
                              //                 width: 2.0)),
                              //         contentPadding: const EdgeInsets.all(5),
                              //         labelText: "Адрес эл. почты",
                              //         labelStyle: GoogleFonts.sourceSerif4(
                              //             textStyle: const TextStyle(
                              //                 fontWeight: FontWeight.w300,
                              //                 fontSize: 18.0,
                              //                 color: Color.fromRGBO(
                              //                     217, 217, 217, 1.0)))),
                              //     validator: (value) {
                              //       if (value == null || value.isEmpty) {
                              //         return "Введите адрес Вашей эл. почты";
                              //       }
                              //       return null;
                              //     }
                              //   ),
                              // ),
                              const SizedBox(height: 10),
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
                                      labelText: "Номер телефона",
                                      labelStyle: GoogleFonts.sourceSerif4(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 18.0,
                                              color: Color.fromRGBO(
                                                  217, 217, 217, 1.0)))),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Введите Ваш номер телефона";
                                    }
                                    return null;
                                  }
                                ),
                              ),
                              const SizedBox(height: 60),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(44, 32, 17, 1.0),
                                ),
                                onPressed: (){_updateProfile(Profile(
                                              userID: widget.userID,
                                              fullname: _nameController.text,
                                              image: _avatarUrlController.text,
                                              phone: _phoneController.text,
                                              email: profile.email));
                                  },
                                child: Text('Сохранить',
                                    style: GoogleFonts.sourceSerif4(
                                        textStyle: const TextStyle(
                                            fontSize: 18.0,
                                            color: Color.fromRGBO(
                                                255, 238, 205, 1.0)))),
                              ),
                            ])
                          : Column(children: [
                              const SizedBox(height: 40),
                              Container(
                                width: 200,
                                height: 200,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(profile.image ??
                                            'https://github.com/loloneme/images/blob/main/c0749b7cc401421662ae901ec8f9f660%20(1).jpg?raw=true'),
                                        fit: BoxFit.cover),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color:
                                            const Color.fromRGBO(44, 32, 17, 1.0),
                                        width: 3)),
                              ),
                              const SizedBox(height: 30),
                              Row(mainAxisSize: MainAxisSize.min, children: [
                                Text(profile.fullname,
                                    style: GoogleFonts.sourceSerif4(
                                        textStyle: const TextStyle(
                                      fontSize: 28.0,
                                      color: Color.fromRGBO(255, 238, 205, 1.0),
                                    ))),
                                SizedBox(
                                  width: 20,
                                  child: IconButton(
                                    onPressed: _turnOnTheEditMode,
                                    icon: const Icon(Icons.edit),
                                    color: const Color.fromRGBO(255, 238, 205, 1.0),
                                    iconSize: 20,
                                  ),
                                )
                              ]),
                              const SizedBox(height: 15),
                              Text(profile.email,
                                  style: GoogleFonts.sourceSerif4(
                                      textStyle: const TextStyle(
                                    fontSize: 20.0,
                                    color: Color.fromRGBO(255, 238, 205, 1.0),
                                  ))),
                              const SizedBox(height: 15),
                              Text(profile.phone,
                                  style: GoogleFonts.sourceSerif4(
                                      textStyle: const TextStyle(
                                    fontSize: 20.0,
                                    color: Color.fromRGBO(255, 238, 205, 1.0),
                                  ))),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 30, 0, 15),
                                child: Center(
                                  child: Container(
                                    width: 160,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(255, 238, 205, 1.0),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  _navigateToMyOrdersPage(context);
                                },
                                child: Row(
                                  children:[
                                    const Icon(
                                      Icons.history_rounded,
                                      size: 20,
                                      color: Color.fromRGBO(255, 238, 205, 1.0),
                                    ),
                                    Text("Мои заказы",
                                        style: GoogleFonts.sourceSerif4(
                                            textStyle: const TextStyle(
                                              fontSize: 20.0,
                                              color: Color.fromRGBO(255, 238, 205, 1.0),
                                            )
                                        )
                                    )
                                  ]
                                ),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: (){},
                                child: Row(
                                    children:[
                                      const Icon(
                                        Icons.mark_chat_read_rounded,
                                        size: 20,
                                        color: Color.fromRGBO(255, 238, 205, 1.0),
                                      ),
                                      Text("Чат с поддержкой",
                                          style: GoogleFonts.sourceSerif4(
                                              textStyle: const TextStyle(
                                                fontSize: 20.0,
                                                color: Color.fromRGBO(255, 238, 205, 1.0),
                                              )
                                          )
                                      )
                                    ]
                                ),
                              )
                            ]),
                    ))
                );
                }
          })
    );
  }
}
