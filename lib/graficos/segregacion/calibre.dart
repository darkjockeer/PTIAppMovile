// ignore: file_names
// ignore_for_file: import_of_legacy_library_into_null_safe, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/drawers/drawersegregacion.dart';
import '../../api_connection/Endpoints/EndPoinst.dart';
import '../../drawers/drawersegregacion.dart' as dr;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:proyecto/users/loginuser/login.dart' as lg;
import 'package:proyecto/users/loginuser/eleccion.dart' as el;

import '../../users/preferencias/actual.dart';

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
String id='';
String idexport='';
List <double> calibre1=[];
List <double> calibre2=[];
List <double> calibre3=[];
List <double> calibre4=[];
List <int> export=[];
List <int> muundial=[];
String valor='', valor6='', valor7='', central='';
int valor2=0;
var seen = <String>{};
List<String> uniquelist = lg.centrales.where((country) => seen.add(country)).toList();
late ZoomPanBehavior _zoomPanBehavior;
late TooltipBehavior _tooltipBehavior;
class ChartData {
        ChartData(this.x, this.y0, this.y1);
        final String x;
        final double y0;
        final double y1;
}

class Graficocalibre extends StatefulWidget{
    const Graficocalibre({Key? key}): super(key: key);
    @override
   // ignore: library_private_types_in_public_api
   _Graficocalibre createState() => _Graficocalibre();
  }
int i=0;
class _Graficocalibre extends State<Graficocalibre>{
  final actual _currentUser = Get.put(actual());
  List<CartesianSeries<ChartData, String>>? series;
  List<ChartData>? chartData;
  late int count;
      @override
    void initState(){
      valor6=el.nombreidexportador;
      valor7=lg.centrales[0];
      id=lg.id_centrales[0];
      count = 0;
      chartData = <ChartData>[
      ChartData('Ejemplo' ,0, 1),
    ];
      _tooltipBehavior = TooltipBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap);
     _zoomPanBehavior = ZoomPanBehavior(
                  enablePinching: true,
                  zoomMode: ZoomMode.x,
                  enablePanning: true
                );
      series = <CartesianSeries<ChartData, String>>[
      ColumnSeries<ChartData, String>(
        dataSource: chartData!,
        width: 0.9,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y0,
      ),
      LineSeries<ChartData, String>(
        dataSource: <ChartData>[
          ChartData('Ejemplo' ,0, 1),
        ],
        width: 0.9,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y1,
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
      drawer: const drawersegregacion(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          centerTitle: true,
          title: Text(dr.name.toString()),
          backgroundColor: const Color.fromRGBO(4, 43, 82, 1),
          actions: <Widget>[
            IconButton(onPressed: () async{
              var result = await Connectivity().checkConnectivity();
              if(result== ConnectivityResult.none)
              {
                showDialogBox();
              }
              else{
                if(dr.b==1){
                comprobarexp();
                comprobarcen();
                isSelected=false;
                nuevaidvariedad();
                valor=el.nombres[0];
                  _dialogBuilder();
                }
                else if (dr.b==3){
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
                width: MediaQuery.of(context).size.width-50,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                ),
                child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height-200,
                          child: SfCartesianChart(
                                    title: ChartTitle(text: 'Distribución calibre \n Variedad $valor', alignment: ChartAlignment.center, textStyle: TextStyle(fontSize: 10, color: Colors.black)),
                              zoomPanBehavior: _zoomPanBehavior,
                              enableAxisAnimation: true,
                              tooltipBehavior: _tooltipBehavior,
                              primaryXAxis: CategoryAxis(
                                labelPlacement: LabelPlacement.betweenTicks,
                                borderColor: Colors.black,
                                labelPosition: ChartDataLabelPosition.outside,
                                labelAlignment: LabelAlignment.center,
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 7,
                                  color: Colors.black,
                                )    
                              ),
                              primaryYAxis: NumericAxis(
                                maximum: 100,
                                interval: 20,
                                labelAlignment: LabelAlignment.center,
                                title: AxisTitle(text: '%', alignment: ChartAlignment.center, textStyle: TextStyle(fontSize: 10, color: Colors.black)),
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 7,
                                  color: Colors.black,
                                )  
                              ),
                              legend: Legend(
                                overflowMode: LegendItemOverflowMode.wrap,
                                isVisible: true,
                                position: LegendPosition.bottom,
                                borderColor: Colors.black, borderWidth: 2,
                                iconHeight: 12,
                                iconWidth: 12,
                                textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                              ),
                              enableSideBySideSeriesPlacement: true,
                              series: series,
                                  )
                        ),
                ),
              ),
              const SizedBox(
                height: 45,),
            ],
          ),
        )
      ),
    );
  
}
  void comprobarcen(){
    if(_currentUser.user.IDPERFIL == 1 || _currentUser.user.IDPERFIL == 5 || _currentUser.user.IDPERFIL == 6 ||_currentUser.user.IDLOGIN== 31)
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
    if(_currentUser.user.IDPERFIL==1 || _currentUser.user.IDPERFIL==5 || _currentUser.user.IDPERFIL==6)
    {
      siono=false;
    }
    else{
      siono=true;
    }
  }




  void _addSeries() {
    final List<ChartData> chartData1 = <ChartData>[];
    chartData1.add(ChartData('Precalibre' ,calibre1[0], calibre2[0]));
    chartData1.add(ChartData('22', calibre1[1], calibre2[1]));
    chartData1.add(ChartData('24', calibre1[2], calibre2[2]));
    chartData1.add(ChartData('26', calibre1[3], calibre2[3]));
    chartData1.add(ChartData('28', calibre1[4], calibre2[4]));
    chartData1.add(ChartData('30', calibre1[5], calibre2[5]));
    chartData1.add(ChartData('32', calibre1[6], calibre2[6]));
      
    series!.add(ColumnSeries<ChartData, String>(
      key: ValueKey<String>('${series!.length}'),
      color: ('#7CB5EC'.toColor()),
      name: 'Exportadora',
      animationDuration: 1500, animationDelay: 1500,dataLabelSettings: const DataLabelSettings( isVisible: false, showCumulativeValues: true,textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold,))
      ,spacing:0.2 ,width:0.9, 
      dataSource: chartData1,
      xValueMapper: (ChartData sales, _) => sales.x,
      yValueMapper: (ChartData sales, _) => sales.y0
    )); 
    series!.add(LineSeries<ChartData, String>(
      key: ValueKey<String>('${series!.length}'),
      name: 'Industria',
      markerSettings: MarkerSettings(isVisible: true, color: ('#4C4C51'.toColor())),
      animationDuration: 1500, animationDelay: 1500,color: Colors.black,dataLabelSettings: const DataLabelSettings( isVisible: false, showCumulativeValues: true,textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold,))
       ,width:0.9, 
      dataSource: chartData1,
      xValueMapper: (ChartData sales, _) => sales.x,
      yValueMapper: (ChartData sales, _) => sales.y1
    )); 
    Get.back();
    valor2=0;
    count++;
    if (count == 8) {
      count = 0;
    }
  }

   aa1 () async{
    calibre1=[];
    calibre2=[];
    print(valor2);
    try {
    var restssrs = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLtabla3("/calibre.php")),
      body: {
        'idcentral': id,
        'idvariedad': valor2.toString(),
        },
      ).timeout(const Duration(seconds: 7));
      if(restssrs.statusCode == 200)
      {
      var resBody2 = jsonDecode(restssrs.body);
      if(resBody2['success']== true)
      {
        for (int i=0; i<3;i++)
        {
          print('Numero $i');
          if(i==0)
          {
            for(int x=0; x<resBody2['Exportadora'].length;x++){
              calibre1.add(double.parse(resBody2["Exportadora"][x]));
            }
          }
          else if(i==1)
          {
            for(int x=0; x<resBody2['Industria'].length;x++){
              calibre2.add(double.parse(resBody2["Industria"][x]));
            }
          }
          else if(i==2)
          {
            print(calibre1);
            print(calibre2);
            setState(() {
              _addSeries();
            });
          }
        }
        }
          else{
          }
      }
      else
      {
        Fluttertoast.showToast(msg: "Error: No se pudo conectar con el servidor");
        Get.off(()=> Graficocalibre());
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


  nuevaidexportadora(String valor) async{
    try{
    var resp = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLmasInfo("/idexp.php")),
      body: {
        'nomexportador': valor
      },
    ).timeout(const Duration(seconds: 6)); 
    if(resp.statusCode == 200)
    {
      lg.centrales=[];
      var resBody = jsonDecode(resp.body);
      if(resBody['success']== true)
      {
        idexport=(resBody["userData"][0]["IDEXPORTADOR"]);
      }
      else
      {
        Fluttertoast.showToast(msg: "error");
      }
    }
    nuevaexportador();
    }
    on TimeoutException catch(e)
    {
      print(e.message);
      Fluttertoast.showToast(msg: 'Se supero el tiempo maximo');
    }
  }

  nuevaexportador() async{
    try{
  var rests = await http.post(
    Uri.parse(EndPoints.generateEndPointsURLInfo("/centrales.php")),
      body: {
        'idlogin' : lg.idlogin,
        'idperfil' : lg.idperfil,
        'idcentral': lg.idcentral,
        'idexportador' : idexport
      },
    ).timeout(const Duration(seconds: 7));
    if(rests.statusCode == 200)
    {
      var resBody3 = jsonDecode(rests.body);
      if(resBody3['success']== true)
      {
        for (int x=0; x<resBody3["userData"].length; x=x+1)
        {
          lg.centrales.add(resBody3["userData"][x]["NOMCENTRAL"]);
        }
      }
      else
      {
        lg.centrales.add(resBody3["userData"][0]["NOMCENTRAL"]);
      }
    }}
    on TimeoutException catch(e)
    {
      print(e.message);
      Fluttertoast.showToast(msg: 'Se supero el tiempo maximo');
    }
  }



 nuevaidvariedad () async{
    el.id_nombres=[];
    try
    {
      var rest = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLtabla3('/variedad.php'),),
      body: {
        'idcentral': lg.id_centrales[0].toString(),
        'idexportador': el.nuevoidexportador
      }
      ).timeout(const Duration(seconds: 7));
    if(rest.statusCode == 200)
      {
      var resBody2 = jsonDecode(rest.body);
      if(resBody2['success']== true)
      {
        for (int x=0; x<=resBody2["variedad"].length; x=x+1){
          el.id_nombres.add(resBody2["id"][x]);
        }
      }
      else
      {
      }
      }
      else
      {
        Fluttertoast.showToast(msg: "Error: No se pudo conectar con el servidor");
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

  _dialogBuilder() async{
    var resultResponse = await Get.dialog(AlertDialog(
          title: Container(
              height: 50,
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
                  height: 450,
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
                              onChanged: (catess) async {
                                  if(lg.exportador.length != 1)
                                  {
                                    nuevaidexportadora(catess.toString());
                                      setState(() {
                                        nuevaexportador();
                                        comprobarcen();
                                          lg.centrales=lg.centrales;
                                          valor6=catess.toString();
                                    });
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
                              DropdownButton(
                                isExpanded: true,
                                elevation: 10,
                                borderRadius: BorderRadius.circular(10),
                                alignment: Alignment.center,
                                value: valor7,
                                items: lg.centrales.map((country){
                                  return DropdownMenuItem(value: country,child: 
                                  Center(child: Text(country, textAlign: TextAlign.center,)),
                                  );
                                }).toList(),
                                onChanged: (country) async{
                                  for(int x=0; x<lg.centrales.length; x++)
                                  {
                                    if(country.toString()==lg.centrales[x])
                                    {
                                        id=lg.id_centrales[x];
                                    }
                                  }
                                  print(id);
                                  var rest = await http.post(
                                  Uri.parse(EndPoints.generateEndPointsURLtabla3('/variedad.php'),),
                                  body: {
                                    'idcentral': id,
                                    'idexportador': el.nuevoidexportador
                                  }
                                  );
                                  print(rest.body);
                                if(rest.statusCode == 200)
                                  {
                                    el.nombres=[];
                                    el.id_nombres=[];
                                  var resBody2 = jsonDecode(rest.body);
                                  if(resBody2['success']== true)
                                  {
                                    for (int x=0; x<resBody2["variedad"].length; x=x+1){
                                        el.nombres.add(resBody2["variedad"][x]);
                                        el.id_nombres.add(resBody2["id"][x].toString());
                                    }
                                  }
                                  else
                                  {
                                  }
                                  }
                                  setState(() {
                                    
                                    valor7=country.toString();
                                    valor=el.nombres[0];
                                    valor2=0;
                                    el.nombres=el.nombres;
                                  },);
                                }
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
                          child: Column(
                            children: [
                              const Text('Variedad',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),),
                              DropdownButton(
                                isExpanded: true,
                                elevation: 10,
                                borderRadius: BorderRadius.circular(10),
                                alignment: Alignment.center,
                                value: valor,
                                items: el.nombres.map((cate){
                                  return DropdownMenuItem(value: cate,child: 
                                  Center(child: Text(cate, textAlign: TextAlign.center,)),
                                  );
                                }).toList(),
                                onChanged: (cate) async {
                                  setState(() {
                                    valor=cate.toString();
                                    for (int i=0; i<el.nombres.length; i++)
                                    {
                                      if(valor==el.nombres[i])
                                      {
                                        valor2=int.parse(el.id_nombres[i]);
                                        print(valor2);
  
                                      }
                                    }
                                  });

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
                              onPressed: (){
                                print(valor2);
                                if(valor2==0 && isSelected==false)
                                {
                                  isSelected=true;
                                  valor2=int.parse(el.id_nombres[0]);
                                  valor=el.nombres[0];
                                  setState(() {
                                  series!.clear();
                                  aa1();
                                  });
                                }
                                else if(valor2 !=0 && isSelected==false){
                                  isSelected=true;
                                  setState(() {
                                  series!.clear();
                                  aa1();
                                  });
                                }
                                else
                                {
                                  Fluttertoast.showToast(msg: 'Boton ya presionado');
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

  }