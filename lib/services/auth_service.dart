import '../database/db.dart' as db;
import '../models/usuario.dart';
import 'package:sqflite/sqflite.dart';


class AuthService {

  // Função para autenticar o usuário no banco de dados
  Future<Usuario?> authenticate(String username, String password) async {
    final dbInstance = await db.DB.instance.database;  // Usando alias para acessar a instância do DB

    // Realiza a consulta ao banco de dados
    final result = await dbInstance.query(
      'usuarios',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return Usuario.fromMap(result.first); // Retorna o usuário encontrado
    } else {
      return null; // Nenhum usuário encontrado
    }
  }

  // Função para verificar se o nome de usuário já existe
  Future<bool> isUsernameTaken(String username) async {
    final dbInstance = await db.DB.instance.database;
    final result = await dbInstance.query(
      'usuarios',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty; // Retorna true se o nome de usuário já estiver no banco
  }

  // Função para registrar um novo usuário
  Future<void> registerUser(Usuario usuario) async {
    final dbInstance = await db.DB.instance.database;
    bool isTaken = await isUsernameTaken(usuario.username);
    if (isTaken) {
      throw Exception("Nome de usuário já existe!");
    }
    await dbInstance.insert(
      'usuarios',
      usuario.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}



