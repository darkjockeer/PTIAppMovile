import 'package:proyecto/api_connection/ConstantUvas.dart';


class EndPoints {
  static generateEndPointsURL(resource){
    return Constant.hostConnectUser+resource;
  }
  static generateEndPointsURLInformes(resource){
    return Constant.hostConnectInformes+resource;
  }
  static generateEndPointsURLtabla(resource){
    return Constant.hostConnecttablas+resource;
  }
  static generateEndPointsURLtabla4(resource){
    return Constant.hostConnecttablas4+resource;
  }
}