// ignore_for_file: unnecessary_import, import_of_legacy_library_into_null_safe

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:proyecto/api_connection/Endpoints/EndPoinst.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:proyecto/users/loginuser/nuevo.dart';
import 'package:proyecto/users/preferencias/actual.dart';
import 'package:proyecto/users/preferencias/preferencias.dart';
import '../model/User.dart';
import 'eleccion.dart';
import 'package:proyecto/users/loginuser/eleccion.dart' as el;
String usuario='', pass='', idespecie='', idcentral='', idperfil='', idlogin='';
String nomcentral='LOS LIRIOS';
int estado=0;
String idexportadora='', exphabilitado='';
String central='';
List<String> exportador=[];
List<String> id_exportador=[];
List<String> centrales=[];
List<String> id_centrales=[];
String comprobar='';
// ignore: must_be_immutable
class login extends StatefulWidget{
  const login ({Key? key}) : super(key: key);

  @override
  State<login> createState() => _Login();
}


class _Login extends State<login> {
  var usuarios = TextEditingController();
  var contrasena = TextEditingController();
  final FocusNode _usuario = FocusNode();  
  final FocusNode _pass = FocusNode();  
  var passenable = true.obs;
  late ConnectivityResult result;
  late StreamSubscription? connection;
  var isoffline= false;
  final _formKey = GlobalKey<FormState>();
  
  @override
  void initState(){
    connection = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        // whenevery connection status is changed.
        if(result == ConnectivityResult.none){
             //there is no any connection
             setState(() {
                 isoffline = true;
             }); 
        }else if(result == ConnectivityResult.mobile){
             //connection is mobile data network
             setState(() {
                isoffline = false;
             });
        }else if(result == ConnectivityResult.wifi){
            //connection is from wifi
            setState(() {
               isoffline = false;
            });
        }
    });
    super.initState();
  }


  showDialogBox(){
    showDialog(barrierDismissible: false,context: context, builder: ((context) => CupertinoAlertDialog(
      title: const Text('No cuenta con internet'),
      content: const Text('Asegurese de tener una conexión a internet'),
      actions: [
        CupertinoButton.filled(child: const Text('Reintentar'), onPressed: () async {
            Navigator.pop(context);
            var result = await Connectivity().checkConnectivity();
            print(result);
            if(result==ConnectivityResult.none)
            {
              Navigator.of(context).pop;
              
            }
            else
            {
              Navigator.of(context).pop;
            }
        })
      ],
    )));
  }  

    loginUserNow() async 
  {
    try
    {
      var res = await http.post(
      Uri.parse(EndPoints.generateEndPointsURL('/loginuser.php')),
      body: {
        'usuario' : usuario,
        'pass' : pass,
      }, 
      ).timeout(const Duration(seconds: 6));
      showDialog(barrierDismissible: false,context: context, builder: (context){
      return const Center(child: CircularProgressIndicator(),);
    });
    print(res.body);
    if(res.statusCode == 200)
      {
      var resBodyOfLogin = jsonDecode(res.body);
      if(resBodyOfLogin['success']== true)
      {
          idexportadora=resBodyOfLogin["infoLogin"]["IDEXPORTADOR"];
          idlogin=resBodyOfLogin["infoLogin"]["IDLOGIN"];
          idperfil=resBodyOfLogin["infoLogin"]["IDPERFIL"];
          idcentral=resBodyOfLogin["infoLogin"]["IDCENTRAL"];
          if(idperfil== '1' || idperfil== '5' || idperfil=='7')
        {
          User userInfo = User.fromJson(resBodyOfLogin["infoLogin"]);
          await preferencias.storeUserInfo(userInfo);
          for(int x=0; x<=resBodyOfLogin["infoEspecie"].length; x++)
          {
            if(x==resBodyOfLogin["infoEspecie"].length)
            {
              Fluttertoast.showToast(msg: "Bienvenido");
              Future.delayed(const Duration(milliseconds: 1000), ()
              {
                
                Get.to(const Eleccion());
              });
            }
            el.especies.add(resBodyOfLogin["infoEspecie"][x]['IDESPECIE']);
          }
        }
        else
        {
          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: 'No cuenta con permisos para ingresar');
        }
      }
      else
      {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: "Credenciales incorrectas. \n Porfavor vuelva a intentarlo");
      }
      }
      else{
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: "Error, no se pudo conectar al servidor");
      }
    }
    on TimeoutException catch(e)
    {
      print(e.message);
      Fluttertoast.showToast(msg: 'Se supero el tiempo maximo');
    }
    catch(errorMsg)
    {
      print('a');
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: "");//Error critico
    }
  }
        
   @override
  void dispose(){
    connection!.cancel();
    super.dispose();
  }
  
    @override
  Widget build(BuildContext context) {
            Future<bool> showExitPopup() async {
      return await showDialog( //show confirm dialogue 
        //the return value will be from "Yes" or "No" options
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cerrar App'),
          content: const Text('¿Quieres salir de la aplicacion?'),
          actions:[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
               //return false when click on "NO"
              child:const Text('No'),
            ),

            ElevatedButton(
              onPressed: () => SystemNavigator.pop(), 
              //return true when click on "Yes"
              child:const Text('Si'),
            ),

          ],
        ),
      )??false; //if showDialouge had returned null, then return false
    }
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Form(
              key: _formKey,
              child: WillPopScope(
                onWillPop: showExitPopup,
                child: SafeArea(
                    child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  backgroundColor: Colors.white, //Color de Fondo
                  body: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white
                    ),
                    child: SingleChildScrollView(
                    child: Column( crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.max,mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipPath(
                          clipper: MycustomClipper(),
                          child:
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height/3.8,
                              decoration: const BoxDecoration(
                                image: DecorationImage(image: AssetImage("assets/images/burak-tonc-bbxwU3HtRkM-unsplash.jpg"),
                                fit: BoxFit.cover)
                              ),
                            ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:<Widget>[
                              const Text('¡Bienvenido nuevamente!',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text('Ingresa a tu cuenta',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.transparent,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      focusNode: _usuario,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (term) {
                                        _fieldFocusChange(context, _usuario, _pass);
                                      },
                                        controller: usuarios,
                                        decoration: const InputDecoration(
                                          prefixIcon: Icon(Icons.person_outline_outlined, color: Colors.black,),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(20),
                                            )
                                          ),
                                          hintText: 'Usuario',
                                          hintStyle: TextStyle(color: Colors.black),
                                        ),
                                        onChanged: (value){
                                          usuario=value;
                                        },
                                      ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Obx(
                                      ()=>TextFormField(
                                        focusNode: _pass,
                                        textInputAction: TextInputAction.go,
                                        onFieldSubmitted: (value) async {
                                          if(usuarios.text.isNotEmpty && contrasena.text.isNotEmpty)
                                          {
                                            var result = await Connectivity().checkConnectivity();
                                            if(result==ConnectivityResult.none)
                                            {
                                              showDialogBox();
                                            }
                                            else 
                                            {
                                              loginUserNow();
                                            }
                                          }
                                          else
                                          {
                                            Fluttertoast.showToast(msg: "Asegurese de rellenar los campos");
                                          }
                                        },
                                        controller: contrasena,
                                        obscureText: passenable.value,
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(Icons.lock_outline_rounded, color: Colors.black,),
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(20),
                                            ),
                                          ),
                                          hintText: 'Contraseña',
                                          hintStyle: const TextStyle(color: Colors.black),
                                          suffixIcon: Obx(
                                            ()=> GestureDetector(
                                              onTap: ()
                                              {
                                                passenable.value = !passenable.value;
                                              },
                                              child: Icon(passenable.value ? Icons.visibility_off : Icons.visibility,
                                              color: Colors.black,),
                                            ),
                                          )
                                        ),
                                        onChanged: (value){
                                          pass=value;
                                        },
                                      )
                                    ) ,
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                          elevation: MaterialStateProperty.all<double>(15.0),
                                        ),
                                        onPressed: () async{
                                          FocusManager.instance.primaryFocus?.unfocus();
                                          if(usuarios.text.isNotEmpty && contrasena.text.isNotEmpty)
                                          {
                                            var result = await Connectivity().checkConnectivity();
                                            if(result==ConnectivityResult.none)
                                            {
                                              showDialogBox();
                                            }
                                            else 
                                            {
                                              loginUserNow();
                                            }
                                          }
                                          else
                                          {
                                            Fluttertoast.showToast(msg: "Asegurese de rellenar los campos");
                                          }
                                        },
                                        child: const Text('Iniciar Sesión', style: TextStyle(
                                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18
                                        ),)),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      child: Image.asset('assets/images/logoo.png',
                                      width: MediaQuery.of(context).size.width,
                                      height: 100,),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  ),
                )),
              ),
            ),
          );
      }
    );
  }
}
_fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);  
}
