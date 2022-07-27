// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip/app/UI/registro_usuario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences spreferences = await SharedPreferences.getInstance();
  var email = spreferences.getString("email");
  await Firebase.initializeApp().then((value) {
    runApp(
      MaterialApp(
        home: email == null ? RegistroUsuario() : RegistroUsuario(),
        debugShowCheckedModeBanner: false,
      ),
    );
  });
}
