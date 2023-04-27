// ignore: file_names
// ignore_for_file: unnecessary_null_comparison, avoid_print, non_constant_identifier_names, avoid_unnecessary_containers, import_of_legacy_library_into_null_safe, unused_import, unused_local_variable, unused_field

import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:proyecto/api_connection/Endpoints/EndPoinstCerezas.dart';
import 'package:proyecto/drawers/drawertendencia.dart' as dk;
import 'package:proyecto/graficos/Tendencia/graficotendencia2.dart';
import 'package:proyecto/users/loginuser/login.dart' as lg;
import 'package:flutter/material.dart';
import '../../drawers/drawertendencia.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:proyecto/users/loginuser/eleccion.dart' as el;
import '../../users/preferencias/actual.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
extension ColorExtension on String {
  toColor() {
    var hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
bool isSelected=false, siono=false, siocen=false;
String b1='';
List<String> largo=['1', '2', '3'];
String categoria='', comercial='';
String valor1='', valor2='frutaExportable', valor3='', valor='', valor4='', valor5='primeracategoria', valor6='', valor7='', central='';
var seen = <String>{};
List<String> uniquelist = lg.centrales.where((country) => seen.add(country)).toList();
List<double>Lineas=[];
List<double>Lineas2=[];
List<String> fechas=[];
List<String> categorias = ["1E","2E"];
var sen = <String>{};
List<String> Otra = categorias.where((cate) => sen.add(cate)).toList();

List<String> comerical = ["Fruta exportable","Real exportable"];
var sens = <String>{};
List<String> Otras = categorias.where((cates) => sen.add(cates)).toList();

var senss = <String>{};
List<String> Otras2 = lg.exportador.where((cates) => sen.add(cates)).toList();
int Lunes = 1;
int Martes = 2;
int Miercoles = 3;
int Jueves = 4;
int Viernes = 5;
int Sabado = 6;
int Domingo = 7;
List<String> prueba=[];
String l='', m='', mi='', j='', v='', s='', d='';
String idexport='';
String semana='';
DateTime selectedDate = DateTime.now();
late ZoomPanBehavior _zoomPanBehavior;
late TooltipBehavior _tooltipBehavior;
late ZoomPanBehavior _zoomPanBehavior2;
late TooltipBehavior _tooltipBehavior2;
class ChartData {
        ChartData({required this.x, required this.y0, required this.y1, required this.y2});
        final String x;
        final double y0;
        final double y1;
        final double y2;
}

class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<MultiSelect> createState() => _Multiselect();
}

class _Multiselect extends State<MultiSelect>{
  List<String> selected = [];


  void _itemchange(String itemValue, bool va)
  {
    setState(() {
      if(va)
      {
        if(contador<3)
        {
          selected.add(itemValue);
          contador=contador+1;
        }
        else
        {
          Fluttertoast.showToast(msg: "Solo puede seleccionar como maximo 3 lineas");
        }
      }
      else
      {
        selected.remove(itemValue);
        contador=contador-1;
      }
    }); 
  }

  void _cancel()
  {
    Navigator.pop(context);
  }

  void _submit()
  {
    if(contador==0)
    {
      Fluttertoast.showToast(msg: "Seleccione almenos 1 linea");
    }
    else
    {
      setState(() {
        largo=[];
        largo=selected;
      });
      print(largo);
      Navigator.pop(context, selected);
    }
  }

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: const Text('Selecione Lineas'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items.map((item) => CheckboxListTile(
            value: selected.contains(item),
            title: Text('Linea $item'),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (isChecked) => _itemchange(item, isChecked!),
            )).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel, 
          child: const Text('Cancelar'),
          ),
        ElevatedButton(
          onPressed: _submit, 
          child: const Text('Aceptar'),
          )  
      ],
    );
  }
}

class Graficoten extends StatefulWidget{
  const Graficoten({Key? key}): super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _GraficoTen createState () => _GraficoTen();
}

class _GraficoTen extends State<Graficoten> {
  final actual _currentUser = Get.put(actual());
  List<ColumnSeries<ChartData, String>>? series;
  List<ColumnSeries<ChartData, String>>? series2;
  List<ChartData>? chartData;
  List<ChartData>? chartData2;
  late int count;
  List<String> selected = [];
  
void _ShowMultiselected() async
{
  contador=0;
  final List<String>? results = await showDialog(context: context, 
  builder: (BuildContext context){
    return MultiSelect(items: largo);
  });

  if(results != null)
  {
    setState(() {
      selected= results;
    });
  }
}
    _dialogBuilder3() async {
      
    TextEditingController valors = TextEditingController();
         var result = Get.dialog(AlertDialog(
            title: Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: const Text('Sistema de filtros',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
                )
                ),
            content: StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 540,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: const BoxDecoration(
                            color: Colors.white
                          ),
                          child: Column(
                            children: [
                              const Text('Exportador',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),),
                              SizedBox(height: 5,),
                              siono? DropdownButton(
                                isExpanded: true,
                                elevation: 10,
                                borderRadius: BorderRadius.circular(10),
                                alignment: Alignment.center,
                                value: valor6,
                                items: lg.exportador.map((catess){
                                  return DropdownMenuItem(value: catess,child: 
                                  Center(child: Text(catess, textAlign: TextAlign.center,)),
                                  );
                                }).toList(),
                                onChanged: (catess) async {
                                  if(lg.exportador.length != 1)
                                  {
                                    print('aa');
                                    var resp = await http.post(
                                      Uri.parse(EndPoints.generateEndPointsURLInfoExportadores("/Exportadores.php")),
                                      body: {
                                        'nomexportador': catess.toString()
                                      },
                                    ); 
                                    if(resp.statusCode == 200)
                                    {
                                      lg.centrales=[];
                                      lg.id_centrales=[];
                                      var resBody = jsonDecode(resp.body);
                                      if(resBody['success2']== true)
                                      {
                                        setState(() {
                                          idexport=(resBody["userData2"][0]["IDEXPORTADOR"]);
                                          print(idexport);
                                        },);
                                      }
                                      else
                                      {
                                        Fluttertoast.showToast(msg: "error");
                                      }
                                    }
                                      var rests = await http.post(
                                        Uri.parse(EndPoints.generateEndPointsURLInfoExportadores("/ExportadoresxControlCaja.php")),
                                          body: {
                                            'idlogin' : lg.idlogin,
                                            'idperfil' : lg.idperfil,
                                            'idcentral': lg.idcentral,
                                            'idexportador' : idexport
                                          },
                                        );
                                        print(idexport);
                                        if(rests.statusCode == 200)
                                        {
                                          var resBody3 = jsonDecode(rests.body);
                                          if(resBody3['success3']== true)
                                          {
                                            for (int x=0; x<resBody3["userData3"].length; x=x+1)
                                            {
                                              lg.centrales.add(resBody3["userData3"][x]["NOMCENTRAL"]);
                                            }
                                          }
                                          else
                                          {
                                            lg.centrales.add(resBody3["userData3"][0]["NOMCENTRAL"]);
                                            lg.id_centrales.add(resBody3["userData3"][x]["IDCENTRAL"]);
                                          }
                                        }
                                      setState(() {
                                        comprobarcen();
                                          lg.centrales=lg.centrales;
                                          valor7=lg.centrales[0];
                                          print(lg.centrales);
                                          valor6=catess.toString();
                                    },);
                                  }
                                },
                              ):Text(el.nombreidexportador, style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
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
                              const Text('Central',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),),
                              SizedBox(height: 5,),
                              siocen? DropdownButton(
                                isExpanded: true,
                                iconEnabledColor: Colors.black,
                                alignment: Alignment.center,
                                value: valor7,
                                items: lg.centrales.map((country){
                                  return DropdownMenuItem(value: country,child: 
                                  Center(child: Text(country, textAlign: TextAlign.center,)),
                                  );
                                }).toList(),
                                onChanged: (country) async {

                                  setState(() {
                                    for(int x=0;x<lg.id_centrales.length; x++)
                                    {
                                      if(lg.centrales[x]==country.toString())
                                      {
                                        central=lg.id_centrales[x];
                                        valor7=country.toString();
                                        break;
                                      }
                                    }
                                    
                                    });
                                },
                              ):Text(lg.centrales[0], style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
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
                              const Text('Semana',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),),
                              SizedBox(height: 5,),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: el.diaguardado
                                ),
                                textAlign: TextAlign.center,
                                controller: valors,
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    locale: const Locale('es'),
                                    initialDate: selectedDate,
                                    firstDate: DateTime(2022), 
                                    lastDate: DateTime(2024)
                                    );
                                  if(pickedDate != null){
                                    largo=[];
                                    fechas=[];
                                    String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                                    EscogerFecha(pickedDate);
                                      int day = int.parse(DateFormat("D").format(pickedDate));
                                      int daysPerWeek = pickedDate.weekday;
                                      double semanas= (numOfdays(daysPerWeek)+day)/7;
                                      semana= semanas.truncate().toString();
                                      valors.text = ('$formattedDate:  Semana $semana');
                                      selectedDate=pickedDate;
                                      print(valor7);
                                      if(valor7=='')
                                      {
                                        valor7=lg.centrales[0];
                                        central=lg.id_centrales[0];
                                        nuevafecha(semana, central);
                                      }
                                      else
                                      {
                                        nuevafecha(semana, central);
                                      }
                                  }
                                  else {
                                    Fluttertoast.showToast(msg: "Seleccione fecha");                                  
                                  }  
                                }, //set it true, so that user will not able to edit textonTap: () async
                              )
                            ],
                          ),
                          ),
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
                          const Text('Lineas disponibles',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),),
                          SizedBox(height: 5,),
                          ElevatedButton(
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all<Size>(const Size(230 , 40)),
                            ),
                            onPressed:() =>
                              setState(() {
                                contador=0;
                                _ShowMultiselected();               
                              }),
                            child: Text('Ver lineas'),),
                        ],
                      ),
                    ),),
                        Expanded(
                          child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: const BoxDecoration(
                            color: Colors.white
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                elevation: MaterialStateProperty.all<double>(10.0),
                                fixedSize: MaterialStateProperty.all<Size>(const Size(180 , 50)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(color: Colors.black),
                                  )
                                )
                              ),
                              onPressed: (){
                                if (largo.length == 0){
                                      Fluttertoast.showToast(msg: "No se encontraron datos");
                                      largo=['1', '2', '3'];
                                      Get.off(const Graficoten());
                                    }
                                else
                                {
                                  if(valors.text.isNotEmpty==true && isSelected==false)
                                  {
                                    setState(() {
                                      isSelected=true;
                                      Lineas=[];
                                      Lineas2=[];
                                      series!.clear();
                                      series2!.clear();
                                      aa2();                           
                                    },);
                                  }
                                  else{
                                    setState(() {
                                      semana=el.diaguardado;
                                      isSelected=true;
                                      Lineas=[];
                                      Lineas2=[];
                                      series!.clear();
                                      series2!.clear();
                                      aa2();                           
                                    },);
                                        }
                                }
                              },
                              child: isSelected? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.search, color: Colors.black,),
                                  SizedBox(width: 2,),
                                  Text('Cargando...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),),
                                  CircularProgressIndicator(color: Colors.black,)
                                ],
                              ):Text('Filtrar',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),),)
                            ],
                          ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                          height: MediaQuery.of(context).size.height,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/logoo.png'),
                              fit: BoxFit.fitHeight,)
                          ),
                      ),
                        ),
                    ],
                  ),
                );
              }
            ),
          ));
  }
  
  _dialogBuilder() async{
    TextEditingController valors = TextEditingController();
        var resultResponse = await Get.dialog(
          AlertDialog(
            title: Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: const Text('Sistema de filtros',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
                )
                ),
            content: StatefulBuilder(builder: (BuildContext context, StateSetter setState){
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 500,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: const BoxDecoration(
                          color: Colors.white
                        ),
                        child: Column(
                          children: [
                            const Text('Exportador',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),),
                            siono? DropdownButton<String>(
                              isExpanded: true,
                              elevation: 10,
                              borderRadius: BorderRadius.circular(10),
                              alignment: Alignment.center,
                              value: valor6,
                              items: lg.exportador.map((catess){
                                return DropdownMenuItem(value: catess,child: 
                                Center(child: Text(catess, textAlign: TextAlign.center,)),
                                );
                              }).toList(),
                              onChanged: (catess) async{
                                  if(lg.exportador.length != 1)
                                  {
                                    print('aa');
                                    var resp = await http.post(
                                      Uri.parse(EndPoints.generateEndPointsURLInfoExportadores("/Exportadores.php")),
                                      body: {
                                        'nomexportador': catess.toString()
                                      },
                                    ); 
                                    if(resp.statusCode == 200)
                                    {
                                      lg.centrales=[];
                                      lg.id_centrales=[];
                                      var resBody = jsonDecode(resp.body);
                                      if(resBody['success2']== true)
                                      {
                                        idexport=(resBody["userData2"][0]["IDEXPORTADOR"]);
                                      }
                                      else
                                      {
                                        Fluttertoast.showToast(msg: "error");
                                      }
                                    }
                                      var rests = await http.post(
                                        Uri.parse(EndPoints.generateEndPointsURLInfoExportadores("/ExportadoresxControlCaja.php")),
                                          body: {
                                            'idlogin' : lg.idlogin,
                                            'idperfil' : lg.idperfil,
                                            'idcentral': lg.idcentral,
                                            'idexportador' : idexport
                                          },
                                        );
                                        print(rests.body);
                                        if(rests.statusCode == 200)
                                        {
                                          var resBody3 = jsonDecode(rests.body);
                                          if(resBody3['success3']== true)
                                          {
                                            for (int x=0; x<resBody3["userData3"].length; x=x+1)
                                            {
                                              lg.centrales.add(resBody3["userData3"][x]["NOMCENTRAL"]);
                                              lg.id_centrales.add(resBody3["userData3"][x]["IDCENTRAL"]);
                                            }
                                          }
                                          else
                                          {
                                            lg.centrales.add(resBody3["userData3"][0]["NOMCENTRAL"]);
                                          }
                                        }
                                      setState(() {
                                        comprobarcen();
                                          lg.centrales=lg.centrales;
                                          valor1=lg.centrales[0];
                                          print(lg.centrales);
                                          valor6=catess.toString();
                                    },);
                                  }
                                },
                            ):Text(el.nombreidexportador, style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
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
                            const Text('Central',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),),
                            siocen? DropdownButton(
                              isExpanded: true,
                              elevation: 10,
                              borderRadius: BorderRadius.circular(10),
                              alignment: Alignment.center,
                              value: valor1,
                              items: lg.centrales.map((country){
                                return DropdownMenuItem(value: country,child: 
                                Center(child: Text(country, textAlign: TextAlign.center,)),
                                );
                              }).toList(),
                              onChanged: (country) async {
                                    print("You selected: $country");
                                    setState((){
                                        for(int x=0;x<lg.id_centrales.length; x++)
                                      {
                                        if(lg.centrales[x]==country.toString())
                                        {
                                          central=lg.id_centrales[x];
                                          valor1=country.toString();
                                          break;
                                        }
                                      }
                                      },);
                                  
                              },
                            ):Text(lg.centrales[0], style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
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
                            const Text('Semana',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),),
                            TextField(
                              textAlign: TextAlign.center,
                              controller: valors,
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
                                  largo=[];
                                  String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                                  EscogerFecha(pickedDate);
                                      int day = int.parse(DateFormat("D").format(pickedDate));
                                      int daysPerWeek = pickedDate.weekday;
                                      double semanas= (numOfdays(daysPerWeek)+day)/7;
                                      semana= semanas.truncate().toString();
                                      valors.text = ('$formattedDate:  Semana $semana');
                                      selectedDate=pickedDate;
                                      if(valor1==lg.centrales[0])
                                      {
                                        central=lg.id_centrales[0];
                                        nuevafecha(semana, central);
                                      }
                                      else
                                      {
                                        nuevafecha(semana, central);
                                      }
                                }
                                else {
                                  Fluttertoast.showToast(msg: "Seleccione fecha"); 
                                }  
                              },  //set it true, so that user will not able to edit textonTap: () async
                            )
                          ],
                        ),
                    ),
                      ),
                      Expanded(
                          child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: Colors.white
                      ),
                      child: Column(
                        children: <Widget>[
                          const Text('Lineas disponibles',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),),
                          ElevatedButton(
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all<Size>(const Size(230 , 40)),
                            ),
                            onPressed:() =>
                              setState(() {
                                contador=0;
                                _ShowMultiselected();               
                              }),
                            child: Text('Ver lineas'),),
                        ],
                      ),
                    ),),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: const BoxDecoration(
                          color: Colors.white
                        ),
                        child: Column(
                          children: [
                            const Text('Comercial',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),),
                            DropdownButton(
                              isExpanded: true,
                              elevation: 10,
                              borderRadius: BorderRadius.circular(10),
                              alignment: Alignment.center,
                              value: comercial,
                              items: comerical.map((cates){
                                return DropdownMenuItem(value: cates,child: 
                                Center(child: Text(cates, textAlign: TextAlign.center,)),
                                );
                              }).toList(),
                              onChanged: (cates){
                                print("You selected: $cates");
                                setState(() {
                                    if (cates.toString()=='Fruta exportable'){
                                      valor2='frutaExportable';
                                    }
                                    else if(cates.toString()=='Real exportable'){
                                      valor2='realExportable';
                                    }
                                    comercial=cates.toString();
                                  },);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: const BoxDecoration(
                          color: Colors.white
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              elevation: MaterialStateProperty.all<double>(10.0),
                              fixedSize: MaterialStateProperty.all<Size>(const Size(180 , 50)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(color: Colors.black),
                                )
                              )
                            ),
                            onPressed: () {
                                if (largo.length == 0){
                                      Fluttertoast.showToast(msg: "No se encontraron datos");
                                      largo=['1', '2', '3'];
                                      Get.off(const Graficoten());
                                    }
                                else
                                {
                                  if(valors.text.isNotEmpty==true && isSelected==false)
                                  {
                                    setState(() {
                                      isSelected=true;
                                      Lineas=[];
                                      Lineas2=[];
                                      series!.clear();
                                      series2!.clear();
                                      aa1();                           
                                    },);
                                  }
                                  else{
                                          Fluttertoast.showToast(msg: "Faltan campos por rellenar o el boton ya fue presionado");
                                        }
                                }
                              },  
                            child: isSelected? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.search, color: Colors.black,),
                                  SizedBox(width: 2,),
                                  Text('Cargando...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),),
                                  CircularProgressIndicator(color: Colors.black,)
                                ],
                              ):Text('Filtrar',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),),)
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/logoo.png'),
                            fit: BoxFit.fitHeight,)
                        ),
                      ),
                    ),
                  ],
                ),
              );
              }
            ),),);
  }

_dialogBuilder2() async
      {
    TextEditingController val = TextEditingController();
    var resultResponse = await Get.dialog (AlertDialog(
            title: Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: const Text('Sistema de filtros',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
              )
              ),
            content:StatefulBuilder(builder: (BuildContext context, StateSetter setState){
               return  Container(
                  width: MediaQuery.of(context).size.width,
                  height: 500,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: const BoxDecoration(
                            color: Colors.white
                          ),
                          child: Column(
                            children: [
                              const Text('Exportador',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),),
                              siono? DropdownButton(
                                isExpanded: true,
                                elevation: 10,
                                borderRadius: BorderRadius.circular(10),
                                alignment: Alignment.center,
                                value: valor6,
                                items: lg.exportador.map((catess){
                                  return DropdownMenuItem(value: catess,child: 
                                  Center(child: Text(catess, textAlign: TextAlign.center,)),
                                  );
                                }).toList(),
                                onChanged: (catess) async {
                                  if(lg.exportador.length != 1)
                                  {
                                    print('aa');
                                    var resp = await http.post(
                                      Uri.parse(EndPoints.generateEndPointsURLInfoExportadores("/Exportadores.php")),
                                      body: {
                                        'nomexportador': catess.toString()
                                      },
                                    ); 
                                    print(resp.body);
                                    if(resp.statusCode == 200)
                                    {
                                      lg.centrales=[];
                                      var resBody = jsonDecode(resp.body);
                                      if(resBody['success1']== true)
                                      {
                                        idexport=(resBody["userData1"][0]["IDEXPORTADOR"]);
                                      }
                                      else
                                      {
                                        Fluttertoast.showToast(msg: "error");
                                      }
                                    }
                                    print(lg.idcentral);
                                      var rests = await http.post(
                                        Uri.parse(EndPoints.generateEndPointsURLInfoExportadores("/ExportadoresxControlCaja.php")),
                                          body: {
                                            'idlogin' : lg.idlogin,
                                            'idperfil' : lg.idperfil,
                                            'idcentral': lg.idcentral,
                                            'idexportador' : idexport
                                          },
                                        );
                                        if(rests.statusCode == 200)
                                        {
                                          lg.id_centrales=[];
                                          var resBody3 = jsonDecode(rests.body);
                                          if(resBody3['success1']== true)
                                          {
                                            for (int x=0; x<resBody3["userData1"].length; x=x+1)
                                            {
                                              lg.centrales.add(resBody3["userData1"][x]["NOMCENTRAL"]);
                                              lg.id_centrales.add(resBody3["userData1"][x]["IDCENTRAL"]);
                                            }
                                          }
                                          else
                                          {
                                            lg.centrales.add(resBody3["userData"][0]["NOMCENTRAL"]);
                                          }
                                        }
                                      print(lg.id_centrales);
                                      setState(() {
                                        comprobarcen();
                                          lg.centrales=lg.centrales;
                                          valor4=lg.centrales[0];
                                          print(lg.centrales);
                                          valor6=catess.toString();
                                    },);
                                  }
                                },
                              ):Text(el.nombreidexportador, style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
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
                              const Text('Central',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),),
                              siocen? DropdownButton(
                                isExpanded: true,
                                elevation: 10,
                                borderRadius: BorderRadius.circular(10),
                                alignment: Alignment.center,
                                value: valor4,
                                items: lg.centrales.map((country){
                                  return DropdownMenuItem(value: country,child: 
                                  Center(child: Text(country, textAlign: TextAlign.center,)),
                                  );
                                }).toList(),
                                onChanged: (country) async {
                                  print("You selected: $country");
                                    setState((){
                                      for(int x=0;x<lg.id_centrales.length; x++)
                                      {
                                        print(x);
                                        if(lg.centrales[x]==country.toString())
                                        {
                                          valor4=country.toString();
                                          print(valor4);
                                          central=lg.id_centrales[x];
                                          break;
                                        }
                                      }});
                                          
                                },
                              ):Text(lg.centrales[0], style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
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
                              const Text('Semana',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),),
                              TextField(
                                textAlign: TextAlign.center,
                                controller: val,
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: el.diaguardado
                                ),
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    locale: const Locale('es'),
                                    firstDate: DateTime(2022), 
                                    lastDate: DateTime(2024)
                                    );
                                  if(pickedDate != null){
                                    largo=[];
                                    fechas=[];
                                    String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                                    EscogerFecha(pickedDate);
                                      int day = int.parse(DateFormat("D").format(pickedDate));
                                      int daysPerWeek = pickedDate.weekday;
                                      double semanas= (numOfdays(daysPerWeek)+day)/7;
                                      semana= semanas.truncate().toString();
                                      val.text = ('$formattedDate:  Semana $semana');
                                      selectedDate=pickedDate;
                                      if(valor4==lg.centrales[0])
                                      {
                                        central=lg.id_centrales[0];
                                        nuevafecha(semana, central);
                                      }
                                      else
                                      {
                                        nuevafecha(semana, central);
                                      }
                                  }
                                  else {
                                    Fluttertoast.showToast(msg: "Seleccione fecha"); 
                                  }  
                                },  //set it true, so that user will not able to edit textonTap: () async
                              )
                            ],
                          ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: Colors.white
                      ),
                      child: Column(
                        children: [
                          const Text('Lineas disponibles',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),),
                          ElevatedButton(
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all<Size>(const Size(230 , 40)),
                            ),
                            onPressed:() =>
                              setState(() {
                                contador=0;
                                _ShowMultiselected();               
                              }),
                            child: Text('Ver lineas'),),
                        ],
                      ),
                    ),),
                        Expanded(
                          child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: const BoxDecoration(
                            color: Colors.white
                          ),
                          child: Column(
                            children: [
                              const Text('Categoria',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),),
                              DropdownButton(
                                isExpanded: true,
                                elevation: 10,
                                borderRadius: BorderRadius.circular(10),
                                alignment: Alignment.center,
                                value: categoria,
                                items: categorias.map((cate){
                                  return DropdownMenuItem(value: cate,child: 
                                  Center(child: Text(cate, textAlign: TextAlign.center,)),
                                  );
                                }).toList(),
                                onChanged: (cate){
                                  print("You selected: $cate");
                                  setState(() {
                                    if (cate.toString()=='1E'){
                                      valor5='primeracategoria';
                                    }
                                    else if(cate.toString()=='2E'){
                                      valor5='segundacategoria';
                                    }
                                    categoria=cate.toString();
                                  },);
                                },
                              ),
                            ],
                          ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: const BoxDecoration(
                            color: Colors.white
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                elevation: MaterialStateProperty.all<double>(10.0),
                                fixedSize: MaterialStateProperty.all<Size>(const Size(180 , 50)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(color: Colors.black),
                                  )
                                )
                              ),
                              onPressed: () {
                                if (largo.length == 0){
                                      Fluttertoast.showToast(msg: "No se encontraron datos");
                                      largo=['1', '2', '3'];
                                      Get.off(const Graficoten());
                                    }
                                else
                                {
                                  if(val.text.isNotEmpty==true && isSelected==false)
                                  {
                                    setState(() {
                                      isSelected=true;
                                      Lineas=[];
                                      Lineas2=[];
                                      series!.clear();
                                      series2!.clear();
                                      aa();                           
                                    },);
                                  }
                                  else{
                                    setState(() {
                                      semana=el.diaguardado;
                                      isSelected=true;
                                      Lineas=[];
                                      Lineas2=[];
                                      series!.clear();
                                      series2!.clear();
                                      aa2();                           
                                    },);
                                        }
                                }
                              },
                              child: isSelected? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.search, color: Colors.black,),
                                  SizedBox(width: 2,),
                                  Text('Cargando...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),),
                                  CircularProgressIndicator(color: Colors.black,)
                                ],
                              ):Text('Filtrar',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),),)
                            ],
                          ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                          height: MediaQuery.of(context).size.height,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/logoo.png'),
                              fit: BoxFit.fitHeight,)
                          ),
                      ),
                        ),
                    ],
                  ),
                );
      },
            ),
          ),);
  }
  ChartSeriesController? _chartSeriesController;
    @override
    void initState(){
      valor7=lg.centrales[0];
      valor4=lg.centrales[0];
      valor1=lg.centrales[0];
      central=lg.id_centrales[0];
      valor6=el.nombreidexportador;
      categoria='1E';
      comercial='Fruta exportable';
      count = 0;
      chartData = <ChartData>[
      ChartData(x:'Ejemplo' ,y0 :21, y1: 35, y2: 10),
    ];
    chartData2 = <ChartData>[
          ChartData(x:'Ejemplo' ,y0 :21, y1: 35, y2: 10),
    ];
      _tooltipBehavior = TooltipBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap);
     _zoomPanBehavior = ZoomPanBehavior(
                  enablePinching: true,
                  zoomMode: ZoomMode.x,
                  enablePanning: true
                );
      _tooltipBehavior2 = TooltipBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap);
     _zoomPanBehavior2 = ZoomPanBehavior(
                  enablePinching: true,
                  zoomMode: ZoomMode.x,
                  enablePanning: true
                );
    count = 0;
    series = <ColumnSeries<ChartData, String>>[
      ColumnSeries<ChartData, String>(
        dataSource: chartData!,
        width: 0.9,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y0,
      ),
      ColumnSeries<ChartData, String>(
        dataSource: <ChartData>[
          ChartData(x:'Ejemplo' ,y0 :21, y1: 35, y2: 10),
        ],
        width: 0.9,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y0,
      ),
    ]; 

    series2 = <ColumnSeries<ChartData, String>>[
      ColumnSeries<ChartData, String>(
        dataSource: chartData2!,
        width: 0.9,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y0,
      ),
      ColumnSeries<ChartData, String>(
        dataSource: <ChartData>[
          ChartData(x:'Ejemplo' ,y0 :21, y1: 35, y2: 10),
        ],
        width: 0.9,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y0,
      ),
    ]; 
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

 

  @override
  Widget build(BuildContext context){
    return Scaffold(
      drawer: const drawertendencia(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          centerTitle: true,
          title: Text(dk.name.toString()),
          backgroundColor: const Color.fromRGBO(4, 43, 82, 1),
          actions: <Widget>[
            IconButton(onPressed: () async{
              var result = Connectivity().checkConnectivity();
              print(lg.exportador);
              print(lg.centrales);
              if(result==ConnectivityResult.none)
              {
                showDialogBox();
              }
              else
              {
                if (dk.b==1){
                  if(_currentUser.user.IDLOGIN==0 && _currentUser.user.IDPERFIL==0)
                  {
                    _currentUser.user.IDLOGIN=int.parse(lg.idlogin);
                    _currentUser.user.IDPERFIL=int.parse(lg.idperfil);
                  }
                  comprobarexp();
                  comprobarcen();
                  isSelected=false;
                  _dialogBuilder();
                }
                else if(dk.b==2){
                  if(_currentUser.user.IDLOGIN==0 && _currentUser.user.IDPERFIL==0)
                  {
                    _currentUser.user.IDLOGIN=int.parse(lg.idlogin);
                    _currentUser.user.IDPERFIL=int.parse(lg.idperfil);
                  }
                  comprobarexp();
                  comprobarcen();
                  isSelected=false;
                  print(valor4);
                  _dialogBuilder2();
                }
                else if(dk.b==4){
                  if(_currentUser.user.IDLOGIN==0 && _currentUser.user.IDPERFIL==0)
                  {
                    _currentUser.user.IDLOGIN=int.parse(lg.idlogin);
                    _currentUser.user.IDPERFIL=int.parse(lg.idperfil);
                  }
                  comprobarexp();
                  comprobarcen();
                  isSelected=false;
                  _dialogBuilder3();
                }
                else if (dk.b==3){
                  Fluttertoast.showToast(msg: "No ah seleccionado grafico. \n Porfavor vuelva a intentarlo");
                }
              }
            }, icon: const Icon(Icons.filter_list_alt))
          ],
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(4, 43, 82, 1)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,),
              Expanded(child: Container(
                width: MediaQuery.of(context).size.width-30,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40), bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
                ),
                child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: SfCartesianChart(
      legend: Legend(isVisible: true, position: LegendPosition.bottom, borderColor: Colors.black, borderWidth: 2),
      title: ChartTitle(
            text: 'Turno 1',
            backgroundColor: Colors.white,
            alignment: ChartAlignment.center,
            textStyle: const TextStyle(color: Colors.black, fontFamily: 'Roboto', fontStyle: FontStyle.italic, fontSize: 12)
          ),
          zoomPanBehavior: _zoomPanBehavior,
            enableAxisAnimation: true,
            margin: const EdgeInsets.all(5),
            plotAreaBorderWidth: 2,
            tooltipBehavior: _tooltipBehavior,
            primaryYAxis: NumericAxis(
            maximum: 100,
            interval: 20
          ),
          primaryXAxis: CategoryAxis(
            labelRotation: 70,
            labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10
            )                           
          ),
          enableSideBySideSeriesPlacement: true,
          annotations: <CartesianChartAnnotation>[
            CartesianChartAnnotation(
              widget: Container(
                child: const Text('%',style: TextStyle(
                  fontSize:9, fontWeight: FontWeight.bold
                ),),
              ),
            coordinateUnit: CoordinateUnit.point,
            x: -1.1,
            y: 50,
          ),
        ],
          series: series,)
          ),),),
                const SizedBox(
                height: 10,
                child: Divider(
                color: Color.fromRGBO(0, 0, 0, 1),
                height: 10,
                thickness: 3,
                indent: 15,
                endIndent: 15,
              ),
              ),
              Expanded(child: Container(
                width: MediaQuery.of(context).size.width-30,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40), bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
                ),
                child:  SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: SfCartesianChart(
      legend: Legend(isVisible: true, position: LegendPosition.bottom, borderColor: Colors.black, borderWidth: 2),
      title: ChartTitle(
        text: 'Turno 2',
        backgroundColor: Colors.white,
        alignment: ChartAlignment.center,
        textStyle: const TextStyle(color: Colors.black, fontFamily: 'Roboto', fontStyle: FontStyle.italic, fontSize: 12)
      ),
      zoomPanBehavior: _zoomPanBehavior2,
        enableAxisAnimation: true,
        margin: const EdgeInsets.all(5),
        plotAreaBorderWidth: 2,
        tooltipBehavior: _tooltipBehavior2,
        primaryYAxis: NumericAxis(
        maximum: 100,
        interval: 20
      ),
      primaryXAxis: CategoryAxis(
        labelRotation: 70,
        labelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 10
        )                           
      ),
      enableSideBySideSeriesPlacement: true,
      annotations: <CartesianChartAnnotation>[
        CartesianChartAnnotation(
          widget: Container(
            child: const Text('%',style: TextStyle(
              fontSize:9, fontWeight: FontWeight.bold
            ),),
          ),
        coordinateUnit: CoordinateUnit.point,
        x: -1.1,
        y: 50,
      ),
    ],
      series: series2,
    )
                            ),),),
              const SizedBox(
                height: 5,),
              Container(
                width: MediaQuery.of(context).size.width-30,
                height: 20,
                color: Colors.transparent,
              )
            ],
          ),
        )
      ),
    );
}
  ///Remove the series from chart
  void comprobarcen(){
    if(_currentUser.user.IDPERFIL == 1 || _currentUser.user.IDPERFIL == 5 || _currentUser.user.IDPERFIL == 6 ||_currentUser.user.IDLOGIN== 31 || _currentUser.user.IDPERFIL == 4 )
    {
      if(_currentUser.user.IDLOGIN == 29 || _currentUser.user.IDLOGIN == 46 || _currentUser.user.IDLOGIN == 74  || _currentUser.user.IDPERFIL == 4 )
			{
				siocen=false;
			}
	    else
			{
				siocen=true;
			} 
    }
    else
    {
      siocen=false;
    }
  }
  
  void comprobarexp(){
    if(_currentUser.user.IDLOGIN==125 || _currentUser.user.IDLOGIN==190 || _currentUser.user.IDPERFIL==1)
    {
      siono=true;
    }
    else{
      siono=false;
    }
  }

  void _addSeries() {
    final List<ChartData> chartData1 = <ChartData>[];
    final List<ChartData> chartData2 = <ChartData>[];
    print(largo.length);
    if(largo.length==3)
    {
      chartData1.add(ChartData(x:l ,y0 :Lineas[0] , y1: Lineas[7],  y2: Lineas[14]));
      chartData1.add(ChartData(x:m, y0:Lineas[1], y1: Lineas[8],  y2: Lineas[15]));
      chartData1.add(ChartData(x:mi, y0:Lineas[2], y1: Lineas[9], y2: Lineas[16]));
      chartData1.add(ChartData(x:j, y0:Lineas[3], y1: Lineas[10], y2: Lineas[17]));
      chartData1.add(ChartData(x: v, y0:Lineas[4], y1: Lineas[11], y2: Lineas[18]));
      chartData1.add(ChartData(x:s, y0:Lineas[5], y1: Lineas[12], y2: Lineas[19]));
      chartData1.add(ChartData(x:d, y0:Lineas[6], y1: Lineas[13], y2: Lineas[20]));

      chartData2.add(ChartData(x:l ,y0 :Lineas2[0] , y1: Lineas2[7],  y2: Lineas2[14]));
      chartData2.add(ChartData(x:m, y0:Lineas2[1], y1: Lineas2[8],  y2: Lineas2[15]));
      chartData2.add(ChartData(x:mi, y0:Lineas2[2], y1: Lineas2[9], y2: Lineas2[16]));
      chartData2.add(ChartData(x:j, y0:Lineas2[3], y1: Lineas2[10], y2: Lineas2[17]));
      chartData2.add(ChartData(x: v, y0:Lineas2[4], y1: Lineas2[11], y2: Lineas2[18]));
      chartData2.add(ChartData(x:s, y0:Lineas2[5], y1: Lineas2[12], y2: Lineas2[19]));
      chartData2.add(ChartData(x:d, y0:Lineas2[6], y1: Lineas2[13], y2: Lineas2[20]));
    }
    else if(largo.length==2)
    {
      chartData1.add(ChartData(x:l ,y0 :Lineas[0] , y1: Lineas[7],  y2: 0));
      chartData1.add(ChartData(x:m, y0:Lineas[1], y1: Lineas[8],  y2: 0));
      chartData1.add(ChartData(x:mi, y0:Lineas[2], y1: Lineas[9], y2: 0));
      chartData1.add(ChartData(x:j, y0:Lineas[3], y1: Lineas[10], y2: 0));
      chartData1.add(ChartData(x: v, y0:Lineas[4], y1: Lineas[11], y2: 0));
      chartData1.add(ChartData(x:s, y0:Lineas[5], y1: Lineas[12], y2: 0));
      chartData1.add(ChartData(x:d, y0:Lineas[6], y1: Lineas[13], y2: 0));

      chartData2.add(ChartData(x:l ,y0 :Lineas2[0] , y1: Lineas2[7],  y2: 0));
      chartData2.add(ChartData(x:m, y0:Lineas2[1], y1: Lineas2[8],  y2: 0));
      chartData2.add(ChartData(x:mi, y0:Lineas2[2], y1: Lineas2[9], y2: 0));
      chartData2.add(ChartData(x:j, y0:Lineas2[3], y1: Lineas2[10], y2: 0));
      chartData2.add(ChartData(x: v, y0:Lineas2[4], y1: Lineas2[11], y2: 0));
      chartData2.add(ChartData(x:s, y0:Lineas2[5], y1: Lineas2[12], y2: 0));
      chartData2.add(ChartData(x:d, y0:Lineas2[6], y1: Lineas2[13], y2: 0));
    }
    else if(largo.length==1)
    {
      chartData1.add(ChartData(x:l ,y0 :Lineas[0] , y1: 0,  y2: 0));
      chartData1.add(ChartData(x:m, y0:Lineas[1], y1: 0,  y2: 0));
      chartData1.add(ChartData(x:mi, y0:Lineas[2], y1: 0, y2: 0));
      chartData1.add(ChartData(x:j, y0:Lineas[3], y1: 0, y2: 0));
      chartData1.add(ChartData(x: v, y0:Lineas[4], y1: 0, y2: 0));
      chartData1.add(ChartData(x:s, y0:Lineas[5], y1: 0, y2: 0));
      chartData1.add(ChartData(x:d, y0:Lineas[6], y1: 0, y2: 0));

      chartData2.add(ChartData(x:l ,y0 :Lineas2[0] , y1: 0,  y2: 0));
      chartData2.add(ChartData(x:m, y0:Lineas2[1], y1: 0,  y2: 0));
      chartData2.add(ChartData(x:mi, y0:Lineas2[2], y1: 0, y2: 0));
      chartData2.add(ChartData(x:j, y0:Lineas2[3], y1: 0, y2: 0));
      chartData2.add(ChartData(x: v, y0:Lineas2[4], y1: 0, y2: 0));
      chartData2.add(ChartData(x:s, y0:Lineas2[5], y1: 0, y2: 0));
      chartData2.add(ChartData(x:d, y0:Lineas2[6], y1: 0, y2: 0));
    }
      
    for(int x=0; x<largo.length; x++)
    {
      if(x==0)
      {
        series!.add(ColumnSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        animationDuration: 1500, animationDelay: 1500 , color: ('FE2C2C'.toColor()) ,name: 'Linea ${largo[0]}',dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))
        ,spacing:0.2 ,width:0.9, dataSource: chartData1, xValueMapper: (ChartData data, _) => data.x, yValueMapper: (ChartData data, _)=>data.y0,
        ));
        series2!.add(ColumnSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        animationDuration: 1500, animationDelay: 1500 , color: ('FE2C2C'.toColor()) ,name: 'Linea ${largo[0]}',dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))
        ,spacing:0.2 ,width:0.9, dataSource: chartData2, xValueMapper: (ChartData data, _) => data.x, yValueMapper: (ChartData data, _)=>data.y0,
        ));
      }
      else if(x==1)
      {
        series!.add(ColumnSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        animationDuration: 1500, animationDelay: 1500 , color: ('AB0303'.toColor()) ,name: 'Linea ${largo[1]}',dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))
        ,spacing:0.2 ,width:0.9, dataSource: chartData1, xValueMapper: (ChartData data, _) => data.x, yValueMapper: (ChartData data, _)=>data.y1,
        ));
        series2!.add(ColumnSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        animationDuration: 1500, animationDelay: 1500 , color: ('AB0303'.toColor()) ,name: 'Linea ${largo[1]}',dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))
        ,spacing:0.2 ,width:0.9, dataSource: chartData2, xValueMapper: (ChartData data, _) => data.x, yValueMapper: (ChartData data, _)=>data.y1,
        ));
      }
      else if(x==2)
      {
        series!.add(ColumnSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        animationDuration: 1500, animationDelay: 1500 , color: ('DA0202'.toColor()) ,name: 'Linea ${largo[2]}',dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))
        ,spacing:0.2 ,width:0.9, dataSource: chartData1, xValueMapper: (ChartData data, _) => data.x, yValueMapper: (ChartData data, _)=>data.y2,
        ));
        series2!.add(ColumnSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        animationDuration: 1500, animationDelay: 1500 , color: ('DA0202'.toColor()) ,name: 'Linea ${largo[2]}',dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10))
        ,spacing:0.2 ,width:0.9, dataSource: chartData2, xValueMapper: (ChartData data, _) => data.x, yValueMapper: (ChartData data, _)=>data.y2,
        ));
      }
      isSelected=false;
      Get.back();
    }  
    count++;
    if (count == 8) {
      count = 0;
    }
  }

  Future aa () async{
    try{
  for(int x=0; x<largo.length; x++){
    for(int i=0; i<fechas.length; i++){
      {var restssrs = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLtabla("/graficoprueba.php")),
      body: {
        'categoriacaja' : valor5,
        'nomlinea': largo[x],
        'idcentral': central,
        'date': fechas[i]
        },
      ).timeout(const Duration(seconds: 10));
      if(restssrs.statusCode == 200)
      {
      var resBody5 = jsonDecode(restssrs.body);
      if(resBody5['success']== true)
      {
          Lineas.add(double.parse(resBody5["Dato"]));
      }
    else{
        Lineas.add(double.parse(resBody5["Dato"]));
    }
      }
      else
      {
        Fluttertoast.showToast(msg: 'Error con el servidor');
        largo=['1', '2', '3'];
        Get.off(()=> Graficoten());
      }
  } 
    }
  }
  bb(); 
    }
    on TimeoutException catch(e)
    {
      print(e.message);
      Fluttertoast.showToast(msg: 'Se supero el tiempo maximo');
    }
}

  Future bb () async{
    try{
  for(int x=0; x<largo.length; x++){
    for(int i=0; i<fechas.length; i++){
      {var restssrs = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLtabla("/graficoprueba2.php")),
      body: {
        'categoriacaja' : valor5,
        'nomlinea': largo[x],
        'idcentral': central,
        'date': fechas[i]
        },
      ).timeout(const Duration(seconds: 10));
      if(restssrs.statusCode == 200)
      {
      var resBody5 = jsonDecode(restssrs.body);
      if(resBody5['success']== true)
      {
          Lineas2.add(double.parse(resBody5["Dato"]));
      }
    else{
        Lineas2.add(double.parse(resBody5["Dato"]));
    }
      }
  } 
    }
  }
  setState(() {
        _addSeries();
      });
    }
    on TimeoutException catch(e)
    {
      print(e.message);
      Fluttertoast.showToast(msg: 'Se supero el tiempo maximo');
    }
}

  Future aa1 () async{
    try{
  for(int x=0; x<largo.length; x++){
    for(int i=0; i<fechas.length; i++){
      {var rest2 = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLtabla("/graficocomercial.php")),
      body: {
        'categoriacomercial' : valor2,
        'nomlinea': largo[x],
        'idcentral': central,
        'date': fechas[i]
        },
      ).timeout(const Duration(seconds: 10));
      print(rest2.body);
      if(rest2.statusCode == 200)
      {
      var resBody5 = jsonDecode(rest2.body);
      if(resBody5['success']== true)
      {
          Lineas.add(double.parse(resBody5["Dato"]));
      }
    else{
        Lineas.add(double.parse(resBody5["Dato"]));
    }
      }
      else
      {
        Fluttertoast.showToast(msg: 'Error con el servidor');
        largo=['1', '2', '3'];
        Get.off(()=> Graficoten());
      }
  } 
    }
  }
  bb1();
    }
    on TimeoutException catch(e)
    {
      print(e.message);
      Fluttertoast.showToast(msg: 'Se supero el tiempo maximo');
    }
}

  Future bb1 () async{
    try{
  for(int x=0; x<largo.length; x++){
    for(int i=0; i<fechas.length; i++){
      {var rest3 = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLtabla("/graficocomercial2.php")),
      body: {
        'categoriacomercial' : valor2,
        'nomlinea': largo[x],
        'idcentral': central,
        'date': fechas[i]
        },
      ).timeout(const Duration(seconds: 10));
      if(rest3.statusCode == 200)
      {
      var resBody5 = jsonDecode(rest3.body);
      if(resBody5['success']== true)
      {
          Lineas2.add(double.parse(resBody5["Dato"]));
      }
    else{
        Lineas2.add(double.parse(resBody5["Dato"]));
    }
      }
  } 
    }
  }
  setState(() {
        _addSeries();
      });
    }on TimeoutException catch(e)
    {
      print(e.message);
      Fluttertoast.showToast(msg: 'Se supero el tiempo maximo');
    }
}

  Future aa2 () async{
    try{
  for(int x=0; x<largo.length; x++){
    for(int i=0; i<fechas.length; i++){
      {var rest2 = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLtabla("/retorno1.php")),
      body: {
        'nomlinea': largo[x],
        'idcentral': central,
        'date': fechas[i]
        },
      ).timeout(const Duration(seconds: 10));
      if(rest2.statusCode == 200)
      {
      var resBody5 = jsonDecode(rest2.body);
      if(resBody5['success']== true)
      {
          Lineas.add(double.parse(resBody5["Dato"]));
      }
    else{
        Lineas.add(double.parse(resBody5["Dato"]));
    }
      }
      else
      {
        Fluttertoast.showToast(msg: 'Error con el servidor');
        largo=['1', '2', '3'];
        Get.off(()=> Graficoten());
      }
  } 
    }
  }
  bb2(); 
    }on TimeoutException catch(e)
    {
      print(e.message);
      Fluttertoast.showToast(msg: 'Se supero el tiempo maximo');
    }
}

  Future bb2 () async{
    try{
  for(int x=0; x<largo.length; x++){
    for(int i=0; i<fechas.length; i++){
      {var rest3 = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLtabla("/retorno2.php")),
      body: {
        'nomlinea': largo[x],
        'idcentral': central,
        'date': fechas[i]
        },
      ).timeout(const Duration(seconds: 10));
      if(rest3.statusCode == 200)
      {
      var resBody5 = jsonDecode(rest3.body);
      if(resBody5['success']== true)
      {
          Lineas2.add(double.parse(resBody5["Dato"]));
      }
    else{
        Lineas2.add(double.parse(resBody5["Dato"]));
    }
      }
  } 
    }
  }
  setState(() {
        _addSeries();
      });
    }on TimeoutException catch(e)
    {
      print(e.message);
      Fluttertoast.showToast(msg: 'Se supero el tiempo maximo');
    }
}
  

  nuevafecha (String semana, String v) async{
    print(central);
    try
    {var restssr = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLtabla("/lineas.php")),
      body: {
        'idcentral' : v,
        'fechasemana': semana
      },
    ).timeout(const Duration(seconds: 9));
    if(restssr.statusCode == 200)
    {
    var resBody5 = jsonDecode(restssr.body);
    if(resBody5['success']== true)
    {
      for (int x=0; x<resBody5["userData"].length; x=x+1)
        {
          largo.add(resBody5["userData"][x]["linea"]);
        }
      }
    }
  }
  on TimeoutException catch(e)
    {
      print(e.message);
      Fluttertoast.showToast(msg: 'Se supero el tiempo maximo');
    }
}

  void Lun(pickedDate){
    DateTime dt2 = pickedDate.add(const Duration(days: 1));
    DateTime dt3 = pickedDate.add(const Duration(days: 2));
    DateTime dt4 = pickedDate.add(const Duration(days: 3));
    DateTime dt5 = pickedDate.add(const Duration(days: 4));
    DateTime dt6 = pickedDate.add(const Duration(days: 5));
    DateTime dt7 = pickedDate.add(const Duration(days: 6));
    setState((() {
      l=DateFormat('dd-MM-yyyy').format(pickedDate);
      m=DateFormat('dd-MM-yyyy').format(dt2);
      mi=DateFormat('dd-MM-yyyy').format(dt3);
      j=DateFormat('dd-MM-yyyy').format(dt4);
      v=DateFormat('dd-MM-yyyy').format(dt5);
      s=DateFormat('dd-MM-yyyy').format(dt6);
      d=DateFormat('dd-MM-yyyy').format(dt7);
    }));
  }

  void Mar(pickedDate){
    DateTime dt1 = pickedDate.subtract(const Duration(days: 1));
    DateTime dt3 = pickedDate.add(const Duration(days: 1));
    DateTime dt4 = pickedDate.add(const Duration(days: 2));
    DateTime dt5 = pickedDate.add(const Duration(days: 3));
    DateTime dt6 = pickedDate.add(const Duration(days: 4));
    DateTime dt7 = pickedDate.add(const Duration(days: 5));
    setState((() {
      l=DateFormat('dd-MM-yyyy').format(dt1);
      m=DateFormat('dd-MM-yyyy').format(pickedDate);
      mi=DateFormat('dd-MM-yyyy').format(dt3);
      j=DateFormat('dd-MM-yyyy').format(dt4);
      v=DateFormat('dd-MM-yyyy').format(dt5);
      s=DateFormat('dd-MM-yyyy').format(dt6);
      d=DateFormat('dd-MM-yyyy').format(dt7);
    }));
  }

  void Mir(pickedDate){
    DateTime dt1 = pickedDate.subtract(const Duration(days: 2));
    DateTime dt2 = pickedDate.subtract(const Duration(days: 1));
    DateTime dt4 = pickedDate.add(const Duration(days: 1));
    DateTime dt5 = pickedDate.add(const Duration(days: 2));
    DateTime dt6 = pickedDate.add(const Duration(days: 3));
    DateTime dt7 = pickedDate.add(const Duration(days: 4));
    setState((() {
      l=DateFormat('dd-MM-yyyy').format(dt1);
      m=DateFormat('dd-MM-yyyy').format(dt2);
      mi=DateFormat('dd-MM-yyyy').format(pickedDate);
      j=DateFormat('dd-MM-yyyy').format(dt4);
      v=DateFormat('dd-MM-yyyy').format(dt5);
      s=DateFormat('dd-MM-yyyy').format(dt6);
      d=DateFormat('dd-MM-yyyy').format(dt7);
    }));
  }

  void Jue(pickedDate){
    DateTime dt1 = pickedDate.subtract(const Duration(days: 3));
    DateTime dt2 = pickedDate.subtract(const Duration(days: 2));
    DateTime dt3 = pickedDate.subtract(const Duration(days: 1));
    DateTime dt5 = pickedDate.add(const Duration(days: 1));
    DateTime dt6 = pickedDate.add(const Duration(days: 2));
    DateTime dt7 = pickedDate.add(const Duration(days: 3));
    setState((() {
      l=DateFormat('dd-MM-yyyy').format(dt1);
      m=DateFormat('dd-MM-yyyy').format(dt2);
      mi=DateFormat('dd-MM-yyyy').format(dt3);
      j=DateFormat('dd-MM-yyyy').format(pickedDate);
      v=DateFormat('dd-MM-yyyy').format(dt5);
      s=DateFormat('dd-MM-yyyy').format(dt6);
      d=DateFormat('dd-MM-yyyy').format(dt7);
    }));
  }

  void Vie(pickedDate){
    DateTime dt1 = pickedDate.subtract(const Duration(days: 4));
    DateTime dt2 = pickedDate.subtract(const Duration(days: 3));
    DateTime dt3 = pickedDate.subtract(const Duration(days: 2));
    DateTime dt4 = pickedDate.subtract(const Duration(days: 1));
    DateTime dt6 = pickedDate.add(const Duration(days: 1));
    DateTime dt7 = pickedDate.add(const Duration(days: 2));
    setState((() {
      l=DateFormat('dd-MM-yyyy').format(dt1);
      m=DateFormat('dd-MM-yyyy').format(dt2);
      mi=DateFormat('dd-MM-yyyy').format(dt3);
      j=DateFormat('dd-MM-yyyy').format(dt4);
      v=DateFormat('dd-MM-yyyy').format(pickedDate);
      s=DateFormat('dd-MM-yyyy').format(dt6);
      d=DateFormat('dd-MM-yyyy').format(dt7);
    }));
  }

  void Sab(pickedDate){
    DateTime dt1 = pickedDate.subtract(const Duration(days: 5));
    DateTime dt2 = pickedDate.subtract(const Duration(days: 4));
    DateTime dt3 = pickedDate.subtract(const Duration(days: 3));
    DateTime dt4 = pickedDate.subtract(const Duration(days: 2));
    DateTime dt5 = pickedDate.subtract(const Duration(days: 1));
    DateTime dt7 = pickedDate.add(const Duration(days: 1));
    setState((() {
      l=DateFormat('dd-MM-yyyy').format(dt1);
      m=DateFormat('dd-MM-yyyy').format(dt2);
      mi=DateFormat('dd-MM-yyyy').format(dt3);
      j=DateFormat('dd-MM-yyyy').format(dt4);
      v=DateFormat('dd-MM-yyyy').format(dt5);
      s=DateFormat('dd-MM-yyyy').format(pickedDate);
      d=DateFormat('dd-MM-yyyy').format(dt7);
    }));
  }

  void Dom(pickedDate){
    DateTime dt1 = pickedDate.subtract(const Duration(days: 6));
    DateTime dt2 = pickedDate.subtract(const Duration(days: 5));
    DateTime dt3 = pickedDate.subtract(const Duration(days: 4));
    DateTime dt4 = pickedDate.subtract(const Duration(days: 3));
    DateTime dt5 = pickedDate.subtract(const Duration(days: 2));
    DateTime dt6 = pickedDate.subtract(const Duration(days: 1));
    setState((() {
      l=DateFormat('dd-MM-yyyy').format(dt1);
      m=DateFormat('dd-MM-yyyy').format(dt2);
      mi=DateFormat('dd-MM-yyyy').format(dt3);
      j=DateFormat('dd-MM-yyyy').format(dt4);
      v=DateFormat('dd-MM-yyyy').format(dt5);
      s=DateFormat('dd-MM-yyyy').format(dt6);
      d=DateFormat('dd-MM-yyyy').format(pickedDate);
    }));
  }

  void EscogerFecha(pickedDate){
    if((pickedDate.weekday).toInt()==Lunes){
      Lun(pickedDate);
    }
    else if((pickedDate.weekday).toInt()==Martes){
      Mar(pickedDate);
    }
    else if((pickedDate.weekday).toInt()==Miercoles){
      Mir(pickedDate);
    }
    else if((pickedDate.weekday).toInt()==Jueves){
      Jue(pickedDate);
    }
    else if((pickedDate.weekday).toInt()==Viernes){
      Vie(pickedDate);
    }
    else if((pickedDate.weekday).toInt()==Sabado){
      Sab(pickedDate);
    }
    else if((pickedDate.weekday).toInt()==Domingo){
      Dom(pickedDate);
    }
    fechas.add(l.toString());
    fechas.add(m.toString());
    fechas.add(mi.toString());
    fechas.add(j.toString());
    fechas.add(v.toString());
    fechas.add(s.toString());
    fechas.add(d.toString());
  }

}
int numOfWeeks(int year) {
  DateTime dec28 = DateTime(year, 12, 31);
  int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
  return ((dayOfDec28)/ 7).floor();
}

int numOfdays(int days) {
  int semanass=0;
  if (days<=7){
    semanass=7-days;
    days=days+semanass;
    return semanass;
  }
  else if (days==7){
    return semanass;
  }
  return semanass;
}


