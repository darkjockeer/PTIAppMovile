import 'package:proyecto/api_connection/Constant.dart';


class EndPoints {



  static generateEndPointsURL(resource){
    return Constant.hostConnectUser+resource;
  }


  static generateEndPointsURLInfo(resource){
    return Constant.hostConnectInfo+resource;
  }

  static generateEndPointsURLmasInfo(resource){
    return Constant.hostConnectmasInfo+resource;
  }

  static generateEndPointsURLtabla(resource){
    return Constant.hostConnecttablas+resource;
  }

  static generateEndPointsURLtabla2(resource){
    return Constant.hostConnecttablas2+resource;
  }

  static generateEndPointsURLtabla3(resource){
    return Constant.hostConnecttablas3+resource;
  }

  static generateEndPointsURLtabla4(resource){
    return Constant.hostConnecttablas4+resource;
  }
}