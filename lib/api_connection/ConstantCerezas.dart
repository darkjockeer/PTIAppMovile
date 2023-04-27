// ignore_for_file: constant_identifier_names

class Constant{
  static const String DOMAIN="https://ptichile.com/WS/AppMovil";
  static const String PATH="/Especies/Cerezas";
  //Para el login user
  static const String hostConnectUser = "$DOMAIN/Informacion";
  static const String hostConnectInformes = "$DOMAIN/Informacion";
  // Para central y exportador
  static const String hostConnectInfoCentrales = "$DOMAIN/Informacion/Centrales";
  static const String hostConnectInfoExportadores = "$DOMAIN/Informacion/Exportadores";

  static const String hostConnecttablas = "$DOMAIN$PATH/Tendencias";

  static const String hostConnecttablas2 = "$DOMAIN$PATH/Rankings";

  static const String hostConnecttablas3 = "$DOMAIN$PATH/Segregacion";

  static const String hostConnecttablas4 = "$DOMAIN$PATH/PuntosCriticos";

  static const String pdf="https://controlcalidad.ptichile.com/puntocritico/views/cerezas/imprimir?turno=0&fecha=12-12-2022&sp=1&idm=1&central=9&exp=6";
  static const String WIFI_DISABLED="wifi_disabled";
  static const String CONNECTION_DISABLED="connection_disabled";
  static const String SERVER_ERROR="server_error";
  static const String MESSAGE="message";

}