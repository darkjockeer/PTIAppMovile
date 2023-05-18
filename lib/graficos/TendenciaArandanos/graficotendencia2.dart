
// ignore_for_file: non_constant_identifier_names, avoid_unnecessary_containers, import_of_legacy_library_into_null_safe, unused_local_variable
import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:proyecto/drawers/drawertendenciaArandanos.dart' as dk;
import 'package:flutter/material.dart';
import '../../api_connection/Endpoints/EndPoinstArandanos.dart';
import '../../drawers/drawertendenciaArandanos.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:proyecto/users/loginuser/login.dart' as lg;
import 'package:proyecto/users/loginuser/eleccion.dart' as el;

import '../../users/preferencias/actual.dart';
extension ColorExtension on String {
  toColors() {
    var hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
String L1='L${largo[0]}', L2='L2', L3='L3';
String L12='L${largo[0]}', L22='L2', L32='L3';
String nombre='';
int lin1=0, sobrel1=0, bajol1=0, sobrel2=0, bajol2=0, sobrel3=0, bajol3=0;
int sobrel21=0, bajol21=0, sobrel22=0, bajol22=0, sobrel23=0, bajol23=0;
int lin2=0;
int lin3=0;
String semana='';
List<String> x=['-0.3', '0.7', '1.7', '2.7', '3.7', '4.7', '5.7'], x1=['0', '1', '2' ,'3' ,'4', '5', '6'], x2=['0.3', '1.3', '2.3', '3.3', '4.3', '5.3', '6.3'] , x3=['0.36', '1.36','2.36','3.36','4.36','5.36','6.36',];
List<String> xx=['-0.3', '0.7', '1.7', '2.7', '3.7', '4.7', '5.7'], x11=['0', '1', '2' ,'3' ,'4', '5', '6'], x22=['0.3', '1.3', '2.3', '3.3', '4.3', '5.3', '6.3'];
bool isSelected= false, siono=false, siocen=false;
String valor1='', valor2='', valor3='', valor='', valor4='', central='';
List<String> largo=['1'];
var seen = <String>{}; 
 List<String> uniquelist = lg.centrales.where((country) => seen.add(country)).toList();
List<String> fechas=[];
List<String> categorias = ["1E","2E"];
var sen = <String>{};
List<double> sobre=[];
List<double> bajo=[]; 
List<double> sobre1=[];
List<double> bajo1=[];
List<String> Otra = categorias.where((cate) => sen.add(cate)).toList();
int contador=0;
var sens = <String>{};
List<String> Otras = categorias.where((cates) => sen.add(cates)).toList();
var sensS = <String>{};
List<String> Otras2 = lg.exportador.where((catess) => sen.add(catess)).toList();
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
DateTime selectedDate = DateTime.now();

class ChartData {
        ChartData({required this.x, required this.y0, required this.y1});
        final String x;
        final double y0;
        final double y1;
}
class Graficoten2 extends StatefulWidget{
  const Graficoten2({Key? key}): super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _GraficoTen2 createState () => _GraficoTen2();
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

class _GraficoTen2 extends State<Graficoten2> {
  final actual _currentUser = Get.put(actual());
  late ZoomPanBehavior _zoomPanBehavior;
  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior2;
  late TooltipBehavior _tooltipBehavior2;
  List<StackedColumnSeries<ChartData, String>>? series;
  List<StackedColumnSeries<ChartData, String>>? series2;
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
    @override
    void initState(){
      valor1=lg.centrales[0];
      valor3=lg.centrales[0];
      valor=el.nombreidexportador;
      central=lg.id_centrales[0];
      count = 0;
      chartData = <ChartData>[
      ChartData(x:'Ejemplo' ,y0 :21, y1: 35),
    ];
    chartData2 = <ChartData>[
      ChartData(x:'Ejemplo' ,y0 :21, y1: 35),
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
    series = <StackedColumnSeries<ChartData, String>>[
      StackedColumnSeries<ChartData, String>(
        onRendererCreated: (ChartSeriesController controller) {
        },
          groupName:'L1' ,animationDuration: 1000, animationDelay: 1000, color: Colors.red,name: 'Bajo ${dk.tipo} L${largo[0]}',dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues:false, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 7, color: Colors.black)),
          dataSource: chartData!,
          width: 0.95,
          spacing: 0.2,
          xValueMapper: (ChartData sales, _) => sales.x,
          yValueMapper: (ChartData sales, _) => sales.y0,),

      StackedColumnSeries<ChartData, String>(
        onRendererCreated: (ChartSeriesController controller) {
        },
          groupName:'L1' ,animationDuration: 1000, animationDelay: 1000, color: ('AB0303'.toColors()),name: 'Sobre ${dk.tipo} L${largo[0]}',dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 7, color: Colors.black)),
        dataSource: chartData!,
        width: 0.95,
        spacing: 0.2,
          xValueMapper: (ChartData sales, _) => sales.x,
          yValueMapper: (ChartData sales, _) => sales.y1,),
    ];

    series2 = <StackedColumnSeries<ChartData, String>>[
      StackedColumnSeries<ChartData, String>(
        onRendererCreated: (ChartSeriesController controller) {
        },
          groupName:'L1' ,animationDuration: 1000, animationDelay: 1000, color: Colors.red,name: 'Bajo ${dk.tipo} L${largo[0]}',dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues:false, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 7, color: Colors.black)),
          dataSource: chartData2!,
          width: 0.95,
          spacing: 0.2,
          xValueMapper: (ChartData sales, _) => sales.x,
          yValueMapper: (ChartData sales, _) => sales.y0,),

      StackedColumnSeries<ChartData, String>(
        onRendererCreated: (ChartSeriesController controller) {
        },
          groupName:'L1' ,animationDuration: 1000, animationDelay: 1000, color: ('AB0303'.toColors()),name: 'Sobre ${dk.tipo} L${largo[0]}',dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 7, color: Colors.black)),
        dataSource: chartData2!,
        width: 0.95,
        spacing: 0.2,
          xValueMapper: (ChartData sales, _) => sales.x,
          yValueMapper: (ChartData sales, _) => sales.y1,),
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
      appBar: 
      PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          centerTitle: true,
          title: Text(dk.name.toString()),
          backgroundColor: const Color.fromRGBO(4, 43, 82, 1),
          actions: <Widget>[
            IconButton(onPressed: () async {
              var result = Connectivity().checkConnectivity();
              if(result==ConnectivityResult.none)
              {
                showDialogBox();
              }
              else{
              if (dk.b==1){ {
                if(_currentUser.user.IDLOGIN==0 && _currentUser.user.IDPERFIL==0)
                {
                  _currentUser.user.IDLOGIN=int.parse(lg.idlogin);
                  _currentUser.user.IDPERFIL=int.parse(lg.idperfil);
                }
                comprobarexp();
                comprobarcen();
                isSelected=false;
    TextEditingController valors = TextEditingController();
    var resultResponse = await Get.dialog(AlertDialog(
              title: Container(
                height: 30,
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
                    height: 440,
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
                                  value: valor,
                                  items: lg.exportador.map((catess){
                                    return DropdownMenuItem(value: catess,child: 
                                    Center(
                                      child: Text(catess, textAlign: TextAlign.center,),),
                                    );
                                  }).toList(),
                                  onChanged: (catess)async {
                                  if(lg.exportador.length != 1)
                                  {
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
                                      if(resBody['success1']== true)
                                      {
                                        idexport=(resBody["userData1"][0]["IDEXPORTADOR"]);
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
                                            lg.centrales.add(resBody3["userData1"][0]["NOMCENTRAL"]);
                                          }
                                        }
                                      setState(() {
                                        comprobarcen();
                                          lg.centrales=lg.centrales;
                                          valor1=lg.centrales[0];
                                          print(lg.centrales);
                                          valor=catess.toString();
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
                                  value: valor1,
                                  items: lg.centrales.map((country){
                                    return DropdownMenuItem(value: country,
                                      child: Center(child: Text(country, textAlign: TextAlign.center,)),
                                    );
                                  }).toList(),
                                  onChanged: (country) async {
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
                                ):Text(lg.centrales[0], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),)
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
                                    fechas=[];
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate,
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
                                      valors.text = ('$formattedDate:  Semana $semana');
                                      selectedDate=pickedDate;
                                      el.diaguardado=semana;
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
                                    if(largo.length==0)
                                    {
                                      Fluttertoast.showToast(msg: "No se encontraron datos");
                                      largo=['1', '2', '3'];
                                      isSelected=false;
                                      Get.off(const Graficoten2());
                                    }
                                    else
                                    {
  
                                      if(valors.text.isNotEmpty==true && isSelected==false){
                                        setState(() {
                                          isSelected=true;
                                          series!.clear();
                                          series2!.clear();
                                          aa();
                                        });
                                      }
                                      else
                                      {
                                        setState(() {
                                          semana=el.diaguardado;
                                          isSelected=true;
                                          series!.clear();
                                          series2!.clear();
                                          aa();
                                        });
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
                                      ),),),
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
                _dialogBuilder2();
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
                Expanded(
                  child: Container(
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
      legend: Legend(isVisible: true, position: LegendPosition.bottom, borderColor: Colors.black, borderWidth: 2, iconWidth: 10, iconHeight: 10, ),
      title: ChartTitle(
        text: 'Turno 1',
        backgroundColor: Colors.white,
        alignment: ChartAlignment.center,
        textStyle: const TextStyle(color: Colors.black, fontFamily: 'Roboto', fontStyle: FontStyle.italic, fontSize: 10)
      ),
      zoomPanBehavior: _zoomPanBehavior2,
        enableAxisAnimation: true,
        margin: const EdgeInsets.all(5),
        plotAreaBorderWidth: 2,
        tooltipBehavior: _tooltipBehavior2,
        primaryYAxis: NumericAxis(
          maximum: 100
        ),
      primaryXAxis: CategoryAxis(
        isVisible: true,
        arrangeByIndex: false,
        minorTicksPerInterval: 3,
        labelRotation: 70,
        labelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 9
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
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L12,style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(xx[0]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L22, style: const TextStyle(
                                    fontSize: 8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x11[0]),
                                y: -2.5,
                              ),
                               CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L32,style: const TextStyle(
                                    fontSize: 8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x22[0]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L12, style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(xx[1]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L22,style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x11[1]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L32, style: const TextStyle(
                                    fontSize: 8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x22[1]),
                                y: -2.5,
                              ),
                               CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L12,style: const TextStyle(
                                    fontSize: 8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(xx[2]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L22, style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x11[2]),
                                y: -2.5,
                              ),
                               CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L32, style: const TextStyle(
                                    fontSize: 8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x22[2]),
                                y: -2.5,
                              ),
                               CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L12,style: const TextStyle(
                                    fontSize: 8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(xx[3]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L22, style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x11[3]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L32, style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x22[3]),
                                y: -2.5,
                              ),CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L12, style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x:double.parse(xx[4]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L22, style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x11[4]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L32, style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x22[4]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L12, style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x:double.parse(xx[5]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L22, style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x11[5]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L32, style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x22[5]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L12, style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(xx[6]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L22, style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x11[6]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L32, style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x22[6]),
                                y: -2.5,
                              ),
                            ],
      onLegendTapped: (args) async =>
      setState((){
        showLoading();
        Future.delayed(const Duration(seconds: 1),(() {
        String nombre= args.series.name;
        print(largo.length);
        if(largo.length==3)
        {
          if(nombre == 'Sobre ${dk.tipo} L${largo[0]}' || nombre == 'Bajo ${dk.tipo} L${largo[0]}' )
          {
            verificarL12(nombre);
          }
          else if ((nombre == 'Sobre ${dk.tipo} L${largo[1]}' || nombre == 'Bajo ${dk.tipo} L${largo[1]}' ))
          {
            verificarL22(nombre);
          }
          else
          {
            verificarL32(nombre);
          }
        }
        else if(largo.length==2)
        {
          if(nombre == 'Sobre ${dk.tipo} L${largo[0]}' || nombre == 'Bajo ${dk.tipo} L${largo[0]}' )
          {
            verificarL1l12(nombre);
          }
          else if ((nombre == 'Sobre ${dk.tipo} L${largo[1]}' || nombre == 'Bajo ${dk.tipo} L${largo[1]}' ))
          {
            verificarL2l22(nombre);
          }
        }
        else if(largo.length==1)
        {
          verificarL1l1l12(name);
        }
        }));
      }),
      series: series),),),
                ),
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
              Expanded(
                child: Container(
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
      legend: Legend(isVisible: true, position: LegendPosition.bottom, borderColor: Colors.black, borderWidth: 2, iconWidth: 10, iconHeight: 10, ),
      title: ChartTitle(
        text: 'Turno 2',
        backgroundColor: Colors.white,
        alignment: ChartAlignment.center,
        textStyle: const TextStyle(color: Colors.black, fontFamily: 'Roboto', fontStyle: FontStyle.italic, fontSize: 10)
      ),
      zoomPanBehavior: _zoomPanBehavior,
        enableAxisAnimation: true,
        margin: const EdgeInsets.all(5),
        plotAreaBorderWidth: 2,
        tooltipBehavior: _tooltipBehavior,
        primaryYAxis: NumericAxis(
          maximum: 100
        ),
      primaryXAxis: CategoryAxis(
        isVisible: true,
        arrangeByIndex: false,
        minorTicksPerInterval: 3,
        labelRotation: 70,
        labelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 9
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
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L1,style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x[0]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L2, style: const TextStyle(
                                    fontSize: 8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x1[0]),
                                y: -2.5,
                              ),
                               CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L3,style: const TextStyle(
                                    fontSize: 8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x2[0]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L1, style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x[1]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L2,style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x1[1]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L3, style: const TextStyle(
                                    fontSize: 8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x2[1]),
                                y: -2.5,
                              ),
                               CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L1,style: const TextStyle(
                                    fontSize: 8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x[2]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L2, style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x1[2]),
                                y: -2.5,
                              ),
                               CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L3, style: const TextStyle(
                                    fontSize: 8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x2[2]),
                                y: -2.5,
                              ),
                               CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L1,style: const TextStyle(
                                    fontSize: 8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x[3]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L2, style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x1[3]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L3, style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x2[3]),
                                y: -2.5,
                              ),CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L1, style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x:double.parse(x[4]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L2, style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x1[4]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L3, style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x2[4]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L1, style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x:double.parse(x[5]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L2, style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x1[5]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L3, style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x2[5]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L1, style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x[6]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L2, style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x1[6]),
                                y: -2.5,
                              ),
                              CartesianChartAnnotation(
                                widget: Container(
                                  child: Text(L3, style: const TextStyle(
                                    fontSize:8, fontWeight: FontWeight.bold
                                  ),),
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: double.parse(x2[6]),
                                y: -2.5,
                              ),
                            ],
      onLegendTapped: (args) async =>
      setState((){
        showLoading();
        Future.delayed(const Duration(seconds: 1),(() {
        String nombre= args.series.name;
        print(nombre);
        if(largo.length==3)
        {
          if(nombre == 'Sobre ${dk.tipo} L${largo[0]}' || nombre == 'Bajo ${dk.tipo} L${largo[0]}' )
          {
            verificarL1(nombre);
          }
          else if ((nombre == 'Sobre ${dk.tipo} L${largo[1]}' || nombre == 'Bajo ${dk.tipo} L${largo[1]}' ))
          {
            verificarL2(nombre);
          }
          else
          {
            verificarL3(nombre);
          }
        }
        else if(largo.length==2)
        {
          if(nombre == 'Sobre ${dk.tipo} L${largo[0]}' || nombre == 'Bajo ${dk.tipo} L${largo[0]}' )
          {
            verificarL1l1(nombre);
          }
          else if ((nombre == 'Sobre ${dk.tipo} L${largo[1]}' || nombre == 'Bajo ${dk.tipo} L${largo[1]}' ))
          {
            verificarL2l2(nombre);
          }
        }
        else if(largo.length==1)
        {
          verificarL1l1l1(name);
        }
        }));
      }),
      series: series2),
                              ),),
              ),
              const SizedBox(
                height: 10,),
            ],
          ),
        )
      ),
    );
}
   

  _dialogBuilder2() async {
    TextEditingController valors = TextEditingController();
         var result = Get.dialog(AlertDialog(
            title: Container(
              height: 30,
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
                  height: 510,
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
                                value: valor2,
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
                                      if(resBody['success1']== true)
                                      {
                                        idexport=(resBody["userData1"][0]["IDEXPORTADOR"]);
                                      }
                                      else
                                      {
                                        Fluttertoast.showToast(msg: "error");
                                      }
                                    }
                                    print(idexport);
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
                                            lg.centrales.add(resBody3["userData1"][0]["NOMCENTRAL"]);
                                          }
                                        }
                                      setState(() {
                                        comprobarcen();
                                          lg.centrales=lg.centrales;
                                          valor3=lg.centrales[0];
                                          print(lg.centrales);
                                          valor2=catess.toString();
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
                                value: valor3,
                                items: lg.centrales.map((country){
                                  return DropdownMenuItem(value: country,child: 
                                  Center(child: Text(country, textAlign: TextAlign.center,)),
                                  );
                                }).toList(),
                                onChanged: (country) async {
                                    setState((){
                                      for(int x=0;x<lg.id_centrales.length; x++)
                                      {
                                        if(lg.centrales[x]==country.toString())
                                        {
                                          central=lg.id_centrales[x];
                                          valor3=country.toString();
                                          break;
                                        }
                                      }
                                      },);
                                  },
                              ):Text(lg.centrales[0], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),),
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
                                  fechas=[];
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
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
                                      String semana= semanas.truncate().toString();
                                      valors.text = ('$formattedDate:  Semana $semana');
                                      selectedDate=pickedDate;
                                      el.diaguardado=semana;
                                      if(valor3==lg.centrales[0])
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
                      height: 60,
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
                                  Stopwatch stopwatch = new Stopwatch()..start();
                                  if(largo.length==0)
                                    {
                                      Fluttertoast.showToast(msg: "No se encontraron datos");
                                      largo=['1', '2', '3'];
                                      isSelected=false;
                                      Get.off(const Graficoten2());
                                    }
                                    else
                                    {
                                      if(valors.text.isNotEmpty==true && isSelected==false){
                                        setState((){
                                          isSelected=true;
                                          series!.clear();
                                          series2!.clear();
                                          aa1();
                                        });
                                    }
                                    else
                                    {
                                      setState(() {
                                          semana=el.diaguardado;
                                          isSelected=true;
                                          series!.clear();
                                          series2!.clear();
                                          aa();
                                        });
                                    }
                                    }
                              },
                              child:isSelected? Row(
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
    final List<ChartData> chartData3 = <ChartData>[];
    final List<ChartData> chartData4 = <ChartData>[];
    final List<ChartData> chartData5 = <ChartData>[];
    final List<ChartData> chartData6 = <ChartData>[];
    print(largo.length);
    if(largo.length==3)
    {
      chartData1.add(ChartData(x:l ,y0 :sobre[0], y1: bajo[0]));
      chartData1.add(ChartData(x:m, y0:sobre[1], y1:bajo[1]));
      chartData1.add(ChartData(x:mi, y0:sobre[2], y1:bajo[2]));
      chartData1.add(ChartData(x:j, y0:sobre[3], y1:bajo[3]));
      chartData1.add(ChartData(x: v, y0:sobre[4], y1:bajo[4]));
      chartData1.add(ChartData(x:s, y0:sobre[5], y1:bajo[5]));
      chartData1.add(ChartData(x:d, y0:sobre[6], y1:bajo[6]));

      chartData3.add(ChartData(x:l ,y0 :sobre[7], y1: bajo[7]));
      chartData3.add(ChartData(x:m, y0:sobre[8], y1:bajo[8]));
      chartData3.add(ChartData(x:mi, y0:sobre[9], y1:bajo[9]));
      chartData3.add(ChartData(x:j, y0:sobre[10], y1:bajo[10]));
      chartData3.add(ChartData(x: v, y0:sobre[11], y1:bajo[11]));
      chartData3.add(ChartData(x:s, y0:sobre[12], y1:bajo[12]));
      chartData3.add(ChartData(x:d, y0:sobre[13], y1:bajo[13]));

      chartData5.add(ChartData(x:l ,y0 :sobre[14], y1: bajo[14]));
      chartData5.add(ChartData(x:m, y0:sobre[15], y1:bajo[15]));
      chartData5.add(ChartData(x:mi, y0:sobre[16], y1:bajo[16]));
      chartData5.add(ChartData(x:j, y0:sobre[17], y1:bajo[17]));
      chartData5.add(ChartData(x: v, y0:sobre[18], y1:bajo[18]));
      chartData5.add(ChartData(x:s, y0:sobre[19], y1:bajo[19]));
      chartData5.add(ChartData(x:d, y0:sobre1[20], y1:bajo[20]));

      chartData2.add(ChartData(x:l ,y0 :sobre1[0], y1: bajo1[0]));
      chartData2.add(ChartData(x:m, y0:sobre1[1], y1:bajo1[1]));
      chartData2.add(ChartData(x:mi, y0:sobre1[2], y1:bajo1[2]));
      chartData2.add(ChartData(x:j, y0:sobre1[3], y1:bajo1[3]));
      chartData2.add(ChartData(x: v, y0:sobre1[4], y1:bajo1[4]));
      chartData2.add(ChartData(x:s, y0:sobre1[5], y1:bajo1[5]));
      chartData2.add(ChartData(x:d, y0:sobre1[6], y1:bajo1[6]));

      chartData4.add(ChartData(x:l ,y0 :sobre1[7], y1: bajo1[7]));
      chartData4.add(ChartData(x:m, y0:sobre1[8], y1:bajo1[8]));
      chartData4.add(ChartData(x:mi, y0:sobre1[9], y1:bajo1[9]));
      chartData4.add(ChartData(x:j, y0:sobre1[10], y1:bajo1[10]));
      chartData4.add(ChartData(x: v, y0:sobre1[11], y1:bajo1[11]));
      chartData4.add(ChartData(x:s, y0:sobre1[12], y1:bajo1[12]));
      chartData4.add(ChartData(x:d, y0:sobre1[13], y1:bajo1[13]));

      chartData6.add(ChartData(x:l ,y0 :sobre1[14], y1: bajo1[14]));
      chartData6.add(ChartData(x:m, y0:sobre1[15], y1:bajo1[15]));
      chartData6.add(ChartData(x:mi, y0:sobre1[16], y1:bajo1[16]));
      chartData6.add(ChartData(x:j, y0:sobre1[17], y1:bajo1[17]));
      chartData6.add(ChartData(x: v, y0:sobre1[18], y1:bajo1[18]));
      chartData6.add(ChartData(x:s, y0:sobre1[19], y1:bajo1[19]));
      chartData6.add(ChartData(x:d, y0:sobre1[20], y1:bajo1[20]));

      L1='L${largo[0]}'; 
      L2='L${largo[1]}'; 
      L3='L${largo[2]}';
      L12='L${largo[0]}'; 
      L22='L${largo[1]}'; 
      L32='L${largo[2]}';
    }
    else if(largo.length==2)
    {
      chartData1.add(ChartData(x:l ,y0 :sobre[0], y1: bajo[0]));
      chartData1.add(ChartData(x:m, y0:sobre[1], y1:bajo[1]));
      chartData1.add(ChartData(x:mi, y0:sobre[2], y1:bajo[2]));
      chartData1.add(ChartData(x:j, y0:sobre[3], y1:bajo[3]));
      chartData1.add(ChartData(x: v, y0:sobre[4], y1:bajo[4]));
      chartData1.add(ChartData(x:s, y0:sobre[5], y1:bajo[5]));
      chartData1.add(ChartData(x:d, y0:sobre[6], y1:bajo[6]));

      chartData3.add(ChartData(x:l ,y0 :sobre[7], y1: bajo[7]));
      chartData3.add(ChartData(x:m, y0:sobre[8], y1:bajo[8]));
      chartData3.add(ChartData(x:mi, y0:sobre[9], y1:bajo[9]));
      chartData3.add(ChartData(x:j, y0:sobre[10], y1:bajo[10]));
      chartData3.add(ChartData(x: v, y0:sobre[11], y1:bajo[11]));
      chartData3.add(ChartData(x:s, y0:sobre[12], y1:bajo[12]));
      chartData3.add(ChartData(x:d, y0:sobre[13], y1:bajo[13]));

      chartData2.add(ChartData(x:l ,y0 :sobre1[0], y1: bajo1[0]));
      chartData2.add(ChartData(x:m, y0:sobre1[1], y1:bajo1[1]));
      chartData2.add(ChartData(x:mi, y0:sobre1[2], y1:bajo1[2]));
      chartData2.add(ChartData(x:j, y0:sobre1[3], y1:bajo1[3]));
      chartData2.add(ChartData(x: v, y0:sobre1[4], y1:bajo1[4]));
      chartData2.add(ChartData(x:s, y0:sobre1[5], y1:bajo1[5]));
      chartData2.add(ChartData(x:d, y0:sobre1[6], y1:bajo1[6]));

      chartData4.add(ChartData(x:l ,y0 :sobre1[7], y1: bajo1[7]));
      chartData4.add(ChartData(x:m, y0:sobre1[8], y1:bajo1[8]));
      chartData4.add(ChartData(x:mi, y0:sobre1[9], y1:bajo1[9]));
      chartData4.add(ChartData(x:j, y0:sobre1[10], y1:bajo1[10]));
      chartData4.add(ChartData(x: v, y0:sobre1[11], y1:bajo1[11]));
      chartData4.add(ChartData(x:s, y0:sobre1[12], y1:bajo1[12]));
      chartData4.add(ChartData(x:d, y0:sobre1[13], y1:bajo1[13]));

      L1='L${largo[0]}'; 
      L2='L${largo[1]}'; 
      L3='';
      L12='L${largo[0]}'; 
      L22='L${largo[1]}'; 
      L32='';

    }
    else if(largo.length==1)
    {
      chartData1.add(ChartData(x:l ,y0 :sobre[0], y1: bajo[0]));
      chartData1.add(ChartData(x:m, y0:sobre[1], y1:bajo[1]));
      chartData1.add(ChartData(x:mi, y0:sobre[2], y1:bajo[2]));
      chartData1.add(ChartData(x:j, y0:sobre[3], y1:bajo[3]));
      chartData1.add(ChartData(x: v, y0:sobre[4], y1:bajo[4]));
      chartData1.add(ChartData(x:s, y0:sobre[5], y1:bajo[5]));
      chartData1.add(ChartData(x:d, y0:sobre[6], y1:bajo[6]));

      chartData2.add(ChartData(x:l ,y0 :sobre1[0], y1: bajo1[0]));
      chartData2.add(ChartData(x:m, y0:sobre1[1], y1:bajo1[1]));
      chartData2.add(ChartData(x:mi, y0:sobre1[2], y1:bajo1[2]));
      chartData2.add(ChartData(x:j, y0:sobre1[3], y1:bajo1[3]));
      chartData2.add(ChartData(x: v, y0:sobre1[4], y1:bajo1[4]));
      chartData2.add(ChartData(x:s, y0:sobre1[5], y1:bajo1[5]));

      L1='L${largo[0]}'; 
      L2=''; 
      L3='';
      L12='L${largo[0]}'; 
      L22=''; 
      L32='';
    }
      
    for(int x=0; x<largo.length; x++)
    {
      if(x==0)
      {
        series!.add(StackedColumnSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        groupName:'L1' ,animationDuration: 1000, animationDelay: 1000, color: ('FE2C2C'.toColors()),name: 'Sobre ${dk.tipo} L${largo[0]}',dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues:false, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 7, color: Colors.black)),
          dataSource: chartData1,
          width: 0.95,
          spacing: 0.2,
          xValueMapper: (ChartData sales, _) => sales.x,
          yValueMapper: (ChartData sales, _) => sales.y0,),
        );
        series!.add(StackedColumnSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        groupName:'L1' ,animationDuration: 1000, animationDelay: 1000, color: ('AB0303'.toColors()),name: 'Bajo ${dk.tipo} L${largo[0]}',dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues:false, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 7, color: Colors.black)),
          dataSource: chartData1,
          width: 0.95,
          spacing: 0.2,
          xValueMapper: (ChartData sales, _) => sales.x,
          yValueMapper: (ChartData sales, _) => sales.y1,),
        );

        series2!.add(StackedColumnSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        groupName:'L1' ,animationDuration: 1000, animationDelay: 1000, color: ('FE2C2C'.toColors()), name: 'Sobre ${dk.tipo} L${largo[0]}',dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 7, color: Colors.black)),
        dataSource: chartData2,
        width: 0.95,
        spacing: 0.2,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y0,),
        );
        series2!.add(StackedColumnSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        groupName:'L1' ,animationDuration: 1000, animationDelay: 1000, color: ('AB0303'.toColors()),name: 'Bajo ${dk.tipo} L${largo[0]}',dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 7, color: Colors.black)),
        dataSource: chartData2,
        width: 0.95,
        spacing: 0.2,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y1,),
        );
      }
      else if(x==1)
      {

        series!.add(StackedColumnSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        groupName:'L2' ,animationDuration: 1000, animationDelay: 1000, color: ('FE2C2C'.toColors()),name: 'Sobre ${dk.tipo} L${largo[1]}',dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues:false, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 7, color: Colors.black)),
          dataSource: chartData3,
          width: 0.95,
          spacing: 0.2,
          xValueMapper: (ChartData sales, _) => sales.x,
          yValueMapper: (ChartData sales, _) => sales.y0,),
        );
        series!.add(StackedColumnSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        groupName:'L2' ,animationDuration: 1000, animationDelay: 1000, color: ('AB0303'.toColors()),name: 'Bajo ${dk.tipo} L${largo[1]}',dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues:false, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 7, color: Colors.black)),
          dataSource: chartData3,
          width: 0.95,
          spacing: 0.2,
          xValueMapper: (ChartData sales, _) => sales.x,
          yValueMapper: (ChartData sales, _) => sales.y1,),
        );

        series2!.add(StackedColumnSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        groupName:'L2' ,animationDuration: 1000, animationDelay: 1000, color: ('FE2C2C'.toColors()),name: 'Sobre ${dk.tipo} L${largo[1]}',dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 7, color: Colors.black)),
        dataSource: chartData4,
        width: 0.95,
        spacing: 0.2,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y0,),
        );
        series2!.add(StackedColumnSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        groupName:'L2' ,animationDuration: 1000, animationDelay: 1000, color: ('AB0303'.toColors()),name: 'Bajo ${dk.tipo} L${largo[1]}',dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 7, color: Colors.black)),
        dataSource: chartData4,
        width: 0.95,
        spacing: 0.2,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y1,),
        );
        
      }
      else if(x==2)
      {


        series!.add(StackedColumnSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        groupName:'L3' ,animationDuration: 1000, animationDelay: 1000, color: ('FE2C2C'.toColors()),name: 'Sobre ${dk.tipo} L${largo[2]}',dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues:false, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 7, color: Colors.black)),
          dataSource: chartData5,
          width: 0.95,
          spacing: 0.2,
          xValueMapper: (ChartData sales, _) => sales.x,
          yValueMapper: (ChartData sales, _) => sales.y0,),
        );
        series!.add(StackedColumnSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        groupName:'L3' ,animationDuration: 1000, animationDelay: 1000, color: ('AB0303'.toColors()),name: 'Bajo ${dk.tipo} L${largo[2]}',dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues:false, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 7, color: Colors.black)),
          dataSource: chartData5,
          width: 0.95,
          spacing: 0.2,
          xValueMapper: (ChartData sales, _) => sales.x,
          yValueMapper: (ChartData sales, _) => sales.y1,),
        );

        series2!.add(StackedColumnSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        groupName:'L3' ,animationDuration: 1000, animationDelay: 1000, color: ('FE2C2C'.toColors()),name: 'Sobre ${dk.tipo} L${largo[2]}',dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 7, color: Colors.black)),
        dataSource: chartData6,
        width: 0.95,
        spacing: 0.2,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y0,),
        );
        series2!.add(StackedColumnSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        groupName:'L3' ,animationDuration: 1000, animationDelay: 1000, color: ('AB0303'.toColors()),name: 'Bajo ${dk.tipo} L${largo[2]}',dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true, textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 7, color: Colors.black)),
        dataSource: chartData6,
        width: 0.95,
        spacing: 0.2,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y1,),
        );
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
    sobre=[];
    bajo=[];
    try{
    for(int x=0; x<largo.length; x++){
    for(int i=0; i<fechas.length; i++){
    {var restssrs = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLtabla("/peso1.php")),
      body: {
        'nomlinea': largo[x],
        'idcentral': central,
        'nomfechaprimeracat': fechas[i]
        },
      ).timeout(const Duration(seconds: 10));
      if(restssrs.statusCode == 200)
      {
      var resBody5 = jsonDecode(restssrs.body);
      bajo.add(double.parse(resBody5["Bajo"]));
      sobre.add(double.parse(resBody5["Sobre"]));
      if(resBody5['success']== true)
      {
          //Lineas.add(resBody5["Dato"]);
      }
    else{
        //Lineas.add(resBody5["Dato"]);
    }
      }
      else
      {
        Fluttertoast.showToast(msg: 'Error con el servidor');
        largo=['1', '2', '3'];
        Get.off(()=> Graficoten2());
      }
  } 
    }
  }
  bb();
    }on TimeoutException catch(e)
    {
      print(e.message);
      Fluttertoast.showToast(msg: 'Se supero el tiempo maximo');
    }
}

  Future bb () async{
    sobre1=[];
    bajo1=[];
    try{
  for(int x=0; x<largo.length; x++){
    for(int i=0; i<fechas.length; i++){
      {var rest3 = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLtabla("/peso2.php")),
      body: {
        'nomlinea': largo[x],
        'idcentral': central,
        'nomfechaprimeracat': fechas[i]
        },
      ).timeout(const Duration(seconds: 10));
      if(rest3.statusCode == 200)
      {
      var resBody6 = jsonDecode(rest3.body);
      bajo1.add(double.parse(resBody6["Bajo"]));
      sobre1.add(double.parse(resBody6["Sobre"]));
      if(resBody6['success']== true)
      {
          //Lineas.add(resBody5["Dato"]);
      }
    else{
        //Lineas.add(resBody5["Dato"]);
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


  Future aa1 () async{
    sobre=[];
    bajo=[];
    try{
  for(int x=0; x<largo.length; x++){
    for(int i=0; i<fechas.length; i++){
      {var restssrs = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLtabla("/calibre1.php")),
      body: {
        'nomlinea': largo[x],
        'idcentral': central,
        'nomfechaprimeracat': fechas[i]
        },
      ).timeout(const Duration(seconds: 10));
      if(restssrs.statusCode == 200)
      {
      var resBody5 = jsonDecode(restssrs.body);
      bajo.add(double.parse(resBody5["Bajo"]));
      sobre.add(double.parse(resBody5["Sobre"]));
      if(resBody5['success']== true)
      {
         print(resBody5);
      }
    else{
        //Lineas.add(resBody5["Dato"]);
    }
      }
      else
      {
        Fluttertoast.showToast(msg: 'Error con el servidor');
        largo=['1', '2', '3'];
        Get.off(()=> Graficoten2());
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
    sobre1=[];
    bajo1=[];
    try{
  for(int x=0; x<largo.length; x++){
    for(int i=0; i<fechas.length; i++){
      {var rest3 = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLtabla("/calibre2.php")),
      body: {
        'nomlinea': largo[x],
        'idcentral': central,
        'nomfechaprimeracat': fechas[i]
        },
      ).timeout(const Duration(seconds: 10));
      if(rest3.statusCode == 200)
      {
      var resBody6 = jsonDecode(rest3.body);
      bajo1.add(double.parse(resBody6["Bajo"]));
      sobre1.add(double.parse(resBody6["Sobre"]));
      if(resBody6['success']== true)
      {
          //Lineas.add(resBody5["Dato"]);
      }
    else{
        //Lineas.add(resBody5["Dato"]);
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

  static void showLoading(){
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 12,),
              Text('Cargando grafico....'),
            ],
          ),
        ),
      )
    );
  }

  static void hideLoading(){
    if(Get.isDialogOpen==true) Get.back();
  }

//series 1

  Future verificarL1 (String name) async {
        print('entro');
        if(name == 'Sobre ${dk.tipo} L${largo[0]}')
        {
          sobrel1 = sobrel1+1;
          if(sobrel1==1)
          {
            if(bajol1==1)
            {
              bajol1=0;
              setState(() {
                x1=['-0.2', '0.8', '1.8' ,'2.8' ,'3.8', '4.8', '5.8'];
                L1='';
              });
            }
            else
            {
              setState(() {
                L1='L${largo[0]}';
                x1=['0', '1', '2' ,'3' ,'4', '5', '6'];
              });
            }
          }
          else
          {
            sobrel1=0;
            setState(() {
                L1='L${largo[0]}';
                x1=['0', '1', '2' ,'3' ,'4', '5', '6'];
              });
          }
        }
        else if (name == 'Bajo ${dk.tipo} L${largo[0]}')
        {
          bajol1 = bajol1+1;
          if(bajol1==1)
          {
            if(sobrel1==1)
            {
              print('2 iguales');
              setState(() {
                x1=['-0.2', '0.8', '1.8' ,'2.8' ,'3.8', '4.8', '5.8'];
                L1='';
              });
            }
            else
            {

              setState(() {
                L1='L${largo[0]}';
                x1=['0', '1', '2' ,'3' ,'4', '5', '6'];
              });
            }
          }
          else
          {
            bajol1=0;
            setState(() {
                L1='L${largo[0]}';
                x1=['0', '1', '2' ,'3' ,'4', '5', '6'];
              });
          }
        }
        hideLoading();
          
  }
 
  Future verificarL2 (String name) async {
    print('entro');
        if(name == 'Sobre ${dk.tipo} L${largo[1]}')
        {
          sobrel2 = sobrel2+1;
          if(sobrel2==1)
          {
            if(bajol2==1)
            {
              bajol2=0;
              setState(() {
                x=['-0.2', '0.8', '1.8' ,'2.8' ,'3.8', '4.8', '5.8'];
                L2='';
              });
            }
            else
            {
              setState(() {
                x=['-0.3', '0.7', '1.7', '2.7', '3.7', '4.7', '5.7'];
                L2='L${largo[1]}';
              });
            }
          }
          else
          {
            sobrel2=0;
            setState(() {
                x=['-0.3', '0.7', '1.7', '2.7', '3.7', '4.7', '5.7'];
                L2='L${largo[1]}';
              });
          }
        }
        else if(name == 'Bajo ${dk.tipo} L${largo[1]}')
        {
          bajol2 = bajol2+1;
          if(bajol2==1)
          {
            if(sobrel2==1)
            {
              print('2 iguales');
              setState(() {
                x=['-0.2', '0.8', '1.8' ,'2.8' ,'3.8', '4.8', '5.8'];
                L2='';
              });
            }
            else
            {

              setState(() {
                x=['-0.3', '0.7', '1.7', '2.7', '3.7', '4.7', '5.7'];
                L2='L${largo[1]}';
              });
            }
          }
          else
          {
            bajol2=0;
            setState(() {
                x=['-0.3', '0.7', '1.7', '2.7', '3.7', '4.7', '5.7'];
                L2='L${largo[1]}';
              });
          }
        }
          
      hideLoading();
  }

  Future verificarL3 (String name) async {
        print('entro');
        if(name == 'Sobre ${dk.tipo} L${largo[2]}')
        {
          sobrel3 = sobrel3+1;
          if(sobrel3==1)
          {
            if(bajol3==1)
            {
              bajol3=0;
              setState(() {
                x1=['0.3', '1.3', '2.3', '3.3', '4.3', '5.3', '6.3'];
                L3='';
              });
            }
            else
            {
              setState(() {
                x1=['0', '1', '2' ,'3' ,'4', '5', '6'];
                L3='L${largo[2]}';
              });
            }
          }
          else
          {
            sobrel3=0;
            setState(() {
                x1=['0', '1', '2' ,'3' ,'4', '5', '6'];
                L3='L${largo[2]}';
              });
          }
        }
        else if(name == 'Bajo ${dk.tipo} L${largo[2]}')
        {
          bajol3 = bajol3+1;
          if(bajol3==1)
          {
            if(sobrel3==1)
            {
              print('2 iguales');
              setState(() {
                x1=['0.3', '1.3', '2.3', '3.3', '4.3', '5.3', '6.3'];
                L3='';
              });
            }
            else
            {

              setState(() {
                x1=['0', '1', '2' ,'3' ,'4', '5', '6'];
                L3='L${largo[2]}';
              });
            }
          }
          else
          {
            bajol3=0;
            setState(() {
                x1=['0', '1', '2' ,'3' ,'4', '5', '6'];
                L3='L${largo[2]}';
              });
          }
        }
          
      hideLoading();
  }

  Future verificarL1l1 (String name) async{
    print('entro');
        if(name == 'Sobre ${dk.tipo} L${largo[0]}')
        {
          sobrel1 = sobrel1+1;
          if(sobrel1==1)
          {
            if(bajol1==1)
            {
              bajol1=0;
              setState(() {
                x1=['-0.2', '0.8', '1.8' ,'2.8' ,'3.8', '4.8', '5.8'];
                L1='';
              });
            }
            else
            {
              setState(() {
                L1='L${largo[0]}';
                x1=['0.25', '1.25', '2.25' ,'3.25' ,'4.25', '5.25', '6.25'];
              });
            }
          }
          else
          {
            sobrel1=0;
            setState(() {
                L1='L${largo[0]}';
                x1=['0.25', '1.25', '2.25' ,'3.25' ,'4.25', '5.25', '6.25'];
              });
          }
        }
        else if (name == 'Bajo ${dk.tipo} L${largo[0]}')
        {
          bajol1 = bajol1+1;
          if(bajol1==1)
          {
            if(sobrel1==1)
            {
              print('2 iguales');
              setState(() {
                x1=['-0.2', '0.8', '1.8' ,'2.8' ,'3.8', '4.8', '5.8'];
                L1='';
              });
            }
            else
            {

              setState(() {
                L1='L${largo[0]}';
                x1=['0.25', '1.25', '2.25' ,'3.25' ,'4.25', '5.25', '6.25'];
              });
            }
          }
          else
          {
            bajol1=0;
            setState(() {
                L1='L${largo[0]}';
                x1=['0.25', '1.25', '2.25' ,'3.25' ,'4.25', '5.25', '6.25'];
              });
          }
        }
        hideLoading();
  }

  Future verificarL2l2 (String name) async {
    print('entro');
        if(name == 'Sobre ${dk.tipo} L${largo[1]}')
        {
          sobrel2 = sobrel2+1;
          if(sobrel2==1)
          {
            if(bajol2==1)
            {
              bajol2=0;
              setState(() {
                x=['-0.2', '0.8', '1.8' ,'2.8' ,'3.8', '4.8', '5.8'];
                L2='';
              });
            }
            else
            {
              setState(() {
                x=['-0.25', '0.85', '1.85', '2.85', '3.85', '4.85', '5.85'];
                L2='L${largo[1]}';
              });
            }
          }
          else
          {
            sobrel2=0;
            setState(() {
                x=['-0.25', '0.85', '1.85', '2.85', '3.85', '4.85', '5.85'];
                L2='L${largo[1]}';
              });
          }
        }
        else if(name == 'Bajo ${dk.tipo} L${largo[1]}')
        {
          bajol2 = bajol2+1;
          if(bajol2==1)
          {
            if(sobrel2==1)
            {
              print('2 iguales');
              setState(() {
                x=['-0.2', '0.8', '1.8' ,'2.8' ,'3.8', '4.8', '5.8'];
                L2='';
              });
            }
            else
            {

              setState(() {
                x=['-0.25', '0.85', '1.85', '2.85', '3.85', '4.85', '5.85'];
                L2='L${largo[1]}';
              });
            }
          }
          else
          {
            bajol2=0;
            setState(() {
                x=['-0.25', '0.85', '1.85', '2.85', '3.85', '4.85', '5.85'];
                L2='L${largo[1]}';
              });
          }
        }
          
      hideLoading();
  }

  Future verificarL1l1l1 (String name) async{
    print('entro');
        if(name == 'Sobre ${dk.tipo} L${largo[0]}')
        {
          sobrel1 = sobrel1+1;
          if(sobrel1==1)
          {
            if(bajol1==1)
            {
              bajol1=0;
              setState(() {
                L1='';
              });
            }
            else
            {
              setState(() {
                L1='L${largo[0]}';
              });
            }
          }
          else
          {
            sobrel1=0;
            setState(() {
                L1='L${largo[0]}';
              });
          }
        }
        else if (name == 'Bajo ${dk.tipo} L${largo[0]}')
        {
          bajol1 = bajol1+1;
          if(bajol1==1)
          {
            if(sobrel1==1)
            {
              print('2 iguales');
              setState(() {
                L1='';
              });
            }
            else
            {

              setState(() {
                L1='L${largo[0]}';
              });
            }
          }
          else
          {
            bajol1=0;
            setState(() {
                L1='L${largo[0]}';
              });
          }
        }
        hideLoading();
  }

//series 2
  Future verificarL12 (String name) async {
        print('entro');
        if(name == 'Sobre ${dk.tipo} L${largo[0]}')
        {
          sobrel21 = sobrel21+1;
          if(sobrel21==1)
          {
            if(bajol21==1)
            {
              bajol21=0;
              setState(() {
                x11=['-0.2', '0.8', '1.8' ,'2.8' ,'3.8', '4.8', '5.8'];
                L12='';
              });
            }
            else
            {
              setState(() {
                L12='L${largo[0]}';
                x11=['0', '1', '2' ,'3' ,'4', '5', '6'];
              });
            }
          }
          else
          {
            sobrel21=0;
            setState(() {
                L12='L${largo[0]}';
                x11=['0', '1', '2' ,'3' ,'4', '5', '6'];
              });
          }
        }
        else if (name == 'Bajo ${dk.tipo} L${largo[0]}')
        {
          bajol21 = bajol21+1;
          if(bajol21==1)
          {
            if(sobrel21==1)
            {
              print('2 iguales');
              setState(() {
                x11=['-0.2', '0.8', '1.8' ,'2.8' ,'3.8', '4.8', '5.8'];
                L12='';
              });
            }
            else
            {

              setState(() {
                L12='L${largo[0]}';
                x11=['0', '1', '2' ,'3' ,'4', '5', '6'];
              });
            }
          }
          else
          {
            bajol21=0;
            setState(() {
                L12='L${largo[0]}';
                x11=['0', '1', '2' ,'3' ,'4', '5', '6'];
              });
          }
        }
        hideLoading();
          
  }
 
  Future verificarL22 (String name) async {
    print('entro');
        if(name == 'Sobre ${dk.tipo} L${largo[1]}')
        {
          sobrel22 = sobrel22+1;
          if(sobrel22==1)
          {
            if(bajol22==1)
            {
              bajol22=0;
              setState(() {
                xx=['-0.2', '0.8', '1.8' ,'2.8' ,'3.8', '4.8', '5.8'];
                L22='';
              });
            }
            else
            {
              setState(() {
                xx=['-0.3', '0.7', '1.7', '2.7', '3.7', '4.7', '5.7'];
                L22='L${largo[1]}';
              });
            }
          }
          else
          {
            sobrel22=0;
            setState(() {
                xx=['-0.3', '0.7', '1.7', '2.7', '3.7', '4.7', '5.7'];
                L22='L${largo[1]}';
              });
          }
        }
        else if(name == 'Bajo ${dk.tipo} L${largo[1]}')
        {
          bajol22 = bajol22+1;
          if(bajol22==1)
          {
            if(sobrel22==1)
            {
              print('2 iguales');
              setState(() {
                xx=['-0.2', '0.8', '1.8' ,'2.8' ,'3.8', '4.8', '5.8'];
                L22='';
              });
            }
            else
            {

              setState(() {
                xx=['-0.3', '0.7', '1.7', '2.7', '3.7', '4.7', '5.7'];
                L22='L${largo[1]}';
              });
            }
          }
          else
          {
            bajol22=0;
            setState(() {
                xx=['-0.3', '0.7', '1.7', '2.7', '3.7', '4.7', '5.7'];
                L22='L${largo[1]}';
              });
          }
        }
          
      hideLoading();
  }

  Future verificarL32 (String name) async {
        print('entro');
        if(name == 'Sobre ${dk.tipo} L${largo[2]}')
        {
          sobrel23 = sobrel23+1;
          if(sobrel23==1)
          {
            if(bajol23==1)
            {
              bajol23=0;
              setState(() {
                x11=['0.3', '1.3', '2.3', '3.3', '4.3', '5.3', '6.3'];
                L32='';
              });
            }
            else
            {
              setState(() {
                x11=['0', '1', '2' ,'3' ,'4', '5', '6'];
                L32='L${largo[2]}';
              });
            }
          }
          else
          {
            sobrel23=0;
            setState(() {
                x11=['0', '1', '2' ,'3' ,'4', '5', '6'];
                L32='L${largo[2]}';
              });
          }
        }
        else if(name == 'Bajo ${dk.tipo} L${largo[2]}')
        {
          bajol23 = bajol23+1;
          if(bajol23==1)
          {
            if(sobrel23==1)
            {
              print('2 iguales');
              setState(() {
                x11=['0.3', '1.3', '2.3', '3.3', '4.3', '5.3', '6.3'];
                L32='';
              });
            }
            else
            {

              setState(() {
                x11=['0', '1', '2' ,'3' ,'4', '5', '6'];
                L32='L${largo[2]}';
              });
            }
          }
          else
          {
            bajol23=0;
            setState(() {
                x11=['0', '1', '2' ,'3' ,'4', '5', '6'];
                L32='L${largo[2]}';
              });
          }
        }
          
      hideLoading();
  }

  Future verificarL1l12 (String name) async{
    print('entro');
        if(name == 'Sobre ${dk.tipo} L${largo[0]}')
        {
          sobrel21 = sobrel21+1;
          if(sobrel21==1)
          {
            if(bajol21==1)
            {
              bajol21=0;
              setState(() {
                x11=['-0.2', '0.8', '1.8' ,'2.8' ,'3.8', '4.8', '5.8'];
                L12='';
              });
            }
            else
            {
              setState(() {
                L12='L${largo[0]}';
                x11=['0.25', '1.25', '2.25' ,'3.25' ,'4.25', '5.25', '6.25'];
              });
            }
          }
          else
          {
            sobrel21=0;
            setState(() {
                L12='L${largo[0]}';
                x11=['0.25', '1.25', '2.25' ,'3.25' ,'4.25', '5.25', '6.25'];
              });
          }
        }
        else if (name == 'Bajo ${dk.tipo} L${largo[0]}')
        {
          bajol21 = bajol21+1;
          if(bajol21==1)
          {
            if(sobrel21==1)
            {
              print('2 iguales');
              setState(() {
                x11=['-0.2', '0.8', '1.8' ,'2.8' ,'3.8', '4.8', '5.8'];
                L12='';
              });
            }
            else
            {

              setState(() {
                L12='L${largo[0]}';
                x11=['0.25', '1.25', '2.25' ,'3.25' ,'4.25', '5.25', '6.25'];
              });
            }
          }
          else
          {
            bajol21=0;
            setState(() {
                L12='L${largo[0]}';
                x11=['0.25', '1.25', '2.25' ,'3.25' ,'4.25', '5.25', '6.25'];
              });
          }
        }
        hideLoading();
  }

  Future verificarL2l22 (String name) async {
    print('entro');
        if(name == 'Sobre ${dk.tipo} L${largo[1]}')
        {
          sobrel22 = sobrel22+1;
          if(sobrel22==1)
          {
            if(bajol22==1)
            {
              bajol22=0;
              setState(() {
                xx=['-0.2', '0.8', '1.8' ,'2.8' ,'3.8', '4.8', '5.8'];
                L22='';
              });
            }
            else
            {
              setState(() {
                xx=['-0.25', '0.85', '1.85', '2.85', '3.85', '4.85', '5.85'];
                L22='L${largo[1]}';
              });
            }
          }
          else
          {
            sobrel22=0;
            setState(() {
                xx=['-0.25', '0.85', '1.85', '2.85', '3.85', '4.85', '5.85'];
                L22='L${largo[1]}';
              });
          }
        }
        else if(name == 'Bajo ${dk.tipo} L${largo[1]}')
        {
          bajol22 = bajol22+1;
          if(bajol22==1)
          {
            if(sobrel22==1)
            {
              print('2 iguales');
              setState(() {
                xx=['-0.2', '0.8', '1.8' ,'2.8' ,'3.8', '4.8', '5.8'];
                L22='';
              });
            }
            else
            {

              setState(() {
                xx=['-0.25', '0.85', '1.85', '2.85', '3.85', '4.85', '5.85'];
                L22='L${largo[1]}';
              });
            }
          }
          else
          {
            bajol22=0;
            setState(() {
                xx=['-0.25', '0.85', '1.85', '2.85', '3.85', '4.85', '5.85'];
                L22='L${largo[1]}';
              });
          }
        }
          
      hideLoading();
  }

  Future verificarL1l1l12 (String name) async{
    print('entro');
        if(name == 'Sobre ${dk.tipo} L${largo[0]}')
        {
          sobrel21 = sobrel21+1;
          if(sobrel21==1)
          {
            if(bajol21==1)
            {
              bajol21=0;
              setState(() {
                L12='';
              });
            }
            else
            {
              setState(() {
                L12='L${largo[0]}';
              });
            }
          }
          else
          {
            sobrel21=0;
            setState(() {
                L12='L${largo[0]}';
              });
          }
        }
        else if (name == 'Bajo ${dk.tipo} L${largo[0]}')
        {
          bajol21 = bajol21+1;
          if(bajol21==1)
          {
            if(sobrel21==1)
            {
              print('2 iguales');
              setState(() {
                L12='';
              });
            }
            else
            {

              setState(() {
                L12='L${largo[0]}';
              });
            }
          }
          else
          {
            bajol21=0;
            setState(() {
                L12='L${largo[0]}';
              });
          }
        }
        hideLoading();
  }



  nuevafecha (String semana, String v) async{
    print(central);
    try{var restssr = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLtabla("/lineas.php")),
      body: {
        'idcentral' : v,
        'fechasemana': semana
      },
    ).timeout(const Duration(seconds: 5));
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