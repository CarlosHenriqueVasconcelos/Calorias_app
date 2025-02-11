import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class CadastroPage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(() => TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Nome de Usuário',
                      errorText: authController.emailError.value.isEmpty
                          ? null
                          : authController.emailError.value,
                    ),
                  )),
              SizedBox(height: 16),
              Obx(() => TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      errorText: authController.passwordError.value.isEmpty
                          ? null
                          : authController.passwordError.value,
                    ),
                  )),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await authController.register(
                    usernameController.text,
                    passwordController.text,
                  );

                  if (authController.emailError.value.isEmpty &&
                      authController.passwordError.value.isEmpty) {
                    Get.snackbar('Sucesso', 'Usuário cadastrado com sucesso!');
                    Get.offAllNamed('/'); // Redireciona para a página de login
                  }
                },
                child: Text('Cadastrar'),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Get.toNamed('/'); // Redireciona para a página de login
                },
                child: Text(
                  'Já tem uma conta? Faça login',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
