// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proyecto/graficos/Tendencia/graficotendencia.dart';
import 'package:proyecto/graficos/Tendencia/graficotendencia2.dart';
import 'package:proyecto/users/loginuser/eleccion.dart' as el;
import 'package:proyecto/users/preferencias/preferencias.dart'; 
import '../users/loginuser/eleccion.dart';
import '../users/loginuser/login.dart' as lg;
import '../users/loginuser/login.dart';

String name="Control caja embalada";
String tipo="";
int b=2;
Future a(int i) async{
  
  if (i==1){
    return [name='Control caja embalada',
    b=2];
  }
  else if (i==2){
    return [name='Control calibre',
    tipo= 'calibre',
    b=2];
  }
  else if (i==3){
    return [name='Control peso',
    tipo = 'peso',
    b=1];
  }
  else if (i==4){
    return [name='Control comercial',
    b=1];
  }
  else if (i==5){
    return [name='Control retorno',
    b=4];
  }
  else if (i==0){
    return [name='Esperando elección',
    b=3];
  }
}

// ignore: camel_case_types
class drawertendencia extends StatelessWidget {
  const drawertendencia({super.key});
  cerrarsesion() async{
    var resultResponse = await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(''),
        content: const Text('¿Estas segur@ de querer cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () {Get.back();},
              child: const Text('No', style: TextStyle(color: Colors.black),)),
          TextButton(
            onPressed: () {Get.back(result: "Cerrar sesión");},
                child: const Text('Si', style: TextStyle(color: Colors.black),))
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
    return WillPopScope(onWillPop: () async{
      return false;
    },
    child: Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          Container(
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
                        accountEmail: const Text('Tendencia puntos criticos'),
                        currentAccountPicture: CircleAvatar(
                          child: ClipOval(child: Image.asset(el.foto),)    
                        ),
                        decoration: const  BoxDecoration(
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
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: SizedBox(
                                  height: 50,
                                  width: 225,
                                  child: ListTile(
                                    title: const Text('Control caja embalada', style: TextStyle(),),
                                    // ignore: avoid_returning_null_for_void
                                    onTap: () {
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) {
                                      return Graficoten();
                                      })), (route) => false);
                                      a(1);}
                                    ),),
                                ),
                            const SizedBox(width: 5,
                            height: 5,),
                                  Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: SizedBox(
                                  height: 50,
                                  width: 225,
                                  child: ListTile(
                                    title: const Text('Control calibre', style: TextStyle(),),
                                    // ignore: avoid_returning_null_for_void
                                    onTap: (){Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) {
                                      return const Graficoten2();
                                      })), (route) => false);
                                      a(2);}
                                    ),),
                                ),
                            const SizedBox(width: 5,
                            height: 5,),
                                  Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: SizedBox(
                                  height: 50,
                                  width: 225,
                                  child: ListTile(
                                    title: const Text('Control peso', style: TextStyle(),),
                                    // ignore: avoid_returning_null_for_void
                                    onTap: (){Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) {
                                      return const Graficoten2();
                                      })), (route) => false);
                                      a(3);}
                                    ),),
                                ),
                            const SizedBox(width: 5,
                            height: 5,),
                                  Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: SizedBox(
                                  height: 50,
                                  width: 225,
                                  child: ListTile(
                                    title: const Text('Control comercial', style: TextStyle(),),
                                    // ignore: avoid_returning_null_for_void
                                    onTap: () {Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) {
                                      return  Graficoten();
                                      })), (route) => false);
                                      a(4);}
                                    ),),
                                ),
                            const SizedBox(width: 5,
                            height: 5,),
                                  Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: SizedBox(
                                  height: 50,
                                  width: 225,
                                  child: ListTile(
                                    title: const Text('Control retorno', style: TextStyle(),),
                                    // ignore: avoid_returning_null_for_void
                                    onTap: () {Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) {
                                      return Graficoten();
                                      })), (route) => false);
                                      a(5);}
                                    ),),
                                ),
                            const SizedBox(width: 5,
                            height: 5,),
                                  Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: SizedBox(
                                  height: 50,
                                  width: 225,
                                  child: ListTile(
                                    leading: const Icon(Icons.home, color: Colors.black),
                                    title: const Text('Volver al inicio', style: TextStyle(fontWeight: FontWeight.bold),),
                                    // ignore: avoid_returning_null_for_void
                                    onTap: () {Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) {
                                      el.nombres=[];
                                      el.fruta='Ranking';
                                      lg.exportador=[];
                                      lg.centrales=[];
                                      lg.id_centrales=[];
                                      el.currentIndexs=0;
                                      return const Eleccion();
                                      })), (route) => false);}
                                    ),),
                                  ),
                                  Padding(
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
                                const SizedBox(
                                height: 15,),
                                Container(
                                  width: 123,
                                  height: 120,
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
        ],
      ),),
    );
  }
}