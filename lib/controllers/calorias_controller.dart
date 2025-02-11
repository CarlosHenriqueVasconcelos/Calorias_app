import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../services/calorias_service.dart';
import '../services/localizacao_service.dart';
import '../models/calorias_model.dart';
import '../database/db.dart';
import 'package:flutter/material.dart';

class CaloriasController extends GetxController {
  var caloriasError = ''.obs;
  var successMessage = ''.obs;
  var locationMessage = ''.obs;
  var caloriasList = <Calorias>[].obs; // Lista para armazenar as calorias

  final CaloriasService caloriasService = CaloriasService();
  final LocationService locationService = LocationService();

  // Método para adicionar calorias
  Future<void> addCalorias({
  required DateTime date,
  required int calorias,
  required int usuarioId, // Recebe o ID do usuário
  required BuildContext context,
}) async {
  try {
    // Obtém a latitude e longitude da localização
    String location = locationMessage.value;
    double? latitude = location.isNotEmpty ? double.tryParse(location.split(',')[0].split(':')[1].trim()) : null;
    double? longitude = location.isNotEmpty ? double.tryParse(location.split(',')[1].split(':')[1].trim()) : null;

    // Cria o objeto Calorias
    Calorias caloriasObj = Calorias(
      diaDoMes: date,
      caloriasConsumidas: calorias,
      latitude: latitude,
      longitude: longitude,
      usuarioId: usuarioId, // Adiciona o ID do usuário ao objeto
    );

    // Verificar se já existe uma entrada para a mesma data e usuário
    int? existingId = await caloriasService.checkIfCaloriasExists(date, usuarioId);

    if (existingId != null) {

      caloriasObj = Calorias(
        id: existingId, // Atribui o id existente ao objeto
        usuarioId: caloriasObj.usuarioId,
        diaDoMes: caloriasObj.diaDoMes,
        caloriasConsumidas: caloriasObj.caloriasConsumidas,
        latitude: caloriasObj.latitude,
        longitude: caloriasObj.longitude,
      );
      await caloriasService.updateCalorias(caloriasObj);
      successMessage.value = 'Calorias atualizadas com sucesso!';
    } else {
      // Caso contrário, adicione uma nova entrada
      await caloriasService.adicionarCalorias(caloriasObj);
      successMessage.value = 'Calorias adicionadas com sucesso!';
    }

    caloriasError.value = ''; // Limpa erros

    // Recarregar os dados de calorias após a operação
    await getCalorias(usuarioId);

    // Exibe o AlertDialog de sucesso
    _showSuccessDialog(context);

  } catch (e) {
    caloriasError.value = 'Erro ao adicionar calorias: $e';
  }
}


  // Função para exibir o AlertDialog de sucesso
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sucesso'),
          content: Text(successMessage.value),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Fecha o AlertDialog e redireciona para a AgendaPage
                Get.back(); // Fecha o diálogo
                Get.offAllNamed('/agenda'); // Redireciona para a AgendaPage
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Método para obter calorias do banco de dados e atualizar o vetor
  Future<void> getCalorias(int usuarioId) async {
    try {
      final dbInstance = await DB.instance.database;

      // Filtra as calorias por usuário
      final List<Map<String, dynamic>> maps = await dbInstance.query(
        'calorias',
        where: 'usuario_id = ?',
        whereArgs: [usuarioId], 
      );

      // Zera o vetor e carrega novamente os dados
      caloriasList.value = List.generate(maps.length, (i) {
        return Calorias.fromMap(maps[i]);
      });
    } catch (e) {
      throw Exception('Erro ao obter calorias: $e');
    }
  }

  // Método para obter a localização do usuário
  Future<void> getLocation() async {
    String location = await locationService.getLocation();
    locationMessage.value = location;
  }

  // Função para formatar o DateTime para uma data legível
  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy'); // Define o formato que deseja
    return formatter.format(date);
  }

  @override
  void onInit() {
    super.onInit();
    // Obtemos a localização assim que o controlador é inicializado
    getLocation();
  }
}
