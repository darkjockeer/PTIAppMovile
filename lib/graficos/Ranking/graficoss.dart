// ignore: file_names
// ignore_for_file: import_of_legacy_library_into_null_safe, unnecessary_import, unused_import, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:proyecto/drawers/drawerranking.dart';
import 'package:flutter/material.dart';
import '../../api_connection/Endpoints/EndPoinst.dart';
import '../../drawers/drawerranking.dart' as dr;
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
bool isSelected=false, siono=false;
int id=0;
String idexport='';
List <double> calibre1=[];
List <double> calibre2=[];
List <double> calibre3=[];
List <int> idexp=[];
List <int> ids=[];
List <String> idcolor=['#8CFFFB', '#8CFFFB', '#8CFFFB', '#8CFFFB', '#8CFFFB','#8CFFFB', '#8CFFFB', '#8CFFFB', '#8CFFFB', '#8CFFFB','#8CFFFB', '#8CFFFB', '#8CFFFB', '#8CFFFB', '#8CFFFB'];
List <int> idpti=[];
List <String> nomexp=[];
List <String> letra=['A', 'B', 'B', 'A', 'A', 'A', 'A', 'A', 'A', 'B', 'B', 'A', 'A', 'A', 'A'];
String valor='', valor3='', valor4='';
int valor2=0;
var seen = <String>{};
List<String> uniquelist = lg.centrales.where((country) => seen.add(country)).toList();
late ZoomPanBehavior _zoomPanBehavior;
late TooltipBehavior _tooltipBehavior;
class ChartData {
        ChartData(this.x, this.y0, this.y1, this.y2, this.y3, this.y4, this.y5, this.y6, this.y7, this.y8, this.y9, this.y10, this.y11, this.y12, this.y13, this.y14);
        final String x;
        final double y0;
        final double y1;
        final double y2;
        final double y3;
        final double y4;
        final double y5;
        final double y6;
        final double y7;
        final double y8;
        final double y9;
        final double y10;
        final double y11;
        final double y12;
        final double y13;
        final double y14;
}



class Graficoss extends StatefulWidget{
    const Graficoss({Key? key}): super(key: key);
    @override
   // ignore: library_private_types_in_public_api
   _Graficoss createState() => _Graficoss();
  }
int i=0;
class _Graficoss extends State<Graficoss>{
  final actual _currentUser = Get.put(actual());
List<BarSeries<ChartData, String>>? series;
  List<ChartData>? chartData;
  late int count;
      @override
    void initState(){
      valor=el.nombres[0];
      valor3=el.nombreidexportador;
      valor4=el.nuevoidexportador;
      count = 0;
      chartData = <ChartData>[
      ChartData('Ejemplo' ,0, 1 ,2,3,4,5,6,7,8,9,10,6,4,5,6),
    ];
      _tooltipBehavior = TooltipBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap);
     _zoomPanBehavior = ZoomPanBehavior(
                  enablePinching: true,
                  zoomMode: ZoomMode.x,
                  enablePanning: true
                );
      series = <BarSeries<ChartData, String>>[
      BarSeries<ChartData, String>(
        dataSource: chartData!,
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
      drawer: const drawerRanking(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          centerTitle: true,
          title: Text(dr.name.toString()),
          backgroundColor: const Color.fromRGBO(4, 43, 82, 1),
          actions: <Widget>[
            IconButton(onPressed: () async{
              var result= Connectivity().checkConnectivity();
              if(result==ConnectivityResult.none)
              {
                showDialogBox();
              }
              else{
                if(dr.b==1){
                  isSelected=false;
                  if(_currentUser.user.IDPERFIL==1)
                  {
                    siono=true;
                  }
                  variedad2();
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
                                    title: ChartTitle(text: 'Distribución de solidos solubles comparación industria \n Variedad $valor', alignment: ChartAlignment.center, textStyle: TextStyle(fontSize: 8, color: Colors.black)),
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
                                title: AxisTitle(text: '%', alignment: ChartAlignment.center, textStyle: TextStyle(fontSize: 8, color: Colors.black)),
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 7,
                                  color: Colors.black,
                                )  
                              ),
                              legend: Legend(
                                overflowMode: LegendItemOverflowMode.wrap,
                                isVisible: true,
                                position: LegendPosition.right,
                                borderColor: Colors.black, borderWidth: 2,
                                iconHeight: 9,
                                iconWidth: 9,
                                textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold)
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
  void _addSeries() {
    final List<ChartData> chartData1 = <ChartData>[];
    print(letra.length);
    if(letra.length==12)
    {
      chartData1.add(ChartData('SS < 16.5', calibre3[0], calibre3[1], calibre3[2], calibre3[3],calibre3[4], calibre3[5], calibre3[6], calibre3[7],calibre3[8], calibre3[9], calibre3[10], calibre3[11],0, 0, 0));
      chartData1.add(ChartData('SS 17.5 a 16.5 ', calibre2[0], calibre2[1], calibre2[2], calibre2[3],calibre2[4], calibre2[5], calibre2[6], calibre2[7],calibre2[8], calibre2[9], calibre2[10], calibre2[11],0, 0, 0));
      chartData1.add(ChartData('SS > 17.5' ,calibre1[0], calibre1[1], calibre1[2], calibre1[3],calibre1[4], calibre1[5], calibre1[6], calibre1[7],calibre1[8], calibre1[9], calibre1[10], calibre1[11], 0, 0, 0));
    }
    else if(letra.length==15)
    {
      chartData1.add(ChartData('SS < 16.5', calibre3[0], calibre3[1], calibre3[2], calibre3[3],calibre3[4], calibre3[5], calibre3[6], calibre3[7],calibre3[8], calibre3[9], calibre3[10], calibre3[11],calibre3[12], calibre3[13], calibre3[14]));
      chartData1.add(ChartData('SS 17.5 a 16.5 ', calibre2[0], calibre2[1], calibre2[2], calibre2[3],calibre2[4], calibre2[5], calibre2[6], calibre2[7],calibre2[8], calibre2[9], calibre2[10], calibre2[11],calibre2[12], calibre2[13], calibre2[14]));
      chartData1.add(ChartData('SS > 17.5', calibre1[0], calibre1[1], calibre1[2], calibre1[3],calibre1[4], calibre1[5], calibre1[6], calibre1[7],calibre1[8], calibre1[9], calibre1[10], calibre1[11],calibre1[12], calibre1[13], calibre1[14]));
    }
    else if(letra.length==8)
    {
      chartData1.add(ChartData('SS < 16.5', calibre3[0], calibre3[1], calibre3[2], calibre3[3],calibre3[4], calibre3[5], calibre3[6], calibre3[7],0,0,0,0,0, 0, 0));
      chartData1.add(ChartData('SS 17.5 a 16.5 ', calibre2[0], calibre2[1], calibre2[2], calibre2[3],calibre2[4], calibre2[5], calibre2[6], calibre2[7],0,0,0,0,0, 0, 0));
      chartData1.add(ChartData('SS > 17.5' ,calibre1[0], calibre1[1], calibre1[2], calibre1[3],calibre1[4], calibre1[5], calibre1[6], calibre1[7],0,0,0,0, 0, 0, 0));
    }
    else if(letra.length==13)
    {
      chartData1.add(ChartData('SS < 16.5', calibre3[0], calibre3[1], calibre3[2], calibre3[3],calibre3[4], calibre3[5], calibre3[6], calibre3[7],calibre3[8], calibre3[9], calibre3[10], calibre3[11],calibre3[12], 0, 0));
      chartData1.add(ChartData('SS 17.5 a 16.5 ', calibre2[0], calibre2[1], calibre2[2], calibre2[3],calibre2[4], calibre2[5], calibre2[6], calibre2[7],calibre2[8], calibre2[9], calibre2[10], calibre2[11],calibre2[12], 0, 0));
      chartData1.add(ChartData('SS > 17.5' ,calibre1[0], calibre1[1], calibre1[2], calibre1[3],calibre1[4], calibre1[5], calibre1[6], calibre1[7],calibre1[8], calibre1[9], calibre1[10], calibre1[11],calibre1[12], 0, 0));
    }
      
    for(int x=0; x<letra.length; x++)
    {
      if(x==0)
      {
        series!.add(BarSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        animationDuration: 1500, animationDelay: 1500, color: (idcolor[0].toColor()) ,name: letra[0],dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true,textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold))
                              ,spacing:0.2 ,width:0.9, 
        dataSource: chartData1,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y0
        ));
      }
      else if(x==1)
      {
        series!.add(BarSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        animationDuration: 1500, animationDelay: 1500, color: (idcolor[1].toColor()) ,name: letra[1],dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true,textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold))
                              ,spacing:0.2 ,width:0.9,
        dataSource: chartData1,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y1
        ));
      }
      else if(x==2)
      {
        series!.add(BarSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        animationDuration: 1500, animationDelay: 1500, color: (idcolor[2].toColor()) ,name: letra[2],dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true,textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold))
                              ,spacing:0.2 ,width:0.9,
        dataSource: chartData1,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y2
        ));
      }
      else if(x==3)
      {
        series!.add(BarSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        animationDuration: 1500, animationDelay: 1500, color: (idcolor[3].toColor()) ,name: letra[3],dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true,textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold))
                              ,spacing:0.2 ,width:0.9,
        dataSource: chartData1,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y3
        ));
      }
      else if(x==4)
      {
        series!.add(BarSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        animationDuration: 1500, animationDelay: 1500, color: (idcolor[4].toColor()) ,name: letra[4],dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true,textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold))
                              ,spacing:0.2 ,width:0.9,
        dataSource: chartData1,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y4
        ));
      }
      else if(x==5)
      {
        series!.add(BarSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        animationDuration: 1500, animationDelay: 1500, color: (idcolor[5].toColor()) ,name: letra[5],dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true,textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold))
                              ,spacing:0.2 ,width:0.9,
        dataSource: chartData1,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y5
        ));
      }
      else if(x==6)
      {
        series!.add(BarSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        animationDuration: 1500, animationDelay: 1500, color: (idcolor[6].toColor()) ,name: letra[6],dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true,textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold))
                              ,spacing:0.2 ,width:0.9,
        dataSource: chartData1,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y6
        ));
      }
      else if(x==7)
      {
        series!.add(BarSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        animationDuration: 1500, animationDelay: 1500, color: (idcolor[7].toColor()) ,name: letra[7],dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true,textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold))
                              ,spacing:0.2 ,width:0.9,
        dataSource: chartData1,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y7
        ));
      }
      else if(x==8)
      {
        series!.add(BarSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        animationDuration: 1500, animationDelay: 1500, color: (idcolor[8].toColor()) ,name: letra[8],dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true,textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold))
                              ,spacing:0.2 ,width:0.9,
        dataSource: chartData1,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y8
        ));
      }
      else if(x==9)
      {
        series!.add(BarSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        animationDuration: 1500, animationDelay: 1500, color: (idcolor[9].toColor()) ,name: letra[9],dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true,textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold))
                              ,spacing:0.2 ,width:0.9,
        dataSource: chartData1,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y9
        ));
      }
      else if(x==10)
      {
        series!.add(BarSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        animationDuration: 1500, animationDelay: 1500, color: (idcolor[10].toColor()) ,name: letra[10],dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true,textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold))
                              ,spacing:0.2 ,width:0.9,
        dataSource: chartData1,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y10
        ));
      }
      else if(x==11)
      {
        series!.add(BarSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        animationDuration: 1500, animationDelay: 1500, color: (idcolor[11].toColor()) ,name: letra[11],dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true,textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold))
                              ,spacing:0.2 ,width:0.9,
        dataSource: chartData1,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y11
        ));
      }
      else if(x==12)
      {
        series!.add(BarSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        animationDuration: 1500, animationDelay: 1500, color: (idcolor[12].toColor()) ,name: letra[12],dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true,textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold))
                              ,spacing:0.2 ,width:0.9,
        dataSource: chartData1,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y12
        ));
      }
      else if(x==13)
      {
        series!.add(BarSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        animationDuration: 1500, animationDelay: 1500, color: (idcolor[13].toColor()) ,name: letra[13],dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true,textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold))
                              ,spacing:0.2 ,width:0.9,
        dataSource: chartData1,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y13
        ));
      }
      else if(x==14)
      {
        series!.add(BarSeries<ChartData, String>(
        key: ValueKey<String>('${series!.length}'),
        animationDuration: 1500, animationDelay: 1500, color: (idcolor[14].toColor()) ,name: letra[14],dataLabelSettings: const DataLabelSettings( isVisible: true, showCumulativeValues: true,textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold))
                              ,spacing:0.2 ,width:0.9,
        dataSource: chartData1,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y14
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


    variedad2 ()async{
  ids=[];
    try
    {
      var rest = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLtabla2('/variedad.php'),),
      body: {
        'variedad':'1',
        'nomorderdesc': 'lopez'
      }
      ).timeout(const Duration(seconds: 8));
      //print(rest.body);
    if(rest.statusCode == 200)
      {
      var resBody2 = jsonDecode(rest.body);
      print(resBody2);
      if(resBody2['success']== true)
      {
        for (int x=0; x<=resBody2["nomvariedad"].length; x=x+1){
          ids.add(int.parse(resBody2["idvariedad"][x].toString()));
        }
      }
      else
      {
       print(resBody2);
      }
      }
      else
      {
        Fluttertoast.showToast(msg: "Error: No se pudo conectar con el servidor");
        Get.off(()=> Graficoss());
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

  aa1 () async{
    calibre1=[];
    calibre2=[];
    calibre3=[];
    idexp=[];
    letra=[];
    idcolor=[];
    idpti=[];
    nomexp=[];
    try {
var restssrs = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLtabla2("/extraer.php")),
      body: {
        'variedad': valor2.toString(),
        },
      ).timeout(const Duration(seconds: 7));
      if(restssrs.statusCode == 200)
      {
      var resBody2 = jsonDecode(restssrs.body);
      if(resBody2['success']== true)
      {
        for (int i=0; i<6;i++)
        {
          if(i==0)
          {
            for(int x=0; x<resBody2['Idexp'].length;x++){
              idexp.add(int.parse(resBody2["Idexp"][x].toString()));
            }
          }
          else if(i==1)
          {
            for(int x=0; x<resBody2['Letraid'].length;x++){
              letra.add(resBody2["Letraid"][x]);
            }
          }
          else if(i==2)
          {
            for(int x=0; x<resBody2['idcolor'].length;x++){
              idcolor.add(resBody2["idcolor"][x]);
            }
          }
          else if(i==3)
          {
            for(int x=0; x<resBody2['idpti'].length;x++){
              idpti.add(int.parse(resBody2["idpti"][x].toString()));
            }
          }
          else if(i==4)
          {
            for(int x=0; x<resBody2['nomexp'].length;x++){
              nomexp.add(resBody2["nomexp"][x]);
            }
          }
          else if(i==5)
          {
            for(int x=0; x<idexp.length; x++)
            {
              if(valor4==idpti[x].toString())
              {
                letra[x]=valor3;
              }
            }
          }
        }
        bb1();
      }
    else{
    }
      }
      else
      {
        Fluttertoast.showToast(msg: "Error: No se pudo conectar con el servidor");
        idcolor=['#8CFFFB', '#8CFFFB', '#8CFFFB', '#8CFFFB', '#8CFFFB','#8CFFFB', '#8CFFFB', '#8CFFFB', '#8CFFFB', '#8CFFFB','#8CFFFB', '#8CFFFB', '#8CFFFB', '#8CFFFB', '#8CFFFB'];
        letra=['A', 'B', 'B', 'A', 'A', 'A', 'A', 'A', 'A', 'B', 'B', 'A', 'A', 'A', 'A'];
        Get.off(()=> Graficoss());
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

bb1() async 
  {
    try
    {
      for(int i=0; i<letra.length;i++){
      var res = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLtabla2('/solidos.php')),
      body: {
        'variedad' : valor2.toString(),
        'nomorderdesc' : idexp[i].toString(),
      },
      ).timeout(const Duration(seconds: 7));
    if(res.statusCode == 200)
      {
      var resBodyOfLogin = jsonDecode(res.body);
      if(resBodyOfLogin['success']== true)
      {
        for(int i=0; i<3; i++)
        {
          if(i==0)
          {
            calibre1.add(double.parse(resBodyOfLogin["solid1"]));
          }
          else if(i==1)
          {
            calibre2.add(double.parse(resBodyOfLogin["solid2"]));
          }
          else if(i==2)
          {
            calibre3.add(double.parse(resBodyOfLogin["solid3"]));
          }
        }
        }
      else
      {
        for(int i=0; i<3; i++)
        {
          if(i==0)
          {
            calibre1.add(double.parse(resBodyOfLogin["solid1"]));
          }
          else if(i==1)
          {
            calibre2.add(double.parse(resBodyOfLogin["solid2"]));
          }
          else if(i==2)
          {
            calibre3.add(double.parse(resBodyOfLogin["solid3"]));
          }
        }
      }
      }
      else
      {
        Fluttertoast.showToast(msg: "Error: No se pudo conectar con el servidor");
        idcolor=['#8CFFFB', '#8CFFFB', '#8CFFFB', '#8CFFFB', '#8CFFFB','#8CFFFB', '#8CFFFB', '#8CFFFB', '#8CFFFB', '#8CFFFB','#8CFFFB', '#8CFFFB', '#8CFFFB', '#8CFFFB', '#8CFFFB'];
        letra=['A', 'B', 'B', 'A', 'A', 'A', 'A', 'A', 'A', 'B', 'B', 'A', 'A', 'A', 'A'];
        Get.off(()=> Graficoss());
      }
      }
      print(calibre1);
      setState(() {
        _addSeries();
      });
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
                  height: 410,
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
                                const Text('Exportador:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),),
                                siono? DropdownButton(
                                  isExpanded: true,
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(10),
                                  value: valor3,
                                  items: lg.exportador.map((e){
                                  return DropdownMenuItem(value: e,child: 
                                  Center(child: Text(e, textAlign: TextAlign.center,)),
                                  );
                                }).toList(), 
                                  onChanged: (e)
                                  {
                                    setState(() {
                                      for(int x=0; x<lg.id_exportador.length; x++)
                                      {
                                        if(e.toString()==lg.exportador[x])
                                        {
                                          valor3=e.toString();
                                          valor4=lg.id_exportador[x];
                                          valor3=e.toString();
                                          break;
                                        }
                                      }
                                    });
                                  }):
                                Padding(padding: EdgeInsets.all(8.0),
                                child:Text(el.nombreidexportador, style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),) )
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
                                  Center(child: Text(cate,textAlign: TextAlign.center,)),
                                  );
                                }).toList(),
                                onChanged: (cate) async {
                                  setState(() {
                                    valor=cate.toString();
                                    for (int i=0; i<el.nombres.length; i++)
                                    {
                                      if(valor==el.nombres[i])
                                      {
                                        valor2=ids[i];
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
                                if(valor2==0 && isSelected==false)
                                {
                                  isSelected=true;
                                  valor2=ids[0];
                                  valor=el.nombres[0];
                                  setState(() {
                                  series!.clear();
                                  aa1();
                                });
                                }
                                else if(valor2 !=0 && isSelected==false)
                                {
                                  isSelected=true;
                                  print(valor2);
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


 