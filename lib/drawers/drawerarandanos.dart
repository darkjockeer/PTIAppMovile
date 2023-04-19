// ignore_for_file: unused_import, import_of_legacy_library_into_null_safe

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proyecto/graficos/Auditorias/cfrio.dart';
import 'package:proyecto/graficos/Auditorias/cpedicelo.dart';
import 'package:proyecto/graficos/Auditorias/crecepcion.dart';
import 'package:proyecto/graficos/Auditorias/ctemperatura.dart';
import 'package:proyecto/graficos/Auditorias/crecepcion.dart' as cr;
import 'package:proyecto/graficos/Auditorias/otros.dart';
import 'package:proyecto/graficos/Auditorias/sani.dart';
import 'package:proyecto/graficos/Ranking/Graficoss.dart' as gr;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:proyecto/users/loginuser/login.dart' as lg;
import 'package:proyecto/users/loginuser/eleccion.dart' as el;
import 'package:get/get.dart';
import 'package:proyecto/users/model/User.dart';
import 'package:proyecto/users/preferencias/actual.dart';
import 'package:proyecto/users/preferencias/preferencias.dart';
import 'package:proyecto/graficos/Tendencia/graficotendencia.dart' as gt;
import '../../api_connection/Endpoints/EndPoinst.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto/users/model/noti.dart';
import '../graficos/Auditorias/chidro.dart';
import '../users/loginuser/eleccion.dart';
import '../users/loginuser/login.dart';
import '../users/loginuser/nuevo.dart';
import '../users/loginuser/prueba.dart';
import 'package:proyecto/drawers/drawerauditoria.dart' as du;
bool isSelected=false;
bool grafico6=false;
bool loading=false;
double largo=0;
double hancho=0;
String valor5='TURNO 1', valor4='', valor6='', valor3='0', nombre='';
String valor='', valor2='';
String id='0';
String nuevoidexportador='';
List<String> categorias = ["1","2"];
List <String> nombres=[];
List <String> id_nombres=[];
List<String> fechas=[];
int idinformes=0;
String imageData='';
List <String> listim=[];
List <String> observaciones=[];
DateTime selectedDate = DateTime.now();
String num='0';
int especie=0;
class drawerarandanos extends StatefulWidget {
  static String id = 'Eleccion';

  const drawerarandanos({super.key});
  @override
  State<drawerarandanos> createState() => _drawerarandanos();
}
String fruta='Informe puntos críticos';
class _drawerarandanos extends State<drawerarandanos>{
  late File imageFile;
  @override
  void initState(){
    obtenerespecie();
    comprobar();
    valor=categorias[0];
    valor2=lg.centrales[0];
    valor6=lg.id_centrales[0];
    super.initState();
  }
  actual remeberCurrentUser = Get.put(actual());
  int currentIndexs=0;
  int paginaactual=0;
  late Uint8List imagen;

  final PageController controllers = PageController();
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
   

  @override
  Widget build(BuildContext context) {
    TextEditingController val = TextEditingController();
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
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: AppBar(
                  centerTitle: true,
                  title: Text('Informe puntos críticos'),
                  toolbarOpacity: 0.8,
                  toolbarHeight: 50.2,
                  elevation: 20.0,
                  backgroundColor: const Color.fromRGBO(4, 43, 82, 1),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_outlined),
                    onPressed: () 
                    {
                      el.nombres=[];
                      lg.exportador=[];
                      lg.centrales=[];
                      lg.id_centrales=[];
                      el.initialPage=996;
                      print(el.fruta);
                      Get.to(()=>Eleccion());
                    },
                  ),
                  systemOverlayStyle: SystemUiOverlayStyle.light,
                ),
              ),
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
                            SizedBox(
                              height: 25,
                            ),
                            Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width-20,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  const SizedBox(width: 10,),
                                  Expanded(
                                    child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height,
                                    decoration: const BoxDecoration(
                                      color: Colors.white
                                    ),
                                    child: Column(
                                      children: [
                                        const Text('Turno',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                        ),),
                                        DropdownButton(
                                          isExpanded: true,
                                          elevation: 10,
                                          borderRadius: BorderRadius.circular(10),
                                          style: TextStyle(fontSize: 12, color: Colors.black),
                                          value: valor,
                                          items: categorias.map((cate){
                                            return DropdownMenuItem(value: cate,child: 
                                            Center(child: Text(cate)), alignment: Alignment.center,
                                            );
                                          }).toList(),
                                          onChanged: (cate){
                                            print("You selected: $cate");
                                            valor=cate.toString();
                                            setState(() {
                                              if (cate.toString()=='1'){
                                                valor3='0';
                                                valor5='TURNO 1';
                                              }
                                              else if(cate.toString()=='2'){
                                                valor3='1';
                                                valor5='TURNO 2';
                                              }
                                            },);
                                          },
                                        ),
                                      ],
                                    ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  isSelected? Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: const BoxDecoration(
                            color: Colors.white
                          ),
                          child: Column(
                            children: [
                              const Text('Central',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),),
                              DropdownButton(
                                isExpanded: true,
                                elevation: 10,
                                borderRadius: BorderRadius.circular(10),
                                alignment: Alignment.center,
                                style: TextStyle(fontSize: 12, color: Colors.black),
                                value: valor2,
                                items: lg.centrales.map((country){
                                  return DropdownMenuItem(value: country,child: 
                                  Center(child: Text(country, textAlign: TextAlign.center,)),
                                  );
                                }).toList(),
                                onChanged: (country) async{
                                  setState(() {
                                    valor2=country.toString();
                                    el.nombres=el.nombres;
                                    for(int x=0;x<lg.id_centrales.length; x++)
                                    {
                                      if(lg.centrales[x]==country.toString())
                                      {
                                        valor6=lg.id_centrales[x];
                                        print(valor6);
                                      }
                                    }
                                  },);
                                }
                              ),
                            ],
                          ),
                        ),
                      ):Text(''),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height,
                                    decoration: const BoxDecoration(
                                      color: Colors.white
                                    ),
                                    child: Column(
                                      children: [
                                        const Text('Fecha',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                        ),),
                                        Container(
                                          height: 40,
                                          child: TextField(
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 12),
                                            controller: val,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              hintText: el.diaguardado
                                            ),
                                            onTap: () async {
                                              DateTime? pickedDate = await showDatePicker(
                                                context: context,
                                                locale: const Locale('es'),
                                                initialDate: selectedDate,
                                                firstDate: DateTime(2022), 
                                                lastDate: DateTime(2024)
                                                );
                                              if(pickedDate != null){
                                                fechas=[];
                                                String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                                                  val.text = ('$formattedDate');
                                                  selectedDate = pickedDate;
                                                  fechas.add(val.text);
                                                  el.diaguardado=val.text;
                                                  if(valor4=='')
                                                  {
                                                    valor4=lg.centrales[0];
                                                  }
                                              }
                                              else {
                                                Fluttertoast.showToast(msg: "Seleccione fecha"); 
                                              }  
                                            },  //set it true, so that user will not able to edit textonTap: () async
                                          ),
                                        ),
                                        Container(
                                          height: 35,
                                          color: Colors.transparent,
                                        ),
                                      ],
                                    ),
                                    ),
                                  ),
                                  
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                              Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width-10,
                                  color: Colors.transparent,
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipPath(
                                          clipper: Botoness(),
                                          child: Container(
                                            height: MediaQuery.of(context).size.height,
                                            width: MediaQuery.of(context).size.width-110,
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(4, 43, 82, 1),
                                            ),
                                            child: InkWell(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 15, right: 65),
                                                    child: grafico6? Text('Control recepción \n Linares', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)):
                                                    Text('Control recepción', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                                                  ),
                                                ],
                                              ),
                                              onTap: ()
                                              {
                                                if(fechas.length!=0)
                                                {
                                                  print(valor6);
                                                  if(valor6=='')
                                                  {
                                                    valor6=lg.id_centrales[0];
                                                    num='1';
                                                    idinforme();
                                                  }
                                                  else
                                                  {
                                                    print(lg.id_centrales);
                                                    num='1';
                                                    idinforme();
                                                  }
                                                }
                                                else
                                                {
                                                  Fluttertoast.showToast(msg: 'No se selecciono fecha');
                                                }
                                              }
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      grafico6? Expanded(
                                        child: ClipPath(
                                          clipper: Botoness(),
                                          child: Container(
                                            height: MediaQuery.of(context).size.height,
                                            width: MediaQuery.of(context).size.width-90,
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(4, 43, 82, 1),
                                            ),
                                            child: InkWell(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 15, right: 65),
                                                    child: Text('Control recepción \n Los Angeles', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                                                  ),
                                                ],
                                              ),
                                              onTap: ()
                                              {
                                                print(fechas);
                                                if(fechas.length!=0)
                                                {
                                                  print(valor6);
                                                  if(valor6=='')
                                                  {
                                                    valor6=lg.id_centrales[0];
                                                    num='2';
                                                    idinforme();
                                                  }
                                                  else
                                                  {
                                                    print(lg.id_centrales);
                                                    num='2';
                                                    idinforme();
                                                  }
                                                }
                                                else
                                                {
                                                  Fluttertoast.showToast(msg: 'No se selecciono fecha');
                                                }
                                              }
                                            ),
                                          ),
                                        ),
                                      ):Expanded(
                                        child: ClipPath(
                                          clipper: Botoness(),
                                          child: Container(
                                            height: MediaQuery.of(context).size.height,
                                            width: MediaQuery.of(context).size.width-90,
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(4, 43, 82, 1),
                                            ),
                                            child: InkWell(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 15, right: 65),
                                                    child: Text('Control temperaturas \n interplanta', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                                                  ),
                                                ],
                                              ),
                                              onTap: ()
                                              {
                                                if(fechas.length!=0)
                                                {
                                                  if(valor6=='')
                                                  {
                                                    valor6=lg.id_centrales[0];
                                                    num='3';
                                                    idinforme();
                                                  }
                                                  else
                                                  {
                                                    print(lg.id_centrales);
                                                    num='3';
                                                    idinforme();
                                                  }
                                                }
                                                else
                                                {
                                                  Fluttertoast.showToast(msg: 'No se selecciono fecha');
                                                }
                                              }
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Expanded(
                                        child: ClipPath(
                                          clipper: Botoness(),
                                          child: Container(
                                            height: MediaQuery.of(context).size.height,
                                            width: MediaQuery.of(context).size.width-70,
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(4, 43, 82, 1),
                                            ),
                                            child: InkWell(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 15, right: 65),
                                                    child: grafico6? Text('Control temperaturas \n interplanta', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)):
                                                    Text('Control cámaras de frio', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                                                  ),
                                                ],
                                              ),
                                              onTap: ()
                                              {
                                                if(fechas.length!=0)
                                                {
                                                  if(valor6=='')
                                                  {
                                                    valor6=lg.id_centrales[0];
                                                    num='3';
                                                    idinforme();
                                                  }
                                                  else
                                                  {
                                                    print(lg.id_centrales);
                                                    num='3';
                                                    idinforme();
                                                  }
                                                }
                                                else
                                                {
                                                  Fluttertoast.showToast(msg: 'No se selecciono fecha');
                                                }
                                              }
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Expanded(
                                        child: ClipPath(
                                          clipper: Botoness(),
                                          child: Container(
                                            height: MediaQuery.of(context).size.height,
                                            width: MediaQuery.of(context).size.width-50,
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(4, 43, 82, 1),
                                            ),
                                            child: InkWell(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 15, right: 65),
                                                    child: grafico6? Text('Control cámaras de frio', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)):
                                                    Text('Otros embalaje', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                                                  ),
                                                ],
                                              ),
                                              onTap: ()
                                              {
                                                if(fechas.length!=0)
                                                {
                                                  if(valor6=='')
                                                  {
                                                    valor6=lg.id_centrales[0];
                                                    num='4';
                                                    idinforme();
                                                  }
                                                  else
                                                  {
                                                    print(lg.id_centrales);
                                                    num='4';
                                                    idinforme();
                                                  }
                                                }
                                                else
                                                {
                                                  Fluttertoast.showToast(msg: 'No se selecciono fecha');
                                                }
                                              }
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      grafico6? Expanded(
                                        child: ClipPath(
                                          clipper: Botoness(),
                                          child: Container(
                                            height: MediaQuery.of(context).size.height,
                                            width: MediaQuery.of(context).size.width-30,
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(4, 43, 82, 1),
                                            ),
                                            child: InkWell(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 15, right: 65),
                                                    child: Text('Otros embalajes', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                                                  ),
                                                ],
                                              ),
                                              onTap: ()
                                              {
                                                if(fechas.length!=0)
                                                {
                                                  if(valor6=='')
                                                  {
                                                    valor6=lg.id_centrales[0];
                                                    num='5';
                                                    idinforme();
                                                  }
                                                  else
                                                  {
                                                    print(lg.id_centrales);
                                                    num='5';
                                                    idinforme();
                                                  }
                                                }
                                                else
                                                {
                                                  Fluttertoast.showToast(msg: 'No se selecciono fecha');
                                                }
                                              }
                                            ),
                                          ),
                                        ),
                                      ):Text(''),
                                      SizedBox(
                                        height: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                               const SizedBox(
                                height: 30,
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
                              onPressed:
                              () async {
                                var result = Connectivity().checkConnectivity();
                                if(result== ConnectivityResult.none)
                                {
                                  showDialogBox();
                                }
                                else
                                {
                                    setState(() {
                                    loading=true;
                                  });
                                    if(fechas.length !=0)
                                    {
                                      comprobacion();
                                    }
                                }
                              }, child: loading? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('Descargando...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),),
                                  CircularProgressIndicator(color: Colors.white,)
                                ],
                              ):
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.download, color: Colors.white,),
                                  SizedBox(width: 2),
                                  const Text('Descargar informe PDF', 
                                      style: TextStyle(fontWeight: FontWeight.bold),),
                                ],
                              ),
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
  void comprobar(){
    if(lg.centrales.length!=1)
    {
      isSelected=true;
    }
  }

  Future comprobacion()async{
    try{
      var rest = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLtabla4('/cerezas.php'),),
      body: {
        'fecha': fechas[0],
        'turno': valor5,
        'idcentral': valor6,
        'idespecie': '10',
      }
      ).timeout(const Duration(seconds: 10));
    if(rest.statusCode==200)
    {
      print(rest.body);
      var resBody2 = jsonDecode(rest.body);
      if(resBody2['success']== true)
      {
        constuructor();
      }
      else
      {
        setState(() {
          loading=false;
        });
        Fluttertoast.showToast(msg: 'No se encuentran registros disponibles en esta fecha');
      } 
    }
    }
    on TimeoutException catch(e)
    {
      Fluttertoast.showToast(msg: 'Se supero el tiempo de conexión');
    }
  }

  Future constuructor() async{
    Map<Permission, PermissionStatus> statuses = await [
                                  Permission.storage, 
                                  //add more permission to request here.
                                    ].request();
                                    if(statuses[Permission.storage]!.isGranted)
                                    {
                                      var dir = await DownloadsPathProvider.downloadsDirectory;
                                      if (dir != null)
                                      {
                                          String savename="Informe - $nombre - PTI - ${el.nombreidexportador} - ${valor2} - ${fechas[0]} - ${valor5}.pdf";
                                          String savePath = dir.path + "/$savename";
                                          print(savePath);

                                          try{
                                            await Dio().download(
                                              'https://controlcalidad.ptichile.com/puntocritico/views/arandanos/imprimir?turno=$valor3&fecha=${fechas[0]}&sp=10&idm=1&central=$valor6&exp=${el.nuevoidexportador}',
                                              savePath,
                                              onReceiveProgress: (received, total){
                                                if(total != -1){
                                                  print((received/total*100).toStringAsFixed(0)+"%");
                                                }
                                              }
                                              ).timeout(const Duration(seconds: 30));
                                              mostrarNotificacion();
                                              Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => PdfViewerPage()));
                                              print("File is saved to download folder");
                                          }
                                          on TimeoutException catch(e)
                                          {
                                            print(e.message);
                                            Fluttertoast.showToast(msg: 'Se supero el tiempo maximo');
                                          }
                                          on DioError catch(e)
                                          {
                                            print(e.message);
                                          }
                                      }
                                    }
  }

  Future idinforme() async{
    try
    {
      var rest = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLtabla4('/cerezas.php'),),
      body: {
        'fecha': fechas[0],
        'turno': valor5,
        'idcentral': valor6,
        'idespecie': '10',
      }
      );
    if(rest.statusCode == 200)
      {
      var resBody2 = jsonDecode(rest.body);
      if(resBody2['success']== true)
      {
          idinformes=int.parse(resBody2["iddata"]["idinforme"]);
          print(idinformes);
          Guardarinfo(idinformes);
      }
      else
      {
        Fluttertoast.showToast(msg: 'No se encontraron registros');
      }
      }
    }
    catch(errorMsg)
    {
      return("Error :: $errorMsg");
    }

  }

  Future Guardarinfo(int nums) async{
    try
    {
      var restS = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLtabla4('/informarandano.php'),),
      body: {
        'idinforme': nums.toString(),
        'num': num
      }
      ).timeout(const Duration(seconds: 10));
      print(restS.body);
    if(restS.statusCode == 200)
      {
      var resBody3 = jsonDecode(restS.body);
      if(resBody3['success']== true)
      {
        for(int x=0; x<resBody3['grafico'].length; x++)
        {
          if(x==resBody3['grafico'].length-1)
          {
            if(num=='1')
            {
              cr.nombres=['Recepción', 'Segregación \nMP', 'Segregación \nPTH'];
              cr.titulo='Control recepción Linares';
              Get.to(()=>crecepcion());
            }
             else if(num=='2')
            {
              cr.nombres=['Recepción', 'Segregación \nMP', 'Segregación \nPTH'];
              cr.titulo='Control recepción LA';
              Get.to(()=>crecepcion());
            }
            else if(num=='3')
            {
              Get.to(()=>ctemperatura());
            }
            else if(num=='4')
            {
              Get.to(()=>cfrio());
            }
            else if(num=='5')
            {
              Get.to(()=>otros());
            }
          }
          du.observaciones.add(resBody3['info'][x]);
          du.listim.add(resBody3['grafico'][x]);
        }
      }
      else
      {
        Fluttertoast.showToast(msg: 'No se encontraron registros');
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
      return("Error :: $errorMsg");
    }

  }

  showImage(String image){
    return Image.memory(base64Decode(image));
  }

  void obtenerespecie()
  {
    especie=10;
    if(el.nuevoidexportador=='6')
    {
      nombre='arandanos';
      grafico6=true;
    }
    else if(el.nuevoidexportador=='26')
    {
      nombre='arandanos';
      grafico6=false;
    }
  }
}

class PdfViewerPage extends StatefulWidget {
  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late File Pfile;
  bool isLoading = false;
  Future<void> loadNetwork() async {
    setState(() {
      isLoading = true;
    });
    try{
    var url = 'https://controlcalidad.ptichile.com/puntocritico/views/arandanos/imprimir?turno=$valor3&fecha=${fechas[0]}&sp=10&idm=1&central=$valor6&exp=${el.nuevoidexportador}';
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/archivo1');
    await file.writeAsBytes(bytes, flush: true).timeout(const Duration(seconds: 20));
    setState(() {
      Pfile = file;
    });

    print(Pfile);
    setState(() {
      isLoading = false;
    });
    }
    on TimeoutException catch(e)
    {
      print(e.message);
      Fluttertoast.showToast(msg: 'Se supero el tiempo maximo');
    }
  }

  @override
  void initState() {
    loadNetwork();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Vista previa PDF",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        toolbarOpacity: 0.8,
        toolbarHeight: 50.2,
        elevation: 20.0,
        backgroundColor: const Color.fromRGBO(4, 43, 82, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () 
          {
            setState(() {
              loading=false;
            });
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) {
                                              return drawerarandanos();
                                            })), (route) => false);
          },
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: Center(
                child: PDFView(
                  filePath: Pfile.path,
                ),
              ),
            ),
    );
  }
}