import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Para formatar datas
import '../controllers/calorias_controller.dart';
import '../models/calorias_model.dart';
import '../controllers/auth_controller.dart';

class RelatorioPage extends StatefulWidget {
  @override
  _RelatorioPageState createState() => _RelatorioPageState();
}

class _RelatorioPageState extends State<RelatorioPage> {
  final CaloriasController caloriasController = Get.put(CaloriasController());
  DateTime selectedMonth = DateTime.now(); // Mês selecionado
  List<Calorias> caloriasMes = [];
  double mediaCalorias = 0.0;

  @override
  void initState() {
    super.initState();
    _gerarRelatorioMes();
  }

  // Função para selecionar o mês
  Future<void> _selecionarMes(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: Locale("pt", "BR"), // Idioma em português
    );

    if (picked != null) {
      setState(() {
        selectedMonth = DateTime(picked.year, picked.month, 1); // Ajusta para o primeiro dia do mês
      });
      _gerarRelatorioMes();
    }
  }

  // Função para gerar o relatório mensal
  Future<void> _gerarRelatorioMes() async {
    try {
      caloriasMes.clear();
      final usuarioLogado = Get.find<AuthController>().user.value;

      if (usuarioLogado == null || usuarioLogado.id == null) {
        Get.snackbar('Erro', 'Usuário não encontrado!');
        return;
      }

      // Obtém a lista de calorias do banco de dados
      await caloriasController.getCalorias(usuarioLogado.id!);

      // Define o primeiro e o último dia do mês escolhido
      DateTime firstDayOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
      DateTime lastDayOfMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 0);

      // Filtra as calorias para incluir todos os dias do mês selecionado
      final caloriasNoMes = caloriasController.caloriasList.where((calorias) {
        return calorias.diaDoMes.isAtSameMomentAs(firstDayOfMonth) ||
               calorias.diaDoMes.isAtSameMomentAs(lastDayOfMonth) ||
               (calorias.diaDoMes.isAfter(firstDayOfMonth) && calorias.diaDoMes.isBefore(lastDayOfMonth));
      }).toList();

      // Calcula a média de calorias
      double totalCalorias = caloriasNoMes.fold(0.0, (sum, calorias) => sum + calorias.caloriasConsumidas);
      mediaCalorias = caloriasNoMes.isNotEmpty ? totalCalorias / caloriasNoMes.length : 0.0;

      // Atualiza a UI
      setState(() {
        caloriasMes = caloriasNoMes;
      });

      if (caloriasMes.isEmpty) {
        Get.snackbar('Resumo do Mês', 'Nenhuma caloria registrada neste mês.');
      }
    } catch (e) {
      Get.snackbar('Erro', 'Falha ao gerar o relatório: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Relatório de Calorias')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            // Botão para escolher o mês
            ElevatedButton(
              onPressed: () => _selecionarMes(context),
              child: Text('Selecionar Mês'),
            ),
            SizedBox(height: 10),
            Text(
              'Mês Selecionado: ${DateFormat.yMMMM('pt_BR').format(selectedMonth)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Lista de calorias do mês
            if (caloriasMes.isNotEmpty)
              Column(
                children: caloriasMes.map((calorias) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                    child: ListTile(
                      title: Text('Dia: ${DateFormat('dd/MM/yyyy').format(calorias.diaDoMes)}'),
                      subtitle: Text(
                        'Calorias: ${calorias.caloriasConsumidas} - '
                        'Lat: ${calorias.latitude} - Lon: ${calorias.longitude}',
                      ),
                    ),
                  );
                }).toList(),
              ),
            if (caloriasMes.isEmpty)
              Center(child: Text('Nenhuma caloria registrada para este mês.')),

            SizedBox(height: 20),

            // Média de calorias no mês
            Text(
              'Média de calorias no mês: ${mediaCalorias.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
