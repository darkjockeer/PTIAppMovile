
class Constant{
  static const String DOMAIN="https://ptichile.com/WS/AppMovil";
  static const String PATH="/Especies/Arandanos";
  //Para el login user
  static const String hostConnectUser = "$DOMAIN/Informacion";
  static const String hostConnectInformes = "$DOMAIN/Informacion";
  // Para central y exportador
  static const String hostConnectInfoCentrales = "$DOMAIN/Informacion/Centrales";
  static const String hostConnectInfoExportadores = "$DOMAIN/Informacion/Exportadores";
  //Para tendencias
  static const String hostConnecttablas = "$DOMAIN$PATH/Tendencias";
  //Para Puntos criticos
  static const String hostConnecttablas4 = "$DOMAIN$PATH/PuntosCriticos";
 
  static const String WIFI_DISABLED="wifi_disabled";
  static const String CONNECTION_DISABLED="connection_disabled";
  static const String SERVER_ERROR="server_error";
  static const String MESSAGE="message";
}