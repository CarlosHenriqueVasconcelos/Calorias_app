import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calorias_controller.dart';
import '../controllers/auth_controller.dart';  // Importar o AuthController

class InformarCaloriasPage extends StatelessWidget {
  final CaloriasController caloriasController = Get.put(CaloriasController());
  final TextEditingController caloriasControllerInput = TextEditingController();
  final AuthController authController = Get.find<AuthController>();  // Instância do AuthController

  @override
  Widget build(BuildContext context) {
    // Recebe a data como DateTime
    DateTime selectedDate = Get.arguments['date'];
    String formattedDate = caloriasController.formatDate(selectedDate); // Usa o método para formatar a data

    // Recupera o usuário logado diretamente do AuthController
    var usuarioLogado = authController.user.value;

    return Scaffold(
      appBar: AppBar(title: Text('Adicionar Calorias')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Exibe a data selecionada (já formatada)
            Text('Data Selecionada: $formattedDate'),
            SizedBox(height: 20),
            // Campo de texto para calorias
            TextField(
              controller: caloriasControllerInput,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Calorias consumidas',
                errorText: caloriasController.caloriasError.value.isEmpty
                    ? null
                    : caloriasController.caloriasError.value,
              ),
            ),
            SizedBox(height: 20),
            // Exibe a localização
            Obx(() => Text('Localização: ${caloriasController.locationMessage.value}')),
            SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Verifica se o usuário está logado
                  if (usuarioLogado != null && usuarioLogado.id != null) {
                    // Adicionar calorias usando DateTime
                    await caloriasController.addCalorias(
                      date: selectedDate, // Passando o DateTime diretamente
                      calorias: int.tryParse(caloriasControllerInput.text) ?? 0,
                      usuarioId: usuarioLogado.id!,  // Usando o 'id' não nulo do usuário
                      context: context,  // Passando o contexto para o método
                    );

                    // Verificar se há mensagem de sucesso ou erro e exibir o feedback
                    if (caloriasController.successMessage.isNotEmpty) {
                      Get.snackbar('Sucesso', caloriasController.successMessage.value);
                      Get.back(); // Volta para a tela anterior
                    } else if (caloriasController.caloriasError.isNotEmpty) {
                      Get.snackbar('Erro', caloriasController.caloriasError.value);
                    }
                  } else {
                    Get.snackbar('Erro', 'Usuário não encontrado ou ID não disponível!');
                  }
                },
  child: Text('Adicionar'),
)
          ],
        ),
      ),
    );
  }
}
