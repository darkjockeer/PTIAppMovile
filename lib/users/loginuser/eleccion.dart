// ignore_for_file: unused_import, import_of_legacy_library_into_null_safe

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:proyecto/drawers/drawerauditoria.dart';
import 'package:proyecto/drawers/draweruvas.dart';
import 'package:proyecto/graficos/Auditorias/crecepcion.dart';
import 'package:proyecto/graficos/Ranking/Graficoss.dart' as gr;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:proyecto/graficos/Ranking/graficosegregacion.dart';
import 'package:proyecto/graficos/Tendencia/graficotendencia.dart';
import 'package:proyecto/graficos/segregacion/segregacion.dart';
import 'package:proyecto/main.dart';
import 'package:proyecto/users/loginuser/login.dart' as lg;
import 'package:proyecto/users/model/User.dart';
import 'package:proyecto/users/model/noti.dart';
import 'package:proyecto/users/preferencias/actual.dart';
import 'package:proyecto/users/preferencias/preferencias.dart';
import 'package:proyecto/graficos/Tendencia/graficotendencia.dart' as gt;
import '../../api_connection/Endpoints/EndPoinstCerezas.dart';
import '../../drawers/drawerarandanos.dart';
import '../../drawers/drawerpomaceas.dart';
import 'login.dart';
import 'nuevo.dart';
import 'package:http/http.dart' as http;

bool ce=false, ar=false, po=false, ki=false, ca=false, uva=false;
double largo=0;
double hancho=0;
String nuevoidexportador='';
String nombreidexportador='';
String diaguardado='Seleccione fecha';
String foto='';
List <String> especies=[];
int version=2;
int index2=996;
int initialPage = (
    996);
List <String> nombres=[];
List <String> id_nombres=[];
  int currentIndexs=0;
  int paginaactual=0;
  int selectedSpecies=0;
List<String> images =[
    "assets/images/aucerezas.png",
    "assets/images/torta.png",
    "assets/images/tendencia.png",
    "assets/images/segregacion.png"
    
  ];
class Eleccion extends StatefulWidget {
  static String id = 'Eleccion';

  const Eleccion({super.key});
  @override
  State<Eleccion> createState() => _Eleccion();
}
String fruta='Informe puntos críticos';
class _Eleccion extends State<Eleccion>{
  final actual _currentUser = Get.put(actual());
  @override
  void initState() {
    info2('1', 0);
    super.initState();
  }
  actual remeberCurrentUser = Get.put(actual());
  final PageController controllers = PageController();

  void autenticacion(){
    if(especies.isEmpty)
    {
      print('vacio');
      infologin();
    }
    else{
      paginainicial();
    }
  }

  infologin() async
  {
  try
    {
      var res = await http.post(
      Uri.parse(EndPoints.generateEndPointsURL('/loginuser.php')),
      body: {
        'usuario' : _currentUser.user.USUARIO.toString(),
        'pass' : _currentUser.user.PASS.toString(),
      }, 
      ).timeout(const Duration(seconds: 6));
    if(res.statusCode == 200)
      {
      var resBodyOfLogin = jsonDecode(res.body);
      if(resBodyOfLogin['success']== true)
      {
        for(int x=0; x<resBodyOfLogin["infoEspecie"].length; x++)
          {
            if(x==resBodyOfLogin["infoEspecie"].length)
            {
              paginainicial();
            }
            especies.add(resBodyOfLogin["infoEspecie"][x]['IDESPECIE']);
          }
      }
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
      Fluttertoast.showToast(msg: "Error critico");
    }
}

  showDialogBox(){
    showDialog(barrierDismissible: false,context: context, builder: ((context) => CupertinoAlertDialog(
      title: const Text('No cuenta con internet'),
      content: const Text('Asegurese de tener una conexión a internet'),
      actions: [
        CupertinoButton.filled(child: const Text('Reintentar'), onPressed: () async {
            Navigator.pop(context);
            var result = await Connectivity().checkConnectivity();
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

  showversion(){
    showDialog(barrierDismissible: false, context: context, builder: ((context)=>CupertinoAlertDialog(
      title: const Text('Versión incompatible'),
      content: const Text('Actualize a la ultima versión'),
      actions: [
        CupertinoButton.filled(child: const Text('Ok'), onPressed: () async{
          if(version==1)
          {
            exit(0);
          }
          else
          {
            Navigator.of(context).pop;
          }
        })
      ],
    )));
  }

  info2(String num, int num2) async 
  {
    lg.exportador=[];
    lg.centrales=[];
    try
    {
      var rest = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLInfoExportadores('/ExportadoresxControlCaja.php')),
      body: {
        'idlogin' : _currentUser.user.IDLOGIN.toString(),
        'idexportador' : _currentUser.user.IDEXPORTADOR.toString(),
        'num': num,
        'idperfil': _currentUser.user.IDPERFIL.toString()

      },
      ).timeout(const Duration(seconds: 8));
    if(rest.statusCode == 200)
      {
      var resBody2 = jsonDecode(rest.body);
      if(resBody2['success']== true)
      {
        for (int x=0; x<=resBody2["userData"].length; x=x+1){
          if(_currentUser.user.IDPERFIL.toString()=='1')
          {
            lg.exportador.add(resBody2["userData"][x]["NOMEXPORTADOR"]);
            lg.id_exportador.add(resBody2["userData"][x]["IDEXPORTADOR"]);
            print('entro2');
          }
          if(_currentUser.user.IDEXPORTADOR.toString()==resBody2["userData"][x]["IDEXPORTADOR"] && num=='1')
          {
            nuevoidexportador=(resBody2["userData"][x]["IDEXPORTADOR"]);
            nombreidexportador=(resBody2["userData"][x]["NOMEXPORTADOR"]);
            print(nombreidexportador);
            info6(num2);
            tomarfoto();
            print('entro1');
          }
          if(_currentUser.user.IDEXPORTADOR.toString()==resBody2["userData"][x]["IDEXPORTADOR"] && num=='2')
          {
            nuevoidexportador=(resBody2["userData"][x]["IDEXPORTADOR"]);
            nombreidexportador=(resBody2["userData"][x]["NOMEXPORTADOR"]);
            print('entro');
            print(nuevoidexportador);
            info5(num2);
            tomarfoto();
          }
          else if(num=='1' && num2==0)
          {
            nuevoidexportador=(resBody2["userData"][x]["IDEXPORTADOR"]);
            nombreidexportador=(resBody2["userData"][x]["NOMEXPORTADOR"]);
            print(nuevoidexportador);
            print('entrooo');
            autenticacion();
            break;
          }else{
            nuevoidexportador=(resBody2["userData"][x]["IDEXPORTADOR"]);
            nombreidexportador=(resBody2["userData"][x]["NOMEXPORTADOR"]);
            autenticacion();
          }

        }
      }
      }
    }
    on TimeoutException catch(e)
    {
      print(e.message);
      Fluttertoast.showToast(msg: 'Se supero el tiempo maximo, porfavor reinicie la aplicacion, si el problema persiste contacte con administrador');
    }
    catch(errorMsg)
    {
      return("Error :: $errorMsg");
    }
  }

  info3(int num2) async 
  {
    try
    {
      var rests = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLInfoCentrales('/CentralesxControlCaja.php')),
      body: {
        'idlogin' : _currentUser.user.IDLOGIN.toString(),
        'idperfil' : _currentUser.user.IDPERFIL.toString(),
        'idcentral': _currentUser.user.IDCENTRAL.toString(),
        'idexportador' : _currentUser.user.IDEXPORTADOR.toString(),
      },
      ).timeout(const Duration(seconds: 8));
    if(rests.statusCode == 200)
      {
      var resBody3 = jsonDecode(rests.body);
      if(resBody3['success']== true)
      {
        for (int x=0; x<=resBody3["userData"].length; x=x+1)
        {
            if(_currentUser.user.IDPERFIL==5 || _currentUser.user.IDPERFIL==1)
          {
            if(x==resBody3["userData"].length && num2==1)
            {
              variedad();
            }
            else if(x==resBody3["userData"].length && num2==2)
            {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) {
                                              return Graficoten();
                                            })), (route) => false);
            }
            lg.centrales.add(resBody3["userData"][x]["NOMCENTRAL"]);
          }
          else
          {
            if(_currentUser.user.IDCENTRAL.toString()==resBody3["userData"][x]["IDCENTRAL"])
            {
              if(x==resBody3["userData"].length && num2==1)
            {
              variedad();
            }
            else if(x==resBody3["userData"].length && num2==2)
            {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) {
                                              return Graficoten();
                                            })), (route) => false);
            }
              lg.centrales.add(resBody3["userData"][x]["NOMCENTRAL"]);
            }
          }
        }
      }
      else
      {
        for (int x=0; x<=resBody3["userData"].length; x=x+1)
        {
          if(x==resBody3["userData"].length && num2==1)
            {
              variedad();
            }
            else if(x==resBody3["userData"].length && num2==2)
            {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) {
                                              return Graficoten();
                                            })), (route) => false);
            }
          lg.centrales.add(resBody3["userData"][x]["NOMCENTRAL"]);
        }
      }
      }
    }
    on TimeoutException catch(e)
    {
      print(e.message);
      Fluttertoast.showToast(msg: 'Se supero el tiempo maximo, porfavor reinicie la aplicacion, si el problema persiste contacte con administrador');
    }
    catch(errorMsg)
    {
      return("Error :: $errorMsg");
    }
  }

  info4(int num2) async 
  {
    try
    {
      var rests = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLInfoCentrales('/CentralesxExportador.php')),
      body: {
        'idlogin' : _currentUser.user.IDLOGIN.toString(),
        'idperfil' : _currentUser.user.IDPERFIL.toString(),
        'idcentral': _currentUser.user.IDCENTRAL.toString(),
        'idexportador' : nuevoidexportador,
      },
      ).timeout(const Duration(seconds: 8));
      print(rests.body);
    if(rests.statusCode == 200)
      {
      var resBody3 = jsonDecode(rests.body);

      if(resBody3['success']== true)
      {
        for (int x=0; x<=resBody3["userData"].length; x=x+1)
        {
          if(_currentUser.user.IDPERFIL==5 || _currentUser.user.IDPERFIL==1)
          {
            if(x==resBody3["userData"].length-1)
            {
              variedad2();
            }
            lg.centrales.add(resBody3["userData"][x]["NOMCENTRAL"]);
          }
          else
          {
            if(_currentUser.user.IDCENTRAL.toString()==resBody3["userData"][x]["IDCENTRAL"])
            {
              lg.centrales.add(resBody3["userData"][x]["NOMCENTRAL"]);
              variedad2();
            }
          }
        }
      }
      else
      {
        for (int x=0; x<=resBody3["userData"].length; x=x+1)
        {
          if(x==resBody3["userData"].length-1)
            {
              variedad2();
            }
          lg.centrales.add(resBody3["userData"][x]["NOMCENTRAL"]);
        }
      }
      }
    }
    on TimeoutException catch(e)
    {
      print(e.message);
      Fluttertoast.showToast(msg: 'Se supero el tiempo maximo, porfavor reinicie la aplicacion, si el problema persiste contacte con administrador');
    }
    catch(errorMsg)
    {
      return("Error :: $errorMsg");
    }
  }
  
  info5(int num2) async 
  {
    print(_currentUser.user.IDEXPORTADOR);
    print(_currentUser.user.IDLOGIN);
    print(_currentUser.user.IDPERFIL);
    print(_currentUser.user.IDCENTRAL);
    try
    {
      var rests = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLInfoCentrales('/CentralesxExportador.php')),
      body: {
        'idlogin' : _currentUser.user.IDLOGIN.toString(),
        'idperfil' : _currentUser.user.IDPERFIL.toString(),
        'idcentral': _currentUser.user.IDCENTRAL.toString(),
        'idexportador' : nuevoidexportador,
      },
      ).timeout(const Duration(seconds: 10));
    print(rests.body);
    if(rests.statusCode == 200)
      {
      var resBody3 = jsonDecode(rests.body);
      if(resBody3['success']== true)
      {
        for (int x=0; x<=resBody3["userData"].length; x=x+1)
        {
          if(_currentUser.user.IDPERFIL==5 || _currentUser.user.IDPERFIL==1)
          {
            print('entro1');
            lg.id_centrales.add(resBody3["userData"][x]["IDCENTRAL"]);
            if(x==resBody3["userData"].length-1)
            {
              info4(num2);
              print('entro2');
            }
          }
          else
          {
            print('entro3');
            if(_currentUser.user.IDCENTRAL.toString()==resBody3["userData"][x]["IDCENTRAL"])
            {
              print('entro4');
              info4(num2);
              lg.id_centrales.add(resBody3["userData"][x]["IDCENTRAL"]);
            }
          }
        }
      }
      else
      {
        for (int x=0; x<=resBody3["userData"].length; x=x+1)
        {
          if(x==resBody3["userData"].length-1)
            {
              info4(num2);
            }
          lg.id_centrales.add(resBody3["userData"][x]["IDCENTRAL"]);
        }
      }
      }
    }
    on TimeoutException catch(e)
    {
      print(e.message);
      Fluttertoast.showToast(msg: 'Se supero el tiempo maximo, porfavor reinicie la aplicacion, si el problema persiste contacte con administrador');
    }
    catch(errorMsg)
    {
      return("Error :: $errorMsg");
    }
  }

  info6(int num2) async 
  {
    try
    {
      var rests = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLInfoCentrales('/CentralesxControlCaja.php')),
      body: {
        'idlogin' : _currentUser.user.IDLOGIN.toString(),
        'idperfil' : _currentUser.user.IDPERFIL.toString(),
        'idcentral': _currentUser.user.IDCENTRAL.toString(),
        'idexportador' : _currentUser.user.IDEXPORTADOR.toString(),
      },
      ).timeout(const Duration(seconds: 8));
    if(rests.statusCode == 200)
      {
      var resBody3 = jsonDecode(rests.body);
      if(resBody3['success']== true)
      {
        for (int x=0; x<resBody3["userData"].length; x=x+1)
        {
          if(_currentUser.user.IDPERFIL==5 || _currentUser.user.IDPERFIL==1)
          {
            lg.id_centrales.add(resBody3["userData"][x]["IDCENTRAL"]);
            if(x==resBody3["userData"].length-1)
            {
              info3(num2);
            }
          }
          else
          {
            if(_currentUser.user.IDCENTRAL.toString()==resBody3["userData"][x]["IDCENTRAL"])
            {
              info3(num2);
              lg.id_centrales.add(resBody3["userData"][x]["IDCENTRAL"]);
            }
          }
        }
      }
      else
      {
        for (int x=0; x<=resBody3["userData"].length; x=x+1)
        {
          if(x==resBody3["userData"].length-1)
            {
              info3(num2);
            }
          lg.id_centrales.add(resBody3["userData"][x]["IDCENTRAL"]);
        }
      }
      }
    }
    on TimeoutException catch(e)
    {
      print(e.message);
      Fluttertoast.showToast(msg: 'Se supero el tiempo maximo, porfavor reinicie la aplicacion, si el problema persiste contacte con administrador');
    }
    catch(errorMsg)
    {
      return("Error :: $errorMsg");
    }
  }

  infocentralxespecie(String num) async
  {
    print('a');
    try
    {
      var rest = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLInfoCentrales('/CentralesxEspecies.php'),),
      body: {
        'idexportador':_currentUser.user.IDEXPORTADOR.toString(),
        'idespecie': num
      }
      ).timeout(const Duration(seconds: 8));
      print(rest.body);
    if(rest.statusCode == 200)
      {
      var resBody2 = jsonDecode(rest.body);
      if(resBody2['success']== true)
      {
        for (int x=0; x<=resBody2["nomcentral"].length; x=x+1){
          print(resBody2["nomcentral"][x]);
          print(x);
          lg.centrales.add(resBody2["nomcentral"][x]);
          lg.id_centrales.add(resBody2["idcentral"][x].toString());
          if(x==resBody2["nomcentral"].length-1)
          {
            if(paginaactual==0)
            {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) {
                                              return drawerauditoria();
                                            })), (route) => false);
            }
            else if(paginaactual==1)
            {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) {
                                              return drawerarandanos();
                                            })), (route) => false);
            }
            else if(paginaactual==2)
            {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) {
                                              return drawerauditoria();
                                            })), (route) => false);
            }
            else if(paginaactual==3)
            {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) {
                                              return drawerauditoria();
                                            })), (route) => false);
            }
            else if(paginaactual==4)
            {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) {
                                              return drawerpomaceas();
                                            })), (route) => false);
            }
            else if(paginaactual==5)
            {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) {
                                              return draweuvas();
                                            })), (route) => false);
            }
          }
        }
        }
      else
      {
      }
      }
    }
    on TimeoutException catch(e)
    {
      print(e.message);
      Fluttertoast.showToast(msg: 'Se supero el tiempo maximo, porfavor reinicie la aplicacion, si el problema persiste contacte con administrador');
    }
    catch(errorMsg)
    {
      return("Error :: $errorMsg");
    }
  }

  variedad ()async{
  
    try
    {
      var url8=Uri.parse(EndPoints.generateEndPointsURLtabla2('/variedad.php'));
      var rest7 = await http.post(
      url8,
      body: {
        'variedad':'1',
        'nomorderdesc': 'lopez'
      }
      ).timeout(const Duration(seconds: 8));
      print(rest7.body);
    if(rest7.statusCode == 200)
      {
      var resBody2 = jsonDecode(rest7.body);
      if(resBody2['success']== true)
      {
        for (int x=0; x<=resBody2["nomvariedad"].length; x=x+1){
          if(x==resBody2["nomvariedad"].length)
          {
            print('entro3');
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) {
                                              return Graficossegregacion();
                                            })), (route) => false);
          }
          nombres.add(resBody2["nomvariedad"][x]);
        }
        }
      else
      {
      }
      }
    }
    on TimeoutException catch(e)
    {
      print(e.message);
      Fluttertoast.showToast(msg: 'Se supero el tiempo maximo, porfavor reinicie la aplicacion, si el problema persiste contacte con administrador');
    }
    catch(errorMsg)
    {
      return("Error :: $errorMsg");
    }
}

  variedad2()async{
    try{
    var rest = await http.post(
     Uri.parse(EndPoints.generateEndPointsURLtabla3('/variedad.php'),),
      body: {
        'idcentral': lg.id_centrales[0],
        'idexportador': nuevoidexportador
      }
    ).timeout(const Duration(seconds: 8));
    print(rest.body);
    if(rest.statusCode == 200)
    {
      var resBody2 = jsonDecode(rest.body);
      if(resBody2['success']== true)
      {
        for (int x=0; x<resBody2["variedad"].length; x=x+1){
          if(x==resBody2["variedad"].length-1)
          {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) {
                                              return graficosegregacion0();
                                            })), (route) => false);
          }
          nombres.add(resBody2["variedad"][x]);
          id_nombres.add(resBody2["id"][x].toString());
        }
      }
    }
  }
  on TimeoutException catch(e)
    {
      print(e.message);
      Fluttertoast.showToast(msg: 'Se supero el tiempo maximo, porfavor reinicie la aplicacion, si el problema persiste contacte con administrador');
    }
  }

  cerrarsesion() async{
    var resultResponse = await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey[50],
        title: const Text('Cerrar sesión'),
        content: const Text('¿Quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () {Get.back(result: "Cerrar sesión");},
                child: const Text('Si', style: TextStyle(color: Colors.black),)),
          TextButton(
            onPressed: () {Get.back();},
              child: const Text('No', style: TextStyle(color: Colors.black),)),
          
                ],
                  ),
                );
        if(resultResponse=="Cerrar sesión")
        {
          fruta='Informe puntos críticos';
          lg.exportador=[];
          lg.centrales=[];
          preferencias.removeUserInfo().then((value){
            Get.off(const login());
            Fluttertoast.showToast(msg: "Hasta pronto");
            });
          }
  }      

  void tomarfoto()
  {
    if(_currentUser.user.IDEXPORTADOR==6)
    {
      foto='assets/images/logo_copefrut.png';
    }
    else if(_currentUser.user.IDEXPORTADOR==8)
    {
      foto='assets/images/logo_cherrygroup.png';
    }
    else if(_currentUser.user.IDEXPORTADOR==7)
    {
      foto='assets/images/logo_apefrut.png';
    }
    else if(_currentUser.user.IDEXPORTADOR==2)
    {
      foto='assets/images/logo_ddc.png';
    }
    else if(_currentUser.user.IDEXPORTADOR==26)
    {
      foto='assets/images/logo-dole.png';
    }
    else if(_currentUser.user.IDEXPORTADOR==17)
    {
      foto='assets/images/logo_frutland.png';
    }
    else if(_currentUser.user.IDEXPORTADOR==1)
    {
      foto='assets/images/logo_garces.png';
    }
    else if(_currentUser.user.IDEXPORTADOR==3)
    {
      foto='assets/images/logo_magna.png';
    }
    else if(_currentUser.user.IDEXPORTADOR==10)
    {
      foto='assets/images/logo_mallinko.png';
    }
    else if(_currentUser.user.IDEXPORTADOR==4)
    {
      foto='assets/images/logo_meyer.png';
    }
    else if(_currentUser.user.IDEXPORTADOR==18)
    {
      foto='assets/images/logo_olivar.jpg';
    }
    else if(_currentUser.user.IDEXPORTADOR==5)
    {
      foto='assets/images/logo_panagro.png';
    }
    else if(_currentUser.user.IDEXPORTADOR==9)
    {
      foto='assets/images/logo_t&t.png';
    }
  }

  void paginainicial()
  {
    if(especies.contains('1'))
    {
      setState(() {
        paginaactual=0;
      });
    }
    else if(especies.contains('10'))
    {
      setState(() {
        paginaactual=1;
      });
    }
    else if(especies.contains('2'))
    {
      setState(() {
        paginaactual=2;
      });
    }
    else if(especies.contains('9'))
    {
      setState(() {
        paginaactual=3;
      });
    }
    else if(especies.contains('6') )
    {
      setState(() {
        paginaactual=4;
      });
    }
    else if(especies.contains('7') )
    {
      setState(() {
        paginaactual=4;
      });
    }
    else if(especies.contains('8'))
    {
      setState(() {
        paginaactual=5;
      });
    }
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
              onPressed: () => SystemNavigator.pop(), 
              //return true when click on "Yes"
              child:const Text('Si'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
               //return false when click on "NO"
              child:const Text('No'),
            ),

            

          ],
        ),
      )??false; //if showDialouge had returned null, then return false
    }
    return GetBuilder(
      init: actual(),
      initState: (currentState)
      {
        remeberCurrentUser.getUserInfo();
      },
      builder: (controller)
      {
        return StreamBuilder<ConnectivityResult>(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, snapshot) {
            return Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                onTap: (indexs){
                  setState(() {
                    if(indexs == 0 && especies.contains('1')==true){//CEREZAS
                      paginaactual = indexs;
                      images =[
                        "assets/images/aucerezas.png",
                        "assets/images/torta.png",
                        "assets/images/tendencia.png",
                        "assets/images/segregacion.png"
                        
                      ];
                      selectedSpecies=0;
                      if(index2% images.length== 0)
                      {
                        fruta='Informe puntos críticos';
                        currentIndexs=0;
                      }
                      else if(index2% images.length== 1)
                      {
                        fruta='Ranking';
                        currentIndexs=1;
                      }
                      else if(index2% images.length== 2)
                      {
                        fruta='Tendencia';
                        currentIndexs=2;
                      }
                      else if(index2% images.length== 3)
                      {
                        fruta='Segregación';
                        currentIndexs=3;
                      }
                      
                    }
                    else if(indexs==4 && especies.contains('6')==true && especies.contains('7')!=true){//SOLO PERAS
                      paginaactual = indexs;
                      selectedSpecies=4;
                      images =[
                        "assets/images/pera.png"
                      ];
                      fruta='Informe puntos críticos';
                      if(index2% images.length== 0)
                      {
                        currentIndexs=0;
                      }
                    }
                    else if(indexs==4 && especies.contains('7')==true&& especies.contains('6')!=true){//SOLO MANZANAS
                      paginaactual = indexs;
                      selectedSpecies=4;
                      images =[
                        "assets/images/aumanzana.png"

                      ];
                      fruta='Informe puntos críticos';
                      if(index2% images.length== 0)
                      {
                        currentIndexs=0;
                      }
                    }
                    else if(indexs==4 && especies.contains('6')==true && especies.contains('7')==true){//SOLO PERAS Y MANZANAS
                      paginaactual = indexs;
                      selectedSpecies=4;
                      images =[
                        "assets/images/aumanzana.png",
                        "assets/images/pera.png"
                      ];
                      fruta='Informe puntos críticos';
                      if(index2% images.length== 0)
                      {
                        currentIndexs=0;
                      }
                      else if(index2% images.length== 1)
                      {
                        currentIndexs=0;
                      }
                    }
                    else if(indexs==2 && especies.contains('2')==true)//SOLO CAROZOS
                    {
                      paginaactual=indexs;
                      selectedSpecies=2;
                      images=[
                        "assets/images/aucarozos.png"
                      ];
                      fruta='Informe puntos críticos';
                      currentIndexs=0;
                    }
                    else if(indexs==1 && especies.contains('10')==true){//SOLO ARANDANOS
                      paginaactual = indexs;
                      selectedSpecies=1;
                      images =[
                        "assets/images/auarandanos.png"
                      ];
                      fruta='Informe puntos críticos';
                      currentIndexs=0;
                    }
                    else if(indexs==3 && especies.contains('9')==true){//SOLO KIWIS
                      paginaactual = indexs;
                      selectedSpecies=3;
                      images =[
                        "assets/images/aukiwis.png"
                      ];
                      fruta='Informe puntos críticos';
                      currentIndexs=0;
                    }
                    else if(indexs==5 && especies.contains('8')==true){//SOLO UVAS
                      paginaactual = indexs;
                      selectedSpecies=5;
                      images =[
                        "assets/images/auuvas.png"
                      ];
                      fruta='Informe puntos críticos';
                      currentIndexs=0;
                    }
                    else
                    {
                      selectedSpecies=0;
                      Fluttertoast.showToast(msg: 'No existe servicio asociado a la especie seleccionada');
                      
                    }
                  });
                },
                currentIndex: selectedSpecies,
                items:const  [
                  BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/cherry.png",),color: Colors.white,), label: 'Cerezas', backgroundColor: Color.fromRGBO(4, 43, 82, 1)),
                  BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/blueberry.png",),color: Colors.white,), label: 'Arandanos', backgroundColor: Color.fromRGBO(4, 43, 82, 1)),
                  BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/nectarina.png",),color: Colors.white,), label: 'Carozos', backgroundColor: Color.fromRGBO(4, 43, 82, 1)),
                  BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/kiwi.png",),color: Colors.white,), label: 'Kiwi', backgroundColor: Color.fromRGBO(4, 43, 82, 1)),
                  BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/manzana.png",),color: Colors.white,), label: 'Pomaceas', backgroundColor: Color.fromRGBO(4, 43, 82, 1)),
                  BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/uvas.png",),color: Colors.white,), label: 'Uvas', backgroundColor: Color.fromRGBO(4, 43, 82, 1)),
                ],),
              body: WillPopScope(
              onWillPop: showExitPopup,
              child: SafeArea(child: Scaffold(
                      resizeToAvoidBottomInset: true,
                      body: Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipPath(
                              clipper: MycustomClipper(),
                              child: Container(
                                  height: 150,
                                  width: double.infinity,
                                  color: const Color.fromRGBO(4, 43, 82, 1),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:<Widget>[
                                        Text('Bienvenido: ',
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      
                                    ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text(_currentUser.user.USUARIO, 
                                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
                                    SizedBox(height: 20,),
                                    Text('Seleccione una opción',
                                    style: TextStyle(fontSize: 15, color: Colors.white,),),
                                      ],
                                    ),),
                                ),
                            ),
                            const SizedBox(height: 5,),
                            
                              SizedBox(
                                height: 200,
                                width: MediaQuery.of(context).size.width-30,
                                child: PageView.builder(
                                  controller: PageController(viewportFraction: 0.8, initialPage: initialPage),
                                  onPageChanged: (index){
                                    setState(() {
                                      currentIndexs = index % images.length;
                                      index2=index;
                                      if(paginaactual==0)
                                      {
                                        if(currentIndexs==0)
                                        {
                                          fruta='Informe puntos críticos';
                                        }
                                        if(currentIndexs==1){
                                        
                                        fruta='Ranking';
                                        }
                                        else if(currentIndexs==2){
                                          fruta='Tendencia';
                                        }
                                        else if(currentIndexs==3)
                                        {
                                          fruta='Segregación';
                                        }
                                        
                                      }
                                      else
                                      {
                                        fruta='Informe puntos críticos';
                                      }
                                    });
                                  },
                            
                            // itemCount: images.length,
                            itemBuilder: (context, index){
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width-30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2
                                      )
                                    ),
                                    child: IconButton(
                                      icon: Transform.scale(
                                        scale: 1.0,
                                        child: Image.asset(images[index % images.length],
                                      fit: BoxFit.fitHeight)),
                                      onPressed: () async {
                                        var result = await Connectivity().checkConnectivity();
                                        if(result==ConnectivityResult.none)
                                        {
                                          showDialogBox();
                                        }
                                        else if(version==1)
                                        {
                                          showversion();
                                        }
                                        
                                        else
                                        {
                                          if(fruta=='Ranking'){
                                            showDialog(barrierDismissible: false,context: context, builder: (context){
                                              return const Center(child: CircularProgressIndicator(),);
                                            });
                                              info2('1', 1);
                                          }
                                          else if(fruta=='Tendencia'){
                                            print(lg.centrales);
                                            print(lg.id_centrales);
                                            showDialog(barrierDismissible: false,context: context, builder: (context){
                                              return const Center(child: CircularProgressIndicator(),);
                                            });
                                            info2('1', 2);
                                          }
                                          else if(fruta=='Segregación')
                                          {
                                            lg.centrales=[];
                                            lg.id_centrales=[];
                                            showDialog(barrierDismissible: false,context: context, builder: (context){
                                              return const Center(child: CircularProgressIndicator(),);
                                            });
                                            info2('2', 3);
                                          }
                                          else if(fruta=='Informe puntos críticos')
                                          {
                                            showDialog(barrierDismissible: false,context: context, builder: (context){
                                              return const Center(child: CircularProgressIndicator(),);
                                            });

                                              if(paginaactual==1)
                                              {
                                                infocentralxespecie('10');
                                              }
                                              else if(paginaactual==4 && especies.contains('6')==true)
                                              {
                                               infocentralxespecie('6');
                                              }
                                              else if(paginaactual==4 && especies.contains('7')==true)
                                              {
                                               infocentralxespecie('7');
                                              }
                                              else if(paginaactual==5)
                                              {
                                                infocentralxespecie('8');
                                              }
                                              else if(paginaactual==0)
                                              {
                                                infocentralxespecie('1');
                                              }
                                              else if(paginaactual==2)
                                              {
                                                infocentralxespecie('2');
                                              }
                                              else if(paginaactual==3)
                                              {
                                                infocentralxespecie('9');
                                              }
                                          }
                                        }
                                        },
                                    ),
                                  ),
                              );
                            }),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              for(var i = 0 ; i<images.length; i++) builIndicator(currentIndexs == i)
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(fruta, style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400
                                ),)
                              ],
                            ),),
                               const SizedBox(
                                height: 45,
                               ),
                               ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                elevation: MaterialStateProperty.all<double>(15.0),
                                fixedSize: MaterialStateProperty.all<Size>(const Size(280 , 50)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    side: const BorderSide(color: Colors.red),
                                  ),
                                )
                              ),
                              onPressed: () async {
                                cerrarsesion();
                              }, child: const Text('Cerrar sesión', 
                                  style: TextStyle(fontWeight: FontWeight.bold),),
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
              )),
              ),
            );
          }
        );
      },
    );
  }
  Widget builIndicator(bool isSelected){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Container(
        height: isSelected ? 12 : 8,
        width: isSelected ? 12 : 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected? Colors.black : Colors.grey,
        ),
      ),
    );
  }
}




