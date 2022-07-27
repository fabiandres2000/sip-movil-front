// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, sort_child_properties_last, use_build_context_synchronously

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:sip/app/data/constantes.dart';


class RegistroUsuario extends StatefulWidget {
  const RegistroUsuario({ Key? key }) : super(key: key);

  @override
  State<RegistroUsuario> createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {

  bool loading = false;

  BoxDecoration decoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10)),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 1,
        blurRadius: 5,
        offset:
            Offset(0, 3), // changes position of shadow
      ),
    ],
  );

  //campos de registro
  TextEditingController idcontroller =  TextEditingController();
  TextEditingController nombrescontroller =  TextEditingController();
  TextEditingController emailcontroller =  TextEditingController();
  TextEditingController passcontroller =  TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlurryModalProgressHUD(
      inAsyncCall: loading,
      blurEffectIntensity: 4,
      progressIndicator: Center(child:Image.asset("assets/cargando.gif")),
      dismissible: false,
      opacity: 0.4,
      color: Colors.black87,
      child: Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                  Container(
                    height: size.height / 5,
                    width: size.width,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Image.asset("assets/logoSip1.png"),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal:10 ),
                    child: Text(
                      "Registro de usuario",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 22),
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: 50,
                          decoration: decoration,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: idcontroller,
                                decoration: InputDecoration(
                                    border: InputBorder.none, hintText: 'Identificación'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: 50,
                          decoration: decoration,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                              child: TextField(
                                keyboardType: TextInputType.text,
                                controller: nombrescontroller,
                                decoration: InputDecoration(
                                    border: InputBorder.none, hintText: 'Nombre completo'),
                              ),
                            ),
                          ),
                        ),
                      ),
                       SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: 50,
                          decoration: decoration,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                              child: TextField(
                                keyboardType: TextInputType.text,
                                controller: emailcontroller,
                                decoration: InputDecoration(
                                    border: InputBorder.none, hintText: 'Correo electronico'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: 50,
                          decoration: decoration,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                              child: TextField(
                                keyboardType: TextInputType.visiblePassword,
                                controller: passcontroller,
                                decoration: InputDecoration(
                                    border: InputBorder.none, hintText: 'Contraseña'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          width: double.infinity,
                          child: MaterialButton(
                            color:  Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onPressed: () {
                              loginUserPassword(context);
                            },
                            child: Text(
                              "Guardar",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                            height:50,
                          ),
                        ),
                      ),
                    ]
                  )
              ]
            )
          )
        )
      )
    ));
  }

  loginUserPassword(BuildContext context) async {
    setState(() {
      loading = true;
    });
    var pemail = emailcontroller.text;
    var pcontra = passcontroller.text;
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: pemail,
        password: pcontra,
      );
      //_guardar(context);
      setState(() {
        loading = false;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _mensaje(Colors.red,"La contraseña proporcionada es demasiado débil.", context);
      } else if (e.code == 'email-already-in-use') {
        _mensaje(Colors.red,"La cuenta ya existe para ese correo electrónico.", context);
      }
    } catch (e) {
      print(e);
    }
  }

  _guardar (BuildContext context) async {
    var pnombre = nombrescontroller.text;
    var pemail = emailcontroller.text;
    var pcontra = passcontroller.text;
    var pid = idcontroller.text;

    if(_validarCampos(pnombre, pemail, pcontra, pid)){
      setState(() {
        loading = true;
      });

      var response = await http.get(Uri.parse('${BaseUrl}registrar?nombre=$pnombre&email=$pemail&contra=$pcontra&id=$pid'));

      final reponsebody = json.decode(response.body);

      var codigo = reponsebody["existe"];

      switch (codigo) {
        case 99:
          _mensaje(Colors.orange,"Debe ser mayor de edad para poder registrarse.", context);
          break;
        case 1:
          _mensaje(Colors.orange,"Ya existe un usuario con ese email.", context);
          break;
        case 0:
          await _guardarPreferencias(pemail);
          _mensaje(Colors.green,"Usuario registrado correctamente", context);
          break;
      }
    }else{
       _mensaje(Colors.red,"Todos los campos son de caracter obligatorio.", context);
    }
  }

  _mensaje( Color color, String mensaje, BuildContext context){
    setState(() {
      loading = false;
    });

    MotionToast(
      primaryColor: color,
      description: Text(mensaje),
      icon: Icons.message,
    ).show(context);
    /*
    if(mensaje == "Usuario registrado correctamente"){
      Timer(Duration(milliseconds: 2000), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      });
    }
  */
  }

  _validarCampos(String pnombre, String pemail, String pcontra, String pid){
    if(pnombre.isEmpty || pemail.isEmpty || pcontra.isEmpty || pid.isEmpty){
      return false;
    }
    return true;
  }

  _guardarPreferencias(String email) async {
    var spreferences = await SharedPreferences.getInstance();
      var response = await http.get(Uri.parse('${BaseUrl}usuario?email=$email&id='),headers: {"Accept": "application/json"});

      final reponsebody = json.decode(response.body);

      spreferences.setString("email", reponsebody['usuario']['email']);
      spreferences.setString("nombre", reponsebody['usuario']['nombre']);
      spreferences.setString("bio", reponsebody['usuario']['bio'] ?? '');
      spreferences.setString("alias", reponsebody['alias'] ?? '');
      spreferences.setBool("notificaciones", true);
      spreferences.setString("id", reponsebody['usuario']['id'].toString());
      spreferences.setString("id_usu", reponsebody['usuario']['id'].toString());
      spreferences.setString("imagen", reponsebody['usuario']['imagen']);
  }
}