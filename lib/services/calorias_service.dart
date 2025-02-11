import '../models/calorias_model.dart';
import '../database/db.dart' as db;

class CaloriasService {
  // Função para adicionar calorias no banco de dados
  Future<void> adicionarCalorias(Calorias calorias) async {
    try {
      final dbInstance = await db.DB.instance.database;
      final existingId = await checkIfCaloriasExists(calorias.diaDoMes, calorias.usuarioId);

      if (existingId != null) {
        // Se a data e o usuário já existem, chama a função de atualização
        await updateCalorias(calorias);
      } else {
        // Caso contrário, insere uma nova entrada
        await dbInstance.insert('calorias', calorias.toMap());
      }
    } catch (e) {
      throw Exception('Erro ao adicionar calorias: $e');
    }
  }

  // Função para atualizar calorias no banco de dados
Future<void> updateCalorias(Calorias caloriasObj) async {

  final dbInstance = await db.DB.instance.database;

  // Executando o UPDATE diretamente no banco
  await dbInstance.update(
    'calorias', // Nome da tabela
    caloriasObj.toMap(), // Mapeia o objeto para o formato Map
    where: 'id = ?', // Condição para encontrar o registro correto
    whereArgs: [caloriasObj.id], // Passa o id do objeto
  );
}


  // Função para verificar se já existe uma entrada para a mesma data e usuário
  Future<int?> checkIfCaloriasExists(DateTime date, int usuarioId) async {
  final dbInstance = await db.DB.instance.database;

  final List<Map<String, dynamic>> result = await dbInstance.query(
    'calorias',
    where: 'dia_do_mes = ? AND usuario_id = ?',
    whereArgs: [
      date.millisecondsSinceEpoch,
      usuarioId,
    ],
  );

  // Retorna o ID se existir, ou null se não existir
  if (result.isNotEmpty) {
    return result.first['id'];  // Retorna o ID do primeiro registro encontrado
  }

  return null;  // Retorna null se não encontrar nenhum registro
}

  // Função para obter todas as calorias no banco de dados para um usuário específico
  Future<List<Calorias>> getAllCalorias(int usuarioId) async {
    try {
      final dbInstance = await db.DB.instance.database;
      final List<Map<String, dynamic>> maps = await dbInstance.query(
        'calorias',
        where: 'usuario_id = ?', // Filtra pelo ID do usuário
        whereArgs: [usuarioId],
      );

      return List.generate(maps.length, (i) {
        return Calorias.fromMap(maps[i]);
      });
    } catch (e) {
      throw Exception('Erro ao obter calorias: $e');
    }
  }
}
