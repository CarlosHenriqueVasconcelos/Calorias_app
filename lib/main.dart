import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/login_page.dart';
import 'views/agenda_page.dart'; // Importação da página de agenda
import 'views/cadastro_page.dart'; // Importação da página de cadastro
import 'database/db.dart'; // Importação do banco de dados local
import 'views/informar_calorias_page.dart';
import 'views/relatorio_page.dart';
import 'controllers/auth_controller.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  
  // Inicialização do banco de dados local
  try {
    await DB.instance.database;
  } catch (e) {
    print('Erro ao inicializar o banco de dados: $e');
  }
  
  Get.put(AuthController());
  runApp(const MeuAplicativo()); // Iniciando widget
}

class MeuAplicativo extends StatelessWidget {
  const MeuAplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cálculo de Calorias',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: const AppBarTheme(
          color: Colors.green,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          headlineSmall: TextStyle(color: Colors.green),
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      locale: const Locale('pt', 'BR'), // Define o idioma padrão como português (Brasil)
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('pt', 'BR'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/', // Rota inicial
      getPages: [
        GetPage(name: '/', page: () => LoginPage()),
        GetPage(name: '/agenda', page: () => AgendaPage()),
        GetPage(name: '/cadastro', page: () => CadastroPage()),
        GetPage(name: '/informar_calorias', page: () => InformarCaloriasPage()),
        GetPage(name: '/relatorio', page: () => RelatorioPage()),
      ],
    );
  }
}
