class Vegetal {
  int codigo;
  String descripcion;
  double precio;

  Vegetal({
    required this.codigo,
    required this.descripcion,
    required this.precio
  });

  factory Vegetal.fromJson(Map<String, dynamic> json) => Vegetal(
      codigo: json['codigo'],
      descripcion: json['descripcion'],
      precio: json['precio']
  );

  Map<String, dynamic> toJson() => {
    'codigo': codigo,
    'descripcion': descripcion,
    'precio': precio
  };
}