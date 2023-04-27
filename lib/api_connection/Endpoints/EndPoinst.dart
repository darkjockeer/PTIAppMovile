import 'package:proyecto/api_connection/Constant.dart';


class EndPoints {
  static generateEndPointsURLInformes(resource){
    return Constant.hostConnectInformes+resource;
  }
  static generateEndPointsURLcerezas(resource){
    return Constant.hostConnecttablascerezas+resource;
  }
  static generateEndPointsURLpomaceas(resource){
    return Constant.hostConnecttablaspomaceas+resource;
  }
  static generateEndPointsURLcarozos(resource){
    return Constant.hostConnecttablascarozos+resource;
  }
  static generateEndPointsURLkiwis(resource){
    return Constant.hostConnecttablaskiwis+resource;
  }
  static generateEndPointsURLarandanos(resource){
    return Constant.hostConnecttablasarandanos+resource;
  }
  static generateEndPointsURLuvas(resource){
    return Constant.hostConnecttablasuvas+resource;
  }
}