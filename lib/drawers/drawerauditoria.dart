// ignore_for_file: unused_import, import_of_legacy_library_into_null_safe
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:proyecto/graficos/Auditorias/cfrio.dart';
import 'package:proyecto/graficos/Auditorias/cfrio.dart' as cf;
import 'package:proyecto/graficos/Auditorias/cpedicelo.dart';
import 'package:proyecto/graficos/Auditorias/crecepcion.dart';
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
import '../graficos/Auditorias/chidro.dart';
import '../users/loginuser/eleccion.dart';
import '../users/loginuser/login.dart';
import '../users/loginuser/nuevo.dart';
import '../users/loginuser/prueba.dart';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proyecto/users/model/noti.dart';

String n = "D'";
bool isSelected = false,
    grafico6 = true,
    loading = false,
    grafico7 = false,
    grafico3 = false;
double largo = 0;
double hancho = 0;
String valor5 = 'TURNO 1', valor4 = '', valor6 = '', nombre = '';
String valor = '0', valor2 = '', valor3 = '0';
String id = '0';
String nuevoidexportador = '';
List<String> categorias = ["1", "2"];
List<String> nombres = [];
List<String> id_nombres = [];
List<String> fechas = [];
int idinformes = 0;
String imageData = '';
List<String> listim = [];
List<String> observaciones = [];
String diaguardado = 'Seleccione fecha';
DateTime selectedDate = DateTime.now();
String num = '0';
int especie = 0;
String progreso = '';
double percentaje = 0;

class drawerauditoria extends StatefulWidget {
  static String id = 'Eleccion';

  const drawerauditoria({super.key});
  @override
  State<drawerauditoria> createState() => _drawerauditoria();
}
String fruta = 'Informe puntos críticos';

class _drawerauditoria extends State<drawerauditoria> {
  final actual _currentUser = Get.put(actual());
  late File imageFile;
  String pathPDF = '';
  @override
  void initState() {
    obtenerespecie();
    comprobar();
    
    valor = categorias[0];
    valor2 = lg.centrales[0];
    valor6 = lg.id_centrales[0];
    super.initState();
  }

  actual remeberCurrentUser = Get.put(actual());
  late Uint8List imagen;

  final PageController controllers = PageController();
  showDialogBox() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) => CupertinoAlertDialog(
              title: const Text('No cuenta con internet'),
              content: const Text('Asegurese de tener una conexión a internet'),
              actions: [
                CupertinoButton.filled(
                    child: const Text('Reintentar'),
                    onPressed: () async {
                      Navigator.pop(context);
                      var result = await Connectivity().checkConnectivity();
                      if (result == ConnectivityResult.none) {
                        Navigator.of(context).pop;
                      } else {
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
      return await showDialog(
            //show confirm dialogue
            //the return value will be from "Yes" or "No" options
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Cerrar Aplicación'),
              content: const Text('¿Quieres salir de la aplicacion?'),
              actions: [
                ElevatedButton(
                  onPressed: () => SystemNavigator.pop(),
                  //return true when click on "Yes"
                  child: const Text('Si'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: const Text('No'),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    return GetBuilder(
      init: actual(),
      initState: (currentState) {
        remeberCurrentUser.getUserInfo();
      },
      builder: (controller) {
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
                      onPressed: () {
                        el.nombres = [];
                        lg.exportador = [];
                        lg.centrales = [];
                        lg.id_centrales = [];
                        el.currentIndexs = 0;
                        el.fruta = 'Informe puntos críticos';
                        Get.to(() => Eleccion());
                      },
                    ),
                    systemOverlayStyle: SystemUiOverlayStyle.light,
                  ),
                ),
                body: WillPopScope(
                  onWillPop: showExitPopup,
                  child: SafeArea(
                      child: Scaffold(
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
                                  width: MediaQuery.of(context).size.width - 20,
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          decoration: const BoxDecoration(
                                              color: Colors.white),
                                          child: Column(
                                            children: [
                                              const Text(
                                                'Turno',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              DropdownButton(
                                                isExpanded: true,
                                                elevation: 10,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black),
                                                value: valor,
                                                items: categorias.map((cate) {
                                                  return DropdownMenuItem(
                                                    value: cate,
                                                    child: Center(
                                                        child: Text(cate)),
                                                    alignment: Alignment.center,
                                                  );
                                                }).toList(),
                                                onChanged: (cate) {
                                                  print("You selected: $cate");
                                                  valor = cate.toString();
                                                  setState(
                                                    () {
                                                      if (cate.toString() ==
                                                          '1') {
                                                        valor3 = '0';
                                                        valor5 = 'TURNO 1';
                                                      } else if (cate
                                                              .toString() ==
                                                          '2') {
                                                        valor3 = '1';
                                                        valor5 = 'TURNO 2';
                                                      }
                                                    },
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      isSelected
                                          ? Expanded(
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    const Text(
                                                      'Central',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    DropdownButton(
                                                        isExpanded: true,
                                                        elevation: 10,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        alignment:
                                                            Alignment.center,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black),
                                                        value: valor2,
                                                        items: lg.centrales
                                                            .map((country) {
                                                          return DropdownMenuItem(
                                                            value: country,
                                                            child: Center(
                                                                child: Text(
                                                              country,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )),
                                                          );
                                                        }).toList(),
                                                        onChanged:
                                                            (country) async {
                                                          setState(
                                                            () {
                                                              valor2 = country
                                                                  .toString();
                                                              el.nombres =
                                                                  el.nombres;
                                                              for (int x = 0;
                                                                  x <
                                                                      lg.id_centrales
                                                                          .length;
                                                                  x++) {
                                                                if (lg.centrales[
                                                                        x] ==
                                                                    country
                                                                        .toString()) {
                                                                  valor6 =
                                                                      lg.id_centrales[
                                                                          x];
                                                                  print(valor6);
                                                                  break;
                                                                }
                                                              }
                                                            },
                                                          );
                                                        }),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Text(''),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          decoration: const BoxDecoration(
                                              color: Colors.white),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              const Text(
                                                'Fecha',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Container(
                                                height: 40,
                                                child: TextField(
                                                  expands: false,
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                  controller: val,
                                                  readOnly: true,
                                                  decoration: InputDecoration(
                                                    hintText: el.diaguardado,
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                      color: Colors.transparent,
                                                    )),
                                                  ),
                                                  onTap: () async {
                                                    DateTime? pickedDate =
                                                        await showDatePicker(
                                                            context: context,
                                                            locale:
                                                                const Locale(
                                                                    'es'),
                                                            initialDate:
                                                                selectedDate,
                                                            firstDate:
                                                                DateTime(2022),
                                                            lastDate:
                                                                DateTime(2024));
                                                    if (pickedDate != null) {
                                                      fechas = [];
                                                      String formattedDate =
                                                          DateFormat(
                                                                  'dd-MM-yyyy')
                                                              .format(
                                                                  pickedDate);
                                                      val.text =
                                                          ('$formattedDate');
                                                      selectedDate = pickedDate;
                                                      fechas.add(val.text);
                                                      el.diaguardado = val.text;
                                                      if (valor4 == '') {
                                                        valor4 =
                                                            lg.centrales[0];
                                                      }
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Seleccione fecha");
                                                    }
                                                  }, //set it true, so that user will not able to edit textonTap: () async
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
                                    width:
                                        MediaQuery.of(context).size.width - 10,
                                    color: Colors.transparent,
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: ClipPath(
                                            clipper: Botoness(),
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  110,
                                              decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    4, 43, 82, 1),
                                              ),
                                              child: InkWell(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 15,
                                                                right: 65),
                                                        child: Text(
                                                            'Control recepción',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                    ],
                                                  ),
                                                  onTap: () async {
                                                    var result =
                                                        await Connectivity()
                                                            .checkConnectivity();
                                                    if (result ==
                                                        ConnectivityResult
                                                            .none) {
                                                      showDialogBox();
                                                    } else {
                                                      if (fechas.length != 0) {
                                                        print(valor6);
                                                        if (valor6 == '') {
                                                          valor6 = lg
                                                              .id_centrales[0];
                                                          num = '1';
                                                          idinforme();
                                                        } else {
                                                          print(
                                                              lg.id_centrales);
                                                          num = '1';
                                                          idinforme();
                                                        }
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'No se selecciono fecha');
                                                      }
                                                    }
                                                  }),
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
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  90,
                                              decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    4, 43, 82, 1),
                                              ),
                                              child: InkWell(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 15,
                                                                  right: 65),
                                                          child: grafico6
                                                              ? Text(
                                                                  'Control hidroenfriado',
                                                                  style: TextStyle(
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))
                                                              : Text(
                                                                  'Control patio curado',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))),
                                                    ],
                                                  ),
                                                  onTap: () async {
                                                    var result =
                                                        await Connectivity()
                                                            .checkConnectivity();
                                                    if (result ==
                                                        ConnectivityResult
                                                            .none) {
                                                      showDialogBox();
                                                    } else {
                                                      if (fechas.length != 0) {
                                                        print(valor6);
                                                        if (valor6 == '') {
                                                          valor6 = lg
                                                              .id_centrales[0];
                                                          num = '2';
                                                          idinforme();
                                                        } else {
                                                          print(
                                                              lg.id_centrales);
                                                          num = '2';
                                                          idinforme();
                                                        }
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'No se selecciono fecha');
                                                      }
                                                    }
                                                  }),
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
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  70,
                                              decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    4, 43, 82, 1),
                                              ),
                                              child: InkWell(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 15,
                                                                right: 65),
                                                        child: Text(
                                                            'Control cámaras de frio',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                    ],
                                                  ),
                                                  onTap: () async {
                                                    var result =
                                                        await Connectivity()
                                                            .checkConnectivity();
                                                    if (result ==
                                                        ConnectivityResult
                                                            .none) {
                                                      showDialogBox();
                                                    } else {
                                                      if (fechas.length != 0) {
                                                        print(valor6);
                                                        if (valor6 == '') {
                                                          valor6 = lg
                                                              .id_centrales[0];
                                                          if (_currentUser.user
                                                                  .IDPERFIL ==
                                                              5) {
                                                            num = '3';
                                                            idinforme();
                                                          } else {
                                                            num = '4';
                                                            idinforme();
                                                          }
                                                        } else {
                                                          print(
                                                              lg.id_centrales);
                                                          if (_currentUser.user
                                                                  .IDPERFIL ==
                                                              5) {
                                                            num = '3';
                                                            idinforme();
                                                          } else {
                                                            num = '4';
                                                            idinforme();
                                                          }
                                                        }
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'No se selecciono fecha');
                                                      }
                                                    }
                                                  }),
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
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  50,
                                              decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    4, 43, 82, 1),
                                              ),
                                              child: InkWell(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 15,
                                                                  right: 65),
                                                          child: grafico6
                                                              ? Text(
                                                                  'Sanitización',
                                                                  style: TextStyle(
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))
                                                              : Text(
                                                                  'Sanitización de linea',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))),
                                                    ],
                                                  ),
                                                  onTap: () async {
                                                    var result =
                                                        await Connectivity()
                                                            .checkConnectivity();
                                                    if (result ==
                                                        ConnectivityResult
                                                            .none) {
                                                      showDialogBox();
                                                    } else {
                                                      if (fechas.length != 0) {
                                                        print(valor6);
                                                        if (valor6 == '') {
                                                          valor6 = lg
                                                              .id_centrales[0];
                                                          if (especie == 2) {
                                                            num = '5';
                                                            idinforme();
                                                          } else {
                                                            num = '4';
                                                            idinforme();
                                                          }
                                                        } else {
                                                          print(
                                                              lg.id_centrales);
                                                          if (especie == 2) {
                                                            num = '5';
                                                            idinforme();
                                                          } else {
                                                            num = '4';
                                                            idinforme();
                                                          }
                                                        }
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'No se selecciono fecha');
                                                      }
                                                    }
                                                  }),
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
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  30,
                                              decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    4, 43, 82, 1),
                                              ),
                                              child: InkWell(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 15,
                                                                right: 65),
                                                        child: Text(
                                                            'Otros embalajes',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                    ],
                                                  ),
                                                  onTap: () async {
                                                    var result =
                                                        await Connectivity()
                                                            .checkConnectivity();
                                                    if (result ==
                                                        ConnectivityResult
                                                            .none) {
                                                      showDialogBox();
                                                    } else {
                                                      if (fechas.length != 0) {
                                                        print(valor6);
                                                        if (valor6 == '') {
                                                          valor6 = lg
                                                              .id_centrales[0];
                                                          if (especie == 2) {
                                                            num = '6';
                                                            idinforme();
                                                          } else {
                                                            num = '5';
                                                            idinforme();
                                                          }
                                                        } else {
                                                          if (especie == 2) {
                                                            num = '6';
                                                            idinforme();
                                                          } else {
                                                            num = '5';
                                                            idinforme();
                                                          }
                                                        }
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'No se selecciono fecha');
                                                      }
                                                    }
                                                  }),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        grafico3
                                            ? Expanded(
                                                child: ClipPath(
                                                  clipper: Botoness(),
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            10,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromRGBO(
                                                              4, 43, 82, 1),
                                                    ),
                                                    child: InkWell(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            15,
                                                                        right:
                                                                            65),
                                                                child: grafico7
                                                                    ? Text(
                                                                        'Control pedicelo',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight: FontWeight
                                                                                .bold))
                                                                    : Text(
                                                                        'Cliente especifico',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold))),
                                                          ],
                                                        ),
                                                        onTap: () async {
                                                          var result =
                                                              await Connectivity()
                                                                  .checkConnectivity();
                                                          if (result ==
                                                              ConnectivityResult
                                                                  .none) {
                                                            showDialogBox();
                                                          } else {
                                                            if (fechas.length !=
                                                                0) {
                                                              print(valor6);
                                                              if (valor6 ==
                                                                  '') {
                                                                valor6 =
                                                                    lg.id_centrales[
                                                                        0];
                                                                if (especie ==
                                                                    2) {
                                                                  num = '7';
                                                                  idinforme();
                                                                } else {
                                                                  num = '6';
                                                                  idinforme();
                                                                }
                                                              } else {
                                                                if (especie ==
                                                                    2) {
                                                                  num = '7';
                                                                  idinforme();
                                                                } else {
                                                                  num = '6';
                                                                  idinforme();
                                                                }
                                                              }
                                                            } else {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'No se selecciono fecha');
                                                            }
                                                          }
                                                        }),
                                                  ),
                                                ),
                                              )
                                            : Text(''),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.red),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      elevation:
                                          MaterialStateProperty.all<double>(
                                              15.0),
                                      fixedSize:
                                          MaterialStateProperty.all<Size>(
                                              const Size(280, 50)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          side: const BorderSide(
                                              color: Colors.red),
                                        ),
                                      )),
                                  onPressed: () async {
                                    var result =
                                        Connectivity().checkConnectivity();
                                    if (result == ConnectivityResult.none) {
                                      showDialogBox();
                                    } else {
                                      if (fechas.length != 0) {
                                        setState(() {
                                          loading = true;
                                        });
                                        comprobacion();
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: 'Seleccione fecha');
                                      }
                                    }
                                  },
                                  child: loading
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Descargando',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.download,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 2),
                                            const Text(
                                              'Descargar informe PDF',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  child: Image.asset(
                                    'assets/images/logoo.png',
                                    width: MediaQuery.of(context).size.width,
                                    height: 100,
                                  ),
                                )
                              ],
                            ),
                          ))),
                ),
              );
            });
      },
    );
  }

  void comprobar() {
    if (lg.centrales.length != 1) {
      isSelected = true;
    }
  }

  Future comprobacion() async {
    try {
      var url2 =
          Uri.parse(EndPoints.generateEndPointsURLInformes('/informe.php'));
      var rest = await http.post(url2, body: {
        'fecha': fechas[0],
        'turno': valor5,
        'idcentral': valor6,
        'idespecie': especie.toString(),
      }).timeout(const Duration(seconds: 10));
      if (rest.statusCode == 200) {
        var resBody2 = jsonDecode(rest.body);
        if (resBody2['success'] == true) {
          constuructor();
        } else {
          setState(() {
            loading = false;
          });
          Fluttertoast.showToast(
              msg: 'No se encuentran registros disponibles en esta fecha');
        }
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: 'Se supero el tiempo de conexión');
    }
  }

  Future constuructor() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      //add more permission to request here.
    ].request();
    if (statuses[Permission.storage]!.isGranted) {
      var dir = await DownloadsPathProvider.downloadsDirectory;
      if (dir != null) {
        String savename =
            "Informe - $nombre - PTI - ${el.nombreidexportador} - ${valor2} - ${fechas[0]} - ${valor5}.pdf";
        String savePath = dir.path + "/$savename";
        print(savePath);

        try {
          await Dio().download(
              'https://controlcalidad.ptichile.com/puntocritico/views/$nombre/imprimir?turno=$valor3&fecha=${fechas[0]}&sp=$especie&idm=1&central=$valor6&exp=${el.nuevoidexportador} ',
              savePath, onReceiveProgress: (received, total) {
            var _percentage = received / total * 100;
            percentaje = _percentage / 100;
            setState(() {
              progreso = ('${_percentage.floor()} %');
            });
          }).timeout(
            const Duration(seconds: 60),
          );
          mostrarNotificacion();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PdfViewerPage()));
          print("Se ha descargado el PDF");
        } on TimeoutException catch (e) {
          print(e.message);
          Fluttertoast.showToast(
              msg:
                  'Se supero el tiempo de espera con el servidor, contacte a un administrador');
        } on DioError catch (e) {
          print(e.message);
        }
      }
    }
  }

  Future idinforme() async {
    try {
      var url1 =
          Uri.parse(EndPoints.generateEndPointsURLInformes('/informe.php'));
      var rest = await http.post(url1, body: {
        'fecha': fechas[0],
        'turno': valor5,
        'idcentral': valor6,
        'idespecie': especie.toString(),
      }).timeout(const Duration(seconds: 10));
      if (rest.statusCode == 200) {
        var resBody2 = jsonDecode(rest.body);
        if (resBody2['success'] == true) {
          idinformes = int.parse(resBody2["iddata"]["idinforme"]);
       
          if (especie == 1) {
            Guardarinfocerezas(idinformes);
          } else if (especie == 2) {
            Guardarinfocarozo(idinformes);
          } else if (especie == 9) {
            Guardarinfokiwi(idinformes);
          }
        } else {
          Fluttertoast.showToast(msg: 'No se encontraron registros');
        }
      }
    } on TimeoutException catch (e) {
      // print(e.message);
      Fluttertoast.showToast(msg: 'Se supero el tiempo de espera');
    } on Error catch (errorMsg) {
      return ("Error :: $errorMsg");
    }
  }

  Future Guardarinfocerezas(int nums) async {
    try {
      var restS = await http.post(
          Uri.parse(
            EndPoints.generateEndPointsURLcerezas('/informecerezas.php'),
          ),
          body: {
            'idinforme': nums.toString(),
            'num': num
          }).timeout(const Duration(seconds: 10));
      if (restS.statusCode == 200) {
        var resBody3 = jsonDecode(restS.body);
        if (resBody3['success'] == true) {
          for (int x = 0; x < resBody3['grafico'].length; x++) {
            if (x == resBody3['grafico'].length - 1) {
              if (num == '1') {
                cr.nombres = ['Recepción', 'Segregación', 'Grafico 3'];
                cr.titulo = 'Control recepción';
                Get.to(() => crecepcion());
              } else if (num == '2') {
                Get.to(() => chidro());
              } else if (num == '3') {
                Get.to(() => cfrio());
              } else if (num == '4') {
                Get.to(() => sani());
              } else if (num == '5') {
                Get.to(() => otros());
              } else if (num == '6') {
                Get.to(() => cpedicelo());
              }
            }
            // print(resBody3['info'][x]);
            observaciones.add(resBody3['info'][x]);
            listim.add(resBody3['grafico'][x]);
          }
        } else {
          Fluttertoast.showToast(msg: 'No se encontraron registros');
        }
      }
    } on TimeoutException catch (e) {
      // print(e.message);
      Fluttertoast.showToast(msg: 'Se supero el tiempo de espera');
    } catch (errorMsg) {
      return ("Error :: $errorMsg");
    }
  }

  Future Guardarinfocarozo(int nums) async {
    try {
      var restS = await http.post(
          Uri.parse(
            EndPoints.generateEndPointsURLcarozos('/informecarozos.php'),
          ),
          body: {
            'idinforme': nums.toString(),
            'num': num
          }).timeout(const Duration(seconds: 10));
      // print(restS.body);
      if (restS.statusCode == 200) {
        var resBody3 = jsonDecode(restS.body);
        if (resBody3['success'] == true) {
          for (int x = 0; x < resBody3['grafico'].length; x++) {
            if (x == resBody3['grafico'].length - 1) {
              if (num == '1') {
                cr.nombres = ['Recepción, Segregación', 'Grafico 3'];
                cr.titulo = 'Control recepción';
                Get.to(() => crecepcion());
              } else if (num == '2') {
                Get.to(() => chidro());
              } else if (num == '3' || num == '4') {
                Get.to(() => cfrio());
              } else if (num == '5') {
                Get.to(() => sani());
              } else if (num == '6') {
                Get.to(() => otros());
              } 
            }
            observaciones.add(resBody3['info'][x]);
            listim.add(resBody3['grafico'][x]);
          }
        } else {
          Fluttertoast.showToast(msg: 'No se encontraron registros');
        }
      }
    } on TimeoutException catch (e) {
      // print(e.message);
      Fluttertoast.showToast(msg: 'Se supero el tiempo maximo');
    } catch (errorMsg) {
      return ("Error :: $errorMsg");
    }
  }

  Future Guardarinfokiwi(int nums) async {
    try {
      var url = EndPoints.generateEndPointsURLkiwis('/informekiwi.php');
      print(url);
      var restS = await http.post(
         
          Uri.parse(
            url,
          ),
          body: {
            'idinforme': nums.toString(),
            'num': num
          }).timeout(const Duration(seconds: 10));
      
      if (restS.statusCode == 200) {
        print('ENTRO restS.statusCode');
        var resBody3 = jsonDecode(restS.body);
        if (resBody3['success'] == true) {
          for (int x = 0; x < resBody3['grafico'].length; x++) {
            if (x == resBody3['grafico'].length - 1) {
              if (num == '1') {
                print('ENTRO');
                cr.nombres = ['Recepción, Segregación', 'Grafico 3'];
                cr.titulo = 'Control recepción';
                Get.to(() => crecepcion());
              } else if (num == '2') {
                Get.to(() => chidro());
              } else if (num == '3') {
                Get.to(() => cfrio());
              } else if (num == '4') {
                Get.to(() => sani());
              } else if (num == '5') {
                Get.to(() => otros());
              } else if (num == '6') {
                Get.to(() => cpedicelo());
              }
            }
            // print(resBody3['info'][x]);
            observaciones.add(resBody3['info'][x]);
            listim.add(resBody3['grafico'][x]);
          }
        } else {
          Fluttertoast.showToast(msg: 'No se encontraron registros');
        }
      }
    } on TimeoutException catch (e) {
      // print(e.message);
      Fluttertoast.showToast(msg: 'Se supero el tiempo maximo');
    } catch (errorMsg) {
      return ("Error :: $errorMsg");
    }
  }

  showImage(String image) {
    return Image.memory(base64Decode(image));
  }

  void obtenerespecie() {
    if (el.paginaactual == 0) {
      nombre = 'cerezas';
      grafico3 = true;
      grafico7 = true;
      grafico6 = true;
      especie = 1;
    } else if (el.paginaactual == 2) {
      nombre = 'carozos';
      especie = 2;
      if (_currentUser.user.IDPERFIL == 7) {
        cf.nombre = ['Cámara caliente'];
        grafico6 = true;
        grafico7 = true;
        grafico3 = true;
      } else {
        cf.nombre = ['CEP {$n}Agen', 'CM {$n}Agen'];
        grafico6 = true;
        grafico7 = false;
        grafico3 = false;
      }
    } else if (el.paginaactual == 3) {
      nombre = 'kiwis';
      grafico3 = false;
      grafico7 = false;
      grafico6 = false;
      especie = 9;
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
    try {
      var url =
          'https://controlcalidad.ptichile.com/puntocritico/views/$nombre/imprimir?turno=$valor3&fecha=${fechas[0]}&sp=$especie&idm=1&central=$valor6&exp=${el.nuevoidexportador}';
      print(url);
      final response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;
      final dir = await getApplicationDocumentsDirectory();
      // print(response);
      // print(bytes);
      // print(dir);
      var file = File('${dir.path}/archivo1');
      await file
          .writeAsBytes(bytes, flush: true)
          .timeout(const Duration(seconds: 50));
      setState(() {
        Pfile = file;
      });

      // print(Pfile);
      setState(() {
        isLoading = false;
      });
    } on TimeoutException catch (e) {
      // print(e.message);
      Fluttertoast.showToast(msg: 'Error al crear la vista previa del pdf');
    } on Error catch (e) {
      // print(e);
    }
  }

  @override
  void initState() {
    loadNetwork();
    loading = false;
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
          onPressed: () {
            setState(() {
              loading = false;
            });
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: ((context) {
              return drawerauditoria();
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