// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyecto/graficos/Ranking/GraficoT.dart';
import 'package:proyecto/graficos/Ranking/graficocolor.dart';
import 'package:proyecto/graficos/Ranking/graficoexportable.dart';
import 'package:proyecto/graficos/Ranking/graficofirmeza.dart';
import 'package:proyecto/graficos/Ranking/graficoss.dart';
import 'package:proyecto/users/loginuser/eleccion.dart' as el;
import '../graficos/Ranking/graficosegregacion.dart';
import '../users/loginuser/eleccion.dart';
import '../users/loginuser/login.dart';
import 'package:proyecto/users/loginuser/login.dart' as lg;
import 'package:proyecto/users/preferencias/preferencias.dart';

String name='Ranking de segregación';
int b=1;

Future a(int i) async{
  
  if (i==1){
    return [name='Ranking de segregación',
    b=1];
  }
  else if (i==2){
    return [name='Ranking de calibre', b=1];
  }
  else if (i==3){
    return [name='Ranking de color', b=1];
  }
  else if (i==4){
    return [name='Ranking de S.S.', b=1];
  }
  else if (i==5){
    return [name='Ranking de Firmeza', b=1];
  }
  else if (i==6){
    return [name='Ranking exportable', b=1];
  }
}
class drawerRanking extends StatefulWidget{
    const drawerRanking({Key? key}): super(key: key);
    @override
   // ignore: library_private_types_in_public_api
   _drawerRanking createState() => _drawerRanking();
  }
// ignore: camel_case_types
class _drawerRanking extends State<drawerRanking> {
  @override
  void initState() {
    Graficossegregacion;
    GraficoT;
    Graficoscolor;
    Graficoss;
    Graficosfirmeza;
    Graficoexp;
    super.initState();
  }
  cerrarsesion() async{
    var resultResponse = await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(''),
        content: const Text('¿Estas segur@ de querer cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () {Get.back();},
              child: Text('No', style: TextStyle(color: Colors.black),)),
          TextButton(
            onPressed: () {Get.back(result: "Cerrar sesión");},
                child: Text('Si', style: TextStyle(color: Colors.black),))
                ],
                  ),
                );
        if(resultResponse=="Cerrar sesión")
        {
          el.nombres=[];
          el.fruta='Informe puntos críticos';
          lg.exportador=[];
          lg.centrales=[];
          lg.id_centrales=[];
          el.currentIndexs=0;
          preferencias.removeUserInfo().then((value){
          Get.off(const login());
            });
            }
          }
  @override
  Widget build(BuildContext context) {
    
    return WillPopScope(
      onWillPop: () async { 
        return false;
       },
      child: Drawer(
        child: ListView(
          // Remove padding
          padding: EdgeInsets.zero,
          children: [
           SingleChildScrollView(
              child: Container(
                width: 500,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 230,
                          height: MediaQuery.of(context).size.height-550,
                          child: UserAccountsDrawerHeader(
                            accountName: const Text('MENU'),
                            accountEmail: const Text('Ranking'),
                            currentAccountPicture: CircleAvatar(
                              child: ClipOval(child: Image.asset(el.foto),) 
                              ),
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(4, 43, 82, 1),
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height-550,
                          width: 74,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/w.jpg"),
                              fit: BoxFit.cover)
                          ),
                          child: Column(
                            children: [
                              Container(
                            height: MediaQuery.of(context).size.height-558,
                            width: 74,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(4, 43, 82, 1),
                            ),
                          )
                            ],
                          ),),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 550,
                      decoration: const BoxDecoration(color: Colors.transparent),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 230,
                            height: 550,
                            decoration: const BoxDecoration(
                              color: Colors.transparent
                              ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 25, height: 0,),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: SizedBox(
                                        height: 50,
                                        width: 225,
                                        child: ListTile(
                                          title: const Text('Ranking de segregación', style: TextStyle(),),
                                          // ignore: avoid_returning_null_for_void
                                          onTap: (){
                                              a(1);
                                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) {
                                              return Graficossegregacion();
                                            })), (route) => false);
                                            },
                                          ),),
                                      ),
                                    ),
                                      Expanded(
                                        child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: SizedBox(
                                        height: 50,
                                        width: 225,
                                        child: ListTile(
                                          title: const Text('Ranking de calibre', style: TextStyle(),),
                                          // ignore: avoid_returning_null_for_void
                                          onTap: () {
                                            a(2);
                                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) {
                                              return GraficoT();
                                            })), (route) => false);
                                            },
                                          ),),
                                    ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: SizedBox(
                                        height: 50,
                                        width: 225,
                                        child: ListTile(
                                          title: const Text('Ranking de color', style: TextStyle(),),
                                          // ignore: avoid_returning_null_for_void
                                          onTap: () {
                                            a(3);
                                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) {
                                              return Graficoscolor();
                                            })), (route) => false);
                                          }
                                          ),),
                                    ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: SizedBox(
                                        height: 50,
                                        width: 225,
                                        child: ListTile(
                                          title: const Text('Ranking solidos solubles', style: TextStyle(),),
                                          // ignore: avoid_returning_null_for_void
                                          onTap: () {
                                            a(4);
                                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) {
                                              return Graficoss();
                                            })), (route) => false);
                                          }
                                          ),),
                                    ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: SizedBox(
                                        height: 50,
                                        width: 225,
                                        child: ListTile(
                                          title: const Text('Ranking de firmeza', style: TextStyle(),),
                                          // ignore: avoid_returning_null_for_void
                                          onTap: () {
                                            a(5);
                                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) {
                                              return Graficosfirmeza();
                                            })), (route) => false);
                                          }
                                          ),),
                                    ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: SizedBox(
                                        height: 50,
                                        width: 225,
                                        child: ListTile(
                                          title: const Text('Ranking exportable', style: TextStyle(),),
                                          // ignore: avoid_returning_null_for_void
                                          onTap: () {
                                            a(6);
                                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) {
                                              return Graficoexp();
                                            })), (route) => false);
                                          }
                                          ),),
                                    ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: SizedBox(
                                        height: 50,
                                        width: 225,
                                        child: ListTile(
                                          leading: const Icon(Icons.home, color: Colors.black),
                                          title: const Text('Volver al inicio', style: TextStyle(fontWeight: FontWeight.bold),),
                                          // ignore: avoid_returning_null_for_void
                                          onTap: () {
                                            el.nombres=[];
                                            el.fruta='Ranking';
                                            lg.exportador=[];
                                            lg.centrales=[];
                                            lg.id_centrales=[];
                                            el.currentIndexs=0;
                                            Get.to(()=>Eleccion());
                                          }),),
                                    ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: SizedBox(
                                        height: 50,
                                        width: 225,
                                        child: ListTile(
                                          leading: const Icon(Icons.exit_to_app, color: Colors.black),
                                          title: const Text('Cerrar sesión', style: TextStyle(fontWeight: FontWeight.bold),),
                                          // ignore: avoid_returning_null_for_void
                                          onTap: () {
                                            cerrarsesion();
                                          }
                                          ),),
                                        ),
                                      ),
                                    Container(
                                      width: 100,
                                      height: 78,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage("assets/images/logoo.png"),
                                        fit: BoxFit.fitWidth)
                                      ),
                                    ),
                                    ],
                            ),
                          ),
                          Container(
                            width: 74,
                            height: 550,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/w.jpg"),
                            fit: BoxFit.cover)
                            )),
                        ],
                      ),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}