class Calorias {
  final int? id;
  final int usuarioId; // Adicionado campo para associar ao usuário
  final DateTime diaDoMes; // Alterado para DateTime
  final int caloriasConsumidas;
  final double? latitude;
  final double? longitude;

  Calorias({
    this.id,
    required this.usuarioId, // Campo obrigatório
    required this.diaDoMes, // Agora é DateTime
    required this.caloriasConsumidas,
    this.latitude,
    this.longitude,
  });

  // Converter do banco de dados para o modelo
  factory Calorias.fromMap(Map<String, dynamic> map) {
    return Calorias(
      id: map['id'],
      usuarioId: map['usuario_id'], // Novo campo
      diaDoMes: DateTime.fromMillisecondsSinceEpoch(map['dia_do_mes']), // Convertendo para DateTime
      caloriasConsumidas: map['calorias_consumidas'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  // Converter do modelo para um Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario_id': usuarioId, // Novo campo
      'dia_do_mes': diaDoMes.millisecondsSinceEpoch, // Convertendo para timestamp
      'calorias_consumidas': caloriasConsumidas,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
