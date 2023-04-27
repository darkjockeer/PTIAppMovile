// ignore_for_file: import_of_legacy_library_into_null_safe, unused_local_variable

import 'dart:async';
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto/drawers/drawersegregacion.dart';
import '../../api_connection/Endpoints/EndPoinstCerezas.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/drawers/drawersegregacion.dart' as dr;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:proyecto/users/loginuser/login.dart' as lg;
import 'package:proyecto/users/loginuser/eleccion.dart' as el;

import '../../users/preferencias/actual.dart';
bool isSelected= false, siono=false, siocen=false;
String id='77';
String idexport='';
int i=0;
String valor='';
String valor6='', valor7='',central='';
int valor2=0;
List<String> orueba=['N', 'C.O','RC(3-3.5-3.8)','FC-RCL-R'];
var seen = <String>{};
List<String> uniquelist = lg.centrales.where((country) => seen.add(country)).toList();
late TooltipBehavior _tooltipBehavior;
class ChartData {
        ChartData(this.x, this.y0);
        final String x;
        final double y0;

}

List <double> calibre1=[];
List <double> calibre2=[];
List <String> calibre3=['Blando', 'Sensible', 'Firme', 'Muy Firme'];

class firmeza extends StatefulWidget{
    const firmeza ({Key? key}): super(key: key);
    @override
   // ignore: library_private_types_in_public_api
   _firmeza  createState() => _firmeza ();
  }

class _firmeza  extends State<firmeza >{
  final actual _currentUser = Get.put(actual());
  List<PieSeries<ChartData, String>>? series;
  List<PieSeries<ChartData, String>>? series3;
  List<ChartData>? chartData;
  late int count;
        @override
    void initState(){
      valor6=el.nombreidexportador;;
      valor7=lg.centrales[0];
      id=lg.id_centrales[0];
      count = 0;
      chartData = <ChartData>[
      ChartData('Ejemplo', 0.9),
    ];
      _tooltipBehavior = TooltipBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap);
        series = <PieSeries<ChartData, String>>[
      PieSeries<ChartData, String>(
        dataSource: chartData!,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y0,
        dataLabelSettings: DataLabelSettings(isVisible: true, labelPosition: ChartDataLabelPosition.outside),
        sortingOrder: SortingOrder.ascending,
        sortFieldValueMapper: (ChartData data,_) =>data.x,
      ),
    ];
    series3 = <PieSeries<ChartData, String>>[
      PieSeries<ChartData, String>(
        dataSource: chartData!,
        xValueMapper: (ChartData sales, _) => sales.x,
        yValueMapper: (ChartData sales, _) => sales.y0,
        dataLabelSettings: DataLabelSettings(isVisible: true, labelPosition: ChartDataLabelPosition.outside),
        sortingOrder: SortingOrder.ascending,
        sortFieldValueMapper: (ChartData data,_) =>data.x,
      ),
    ];
      super.initState();
    }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      drawer: const drawersegregacion(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          centerTitle: true,
          title: Text(dr.name.toString(), 
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),),
          backgroundColor: const Color.fromRGBO(4, 43, 82, 1),
            actions: <Widget>[
            IconButton(onPressed: () {
              if(dr.b==1){
                valor2=0;
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
                                width: MediaQuery.of(context).size.width-30,
                                height: MediaQuery.of(context).size.height,
                                child: SfCircularChart(
                                  title: ChartTitle(
                                    text: 'Firmeza exportadora \n Variedad $valor',
                                    backgroundColor: Colors.transparent,
                                    alignment: ChartAlignment.center,
                                    textStyle: const TextStyle(color:Colors.black, fontFamily: 'Roboto', fontStyle: FontStyle.italic, fontSize: 10)
                                  ),
                                  tooltipBehavior: _tooltipBehavior,
                                  legend: Legend(
                                overflowMode: LegendItemOverflowMode.wrap,
                                isVisible: true,
                                position: LegendPosition.bottom,
                                borderColor: Colors.black, borderWidth: 2,
                                iconHeight: 9,
                                iconWidth: 9,
                                textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold)
                              ),
                                  series: series,
                                )
                              ),),),
              SizedBox(
                height: 5,
              ),
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
                              child: SfCircularChart(
                                  title: ChartTitle(
                                    text: 'Firmeza industria \n Variedad $valor',
                                    backgroundColor: Colors.transparent,
                                    alignment: ChartAlignment.center,
                                    textStyle: const TextStyle(color:Colors.black, fontFamily: 'Roboto', fontStyle: FontStyle.italic, fontSize: 10)
                                  ),
                                  tooltipBehavior: _tooltipBehavior,
                                  legend: Legend(
                                overflowMode: LegendItemOverflowMode.wrap,
                                isVisible: true,
                                position: LegendPosition.bottom,
                                borderColor: Colors.black, borderWidth: 2,
                                iconHeight: 9,
                                iconWidth: 9,
                                textStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold)
                              ),
                                  series: series3,
                                )
                            ),
                          ),), const SizedBox(
                height: 1,),
                  const SizedBox(
                height: 5,),
            ],
          ),
        )
      ),
    );
}
void _addSeries() {
  final List<ChartData> chartData1 = <ChartData>[];
  final List<ChartData> chartData2 = <ChartData>[];
  for(int x=0; x<calibre1.length; x++)
  {
    chartData1.add(ChartData(calibre3[x] ,calibre1[x]));
  }
  for(int i=0; i<calibre2.length; i++)
  {
    chartData2.add(ChartData(calibre3[i] ,calibre2[i]));
  }
  for(int x=0; x<2; x++)
  {
    print(x);
    if(x==0)
    {
      
      series!.add(PieSeries<ChartData, String>(
      key: ValueKey<String>('${series3!.length}'),
      dataSource: chartData1,
      dataLabelSettings: DataLabelSettings(isVisible: true, labelPosition: ChartDataLabelPosition.outside),
      xValueMapper: (ChartData sales, _) => sales.x,
      yValueMapper: (ChartData sales, _) => sales.y0,
      sortingOrder: SortingOrder.ascending,
      sortFieldValueMapper: (ChartData data,_) =>data.x,
      ));
    }
    else if(x==1)
    {
      series3!.add(PieSeries<ChartData, String>(
      key: ValueKey<String>('${series3!.length}'),
      dataSource: chartData2,
      dataLabelSettings: DataLabelSettings(isVisible: true, labelPosition: ChartDataLabelPosition.outside),
      xValueMapper: (ChartData sales, _) => sales.x,
      yValueMapper: (ChartData sales, _) => sales.y0,
      sortingOrder: SortingOrder.ascending,
      sortFieldValueMapper: (ChartData data,_) =>data.x,
      ));
    }
  }
  isSelected=false;
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

    try {
  var restssrs = await http.post(
      Uri.parse(EndPoints.generateEndPointsURLtabla3("/firmeza.php")),
      body: {
        'idcentral': id,
        'idvariedad': valor2.toString(),
        },
      ).timeout(const Duration(seconds: 6));
      print(restssrs.body);
      if(restssrs.statusCode == 200)
      {
      var resBody2 = jsonDecode(restssrs.body);
      if(resBody2['success']== true)
      {
        for (int i=0; i<4;i++)
        {
          print('Numero $i');
          if(i==0)
          {
            for(int x=0; x<resBody2['valorexp'].length;x++){
                calibre1.add(double.parse(resBody2["valorexp"][x]));
            }
          }
          else if(i==1)
          {
            for(int x=0; x<resBody2['valorexp2'].length;x++){
                calibre2.add(double.parse(resBody2["valorexp2"][x]));
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
        Get.off(()=> firmeza());
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
      Uri.parse(EndPoints.generateEndPointsURLInfoExportadores("/Exportadores.php")),
      body: {
        'nomexportador': valor
      },
    ).timeout(const Duration(seconds: 6)); 
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
    Uri.parse(EndPoints.generateEndPointsURLInfoExportadores("/ExportadoresxControlCaja.php")),
      body: {
        'idlogin' : lg.idlogin,
        'idperfil' : lg.idperfil,
        'idcentral': lg.idcentral,
        'idexportador' : idexport
      },
    ).timeout(const Duration(seconds: 6));
    if(rests.statusCode == 200)
    {
      var resBody3 = jsonDecode(rests.body);
      if(resBody3['success1']== true)
      {
        for (int x=0; x<resBody3["userData1"].length; x=x+1)
        {
          lg.centrales.add(resBody3["userData1"][x]["NOMCENTRAL"]);
        }
      }
      else
      {
        lg.centrales.add(resBody3["userData1"][0]["NOMCENTRAL"]);
      }
    }
  }
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
      ).timeout(const Duration(seconds: 6));
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
                                    print(valor);
                                    for (int i=0; i<el.nombres.length; i++)
                                    {
                                      if(valor==el.nombres[i])
                                      {
                                        print(valor2);
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
                                if(valor2==0 && isSelected==false)
                                {
                                  isSelected=true;
                                  valor2=int.parse(el.id_nombres[0]);
                                  valor=el.nombres[0];
                                  setState(() {
                                  series!.clear();
                                  series3!.clear();
                                  aa1();
                                  });
                                }
                                else if(valor2 !=0 && isSelected==false){
                                  isSelected=true;
                                  setState(() {
                                  series!.clear();
                                  series3!.clear();
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

}