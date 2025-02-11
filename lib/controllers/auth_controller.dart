import 'package:get/get.dart';
import '../services/auth_service.dart';  
import '../models/usuario.dart';

class AuthController extends GetxController {
  var emailError = ''.obs;
  var passwordError = ''.obs;
  var user = Rx<Usuario?>(null); 

  final AuthService _authService = AuthService();  // Instância do AuthService

  // Função para validar o login
  Future<void> login(String username, String password) async {
    emailError.value = '';
    passwordError.value = '';

    // Validação básica dos campos
    if (username.isEmpty) {
      emailError.value = 'O nome de usuário não pode estar vazio.';
    }
    if (password.isEmpty) {
      passwordError.value = 'A senha não pode estar vazia.';
    } else if (password.length < 6) {
      passwordError.value = 'A senha deve ter pelo menos 6 caracteres.';
    }

    // Se não houver erros nos campos, verificar no banco de dados
    if (emailError.value.isEmpty && passwordError.value.isEmpty) {
      final userExists = await _authService.isUsernameTaken(username);

      if (userExists) {
        final authResult = await _authService.authenticate(username, password);

        if (authResult != null) {
          user.value = authResult; // Usuário autenticado com sucesso
          // Salvar o usuário logado no estado
          update(); // Atualiza o estado do GetX
        } else {
          passwordError.value = 'Senha incorreta.'; 
        }
      } else {
        emailError.value = 'Usuário não encontrado.'; 
      }
    }
  }

  // Função para registrar um novo usuário
  Future<void> register(String username, String password) async {
    emailError.value = '';
    passwordError.value = '';

    // Validação básica dos campos
    if (username.isEmpty) {
      emailError.value = 'O nome de usuário não pode estar vazio.';
    }
    if (password.isEmpty) {
      passwordError.value = 'A senha não pode estar vazia.';
    } else if (password.length < 6) {
      passwordError.value = 'A senha deve ter pelo menos 6 caracteres.';
    }

    // Se não houver erros nos campos, proceder com o cadastro
    if (emailError.value.isEmpty && passwordError.value.isEmpty) {
      try {
        final newUser = Usuario(username: username, password: password);
        await _authService.registerUser(newUser);  // Chama o serviço para registrar o usuário

        emailError.value = '';
        passwordError.value = '';
        Get.snackbar('Sucesso', 'Usuário cadastrado com sucesso!');  // Feedback de sucesso

        
        

      } catch (e) {
        // Tratamento de erro ao tentar registrar o usuário
        emailError.value = e.toString().contains('Nome de usuário já existe')
            ? 'Nome de usuário já existe.'
            : 'Erro ao cadastrar usuário.';
      }
    }
  }

  // Função para verificar se o usuário está logado
  bool get isLoggedIn => user.value != null;

  // Função para deslogar o usuário
  Future<void> logout() async {
    user.value = null;
    update(); // Atualiza o estado após o logout
  }
}
