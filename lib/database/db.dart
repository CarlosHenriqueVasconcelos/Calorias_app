import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  // Construtor com acesso privado
  DB._();

  // Criar uma instância de DB
  static final DB instance = DB._();

  // Instância do SQLite
  static Database? _database;

  // Getter para o banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Inicialização do banco de dados
  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'calorias.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Criação das tabelas
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(_usuarios);
    await db.execute(_calorias);
  }

  // Script para criar a tabela de usuários
  String get _usuarios => '''
    CREATE TABLE usuarios (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL
    );
  ''';

  // Script para criar a tabela de calorias com chave estrangeira
  String get _calorias => '''
    CREATE TABLE calorias (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      usuario_id INTEGER NOT NULL, -- Chave estrangeira para identificar o usuário
      dia_do_mes INTEGER NOT NULL,  
      calorias_consumidas INTEGER NOT NULL,
      latitude REAL,
      longitude REAL,
      FOREIGN KEY (usuario_id) REFERENCES usuarios (id) ON DELETE CASCADE
    );
  ''';

  // Função para inserir dados genéricos
  Future<int> inserir(String tabela, Map<String, dynamic> dados) async {
    final db = await database;
    return await db.insert(
      tabela,
      dados,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Função para obter todos os registros de uma tabela
  Future<List<Map<String, dynamic>>> obterTodos(String tabela) async {
    final db = await database;
    return await db.query(tabela);
  }

  // Função para atualizar calorias
  Future<int> updateCalorias(Map<String, dynamic> calorias, int diaDoMes, int usuarioId) async {
    final db = await database;
    return await db.update(
      'calorias',
      calorias, // Contém todos os dados (incluindo calorias, latitude, longitude)
      where: 'dia_do_mes = ? AND usuario_id = ?',
      whereArgs: [diaDoMes, usuarioId],
    );
  }
}
