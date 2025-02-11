import '../models/calorias_model.dart';
import '../database/db.dart' as db;

class CaloriasService {
  // Função para adicionar calorias no banco de dados
  Future<void> adicionarCalorias(Calorias calorias) async {
    try {
      final dbInstance = await db.DB.instance.database;
      final exists = await checkIfCaloriasExists(calorias.diaDoMes, calorias.usuarioId);

      if (exists) {
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
  Future<void> updateCalorias(Calorias calorias) async {
    try {
      final dbInstance = await db.DB.instance.database;
      await dbInstance.update(
        'calorias',
        calorias.toMap(),
        where: 'dia_do_mes = ? AND usuario_id = ?', // Atualiza para o usuário e data específicos
        whereArgs: [calorias.diaDoMes.millisecondsSinceEpoch, calorias.usuarioId],
      );
    } catch (e) {
      throw Exception('Erro ao atualizar calorias: $e');
    }
  }

  // Função para verificar se já existe uma entrada para a mesma data e usuário
  Future<bool> checkIfCaloriasExists(DateTime date, int usuarioId) async {
    try {
      final dbInstance = await db.DB.instance.database;
      final List<Map<String, dynamic>> maps = await dbInstance.query(
        'calorias',
        where: 'dia_do_mes = ? AND usuario_id = ?', // Verifica a data e o ID do usuário
        whereArgs: [date.millisecondsSinceEpoch, usuarioId],
      );

      return maps.isNotEmpty; // Retorna true se já existir, caso contrário false
    } catch (e) {
      throw Exception('Erro ao verificar calorias: $e');
    }
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