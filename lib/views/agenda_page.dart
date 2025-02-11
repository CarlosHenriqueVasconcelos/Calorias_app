import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';
import '../controllers/calorias_controller.dart';
import '../controllers/auth_controller.dart'; // Importar o AuthController

class AgendaPage extends StatefulWidget {
  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final CaloriasController caloriasController = Get.put(CaloriasController());
  final AuthController authController = Get.find<AuthController>(); // Instância do AuthController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Chama o método de logout do AuthController
              authController.logout();
              // Redireciona para a página de login
              Get.offAllNamed('/'); // Substitua '/' pela rota da página de login
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime(2020),
              lastDay: DateTime(2030),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });

                // Verificar se o usuário está logado antes de navegar
                if (authController.user.value != null) {
                  // Passa o usuário logado para a página de InformarCaloriasPage
                  Get.toNamed('/informar_calorias', arguments: {
                    'date': selectedDay,
                    'usuario': authController.user.value, // Passando o usuário logado
                  });
                } else {
                  // Se o usuário não estiver logado, exibe uma mensagem de erro ou redireciona para login
                  Get.snackbar('Erro', 'Por favor, faça login para adicionar calorias');
                }
              },
              calendarFormat: CalendarFormat.month,
              headerStyle: HeaderStyle(formatButtonVisible: false),
              calendarStyle: CalendarStyle(
                isTodayHighlighted: true,
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navega para a página de relatório
                Get.toNamed('/relatorio');
              },
              child: Text('Gerar Resumo Mês'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
