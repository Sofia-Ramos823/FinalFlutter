class TipoApartamento {
  String id;
  String tipoApto;
  String descripcionApto;
  int capacidadApto;
  String tamanoApto;
  String estado;

  // Constructor
  TipoApartamento({
    required this.id,
    required this.tipoApto,
    required this.descripcionApto,
    required this.capacidadApto,
    required this.tamanoApto,
    required this.estado,
  });

  // Método para convertir un JSON a un objeto de TipoApartamento
  factory TipoApartamento.fromJson(Map<String, dynamic> json) {
    return TipoApartamento(
      id: json['_id'] ?? '',
      tipoApto: json['tipoApto'] ?? '',
      descripcionApto: json['descripcionApto'] ?? '',
      capacidadApto: json['capacidadApto'] ?? 0,
      tamanoApto: json['tamanoApto'] ?? '',
      estado: json['estado'] ?? 'activo',
    );
  }

  // Método para convertir un objeto de TipoApartamento a JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'tipoApto': tipoApto,
      'descripcionApto': descripcionApto,
      'capacidadApto': capacidadApto,
      'tamanoApto': tamanoApto,
      'estado': estado,
    };
  }
}
