//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:proyecto/users/loginuser/eleccion.dart';
import 'package:proyecto/users/loginuser/login.dart';
import 'package:proyecto/users/model/noti.dart';
import 'package:proyecto/users/preferencias/preferencias.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  await initNotifications();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity),
            localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('es'), // Spanish
      ],
        home: FutureBuilder(
          future: preferencias.redUserInfo(),
          builder:((context, snapshot) {
            
            if(snapshot.data == null){
              return const login();
            }
            else
            {
              return const Eleccion();
            }
          })),
      ),
    );
  }
}