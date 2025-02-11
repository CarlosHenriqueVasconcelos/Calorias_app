class Usuario {
  final int? id;
  final String username;
  final String password;

  Usuario({this.id, required this.username, required this.password});

  // Convertendo de um Map para o modelo
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      username: map['username'],
      password: map['password'],
    );
  }

  // Convertendo de um modelo para um Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }
}
