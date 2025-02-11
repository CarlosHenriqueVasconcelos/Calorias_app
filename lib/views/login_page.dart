import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() => TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Nome de Usuário',
                    errorText: authController.emailError.value.isEmpty ? null : authController.emailError.value,
                  ),
                )),
                Obx(() => TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    errorText: authController.passwordError.value.isEmpty ? null : authController.passwordError.value,
                  ),
                )),
            ElevatedButton(
              onPressed: () async {
                // Chamando a função de login
                await authController.login(usernameController.text, passwordController.text);

                // Verificando erros após tentativa de login
                if (authController.emailError.value.isEmpty && authController.passwordError.value.isEmpty && authController.user.value != null) {
                  Get.snackbar('Sucesso', 'Login realizado com sucesso!');
                  Get.offAllNamed('/agenda'); // Redireciona para a página de agenda
                } else {
                  Get.snackbar('Erro', 'Usuário ou senha incorretos!');
                }
              },
              child: Text('Entrar'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Get.toNamed('/cadastro'); // Redireciona para a página de cadastro
              },
              child: Text(
                'Não tem uma conta? Cadastre-se',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
