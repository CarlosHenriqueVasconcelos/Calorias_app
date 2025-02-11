# flutter_application_1

Carlos Henrique Vasconcelos Oliveira - RA : 2201585
## Funcionalidades
- Aplicativo para fazer o cálculo médio de consumo de calorias durante o mês
- Estruturado no modelo MVC
- Fazendo a utilização de formulário para o preenchimento e validação dos dados inseridos pelo usuário
- Feedback para o úsuario caso algum dado esteja errado e confirmação de sucesso ao adicionar dados
- Utilização de um map para armazenar os dados de forma estática
- List view de forma crescente para a exibição dos dados, baseando nos valores dos dias
 ## Requisitos
- Flutter (versão 3.0 ou superior)
- Dart (versão 2.0 ou superior)
- SQLite para banco de dados local
- Emulador ou dispositivo físico (Android ou iOS)
## Execução
Clonar repositorio
 -git clone https://github.com/CarlosHenriqueVasconcelos/Calorias_app.git 
 
 Acessar diretorio onde foi clonado
 
- Rodar comando "fluttert pub get" para a instalação das dependencias
  
Configurar Banco de Dados

- O banco de dados é gerenciado localmente com SQLite. As tabelas serão criadas automaticamente quando você rodar o aplicativo pela primeira vez.
  
Configurar a Localização 
- A funcionalidade de localização utiliza a API do dispositivo para capturar a latitude e longitude do usuário. Certifique-se de que seu emulador ou dispositivo físico tenha as permissões adequadas de localização.
  
Rodar Projeto
- Flutter run na linha de comando
