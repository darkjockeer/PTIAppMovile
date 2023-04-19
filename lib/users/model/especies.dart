// ignore_for_file: non_constant_identifier_names


class Especiess{
  int IDESPECIE;

  Especiess(
    this.IDESPECIE,
  );

  factory Especiess.fromJson(Map<String, dynamic> json) => Especiess(
    int.parse(json["IDESPECIE"]),
  );
    
  Map<String, dynamic> toJson() =>
  {
    'IDESPECIE':IDESPECIE.toString(),
  };

  

}