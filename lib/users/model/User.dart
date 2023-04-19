// ignore_for_file: non_constant_identifier_names


class User{
  int IDLOGIN;
  int IDPERFIL;
  int IDESPECIE;
  int IDCENTRAL;
  int IDEXPORTADOR;
  String USUARIO;
  String PASS;
  String CONFESPECIE;

  User(
    this.IDLOGIN,
    this.IDPERFIL,
    this.IDESPECIE,
    this.IDCENTRAL,
    this.IDEXPORTADOR,
    this.USUARIO,
    this.PASS,
    this.CONFESPECIE,
  );

  factory User.fromJson(Map<String, dynamic> json) => User(
    int.parse(json["IDLOGIN"]),
    int.parse(json["IDPERFIL"]),
    int.parse(json["IDESPECIE"]),
    int.parse(json["IDCENTRAL"]),
    int.parse(json["IDEXPORTADOR"]),
    json["USUARIO"],
    json["PASS"],
    json["CONFESPECIE"],
  );
    
  Map<String, dynamic> toJson() =>
  {
    'IDLOGIN':IDLOGIN.toString(),
    'IDPERFIL': IDPERFIL.toString(),
    'IDESPECIE':IDESPECIE.toString(),
    'IDCENTRAL':IDCENTRAL.toString(),
    'IDEXPORTADOR': IDEXPORTADOR.toString(),
    'USUARIO':USUARIO[0].toUpperCase()+USUARIO.substring(1),
    'PASS':PASS,
    'CONFESPECIE':CONFESPECIE,
  };

}