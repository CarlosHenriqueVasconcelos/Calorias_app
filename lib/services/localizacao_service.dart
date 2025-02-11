import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  Future<String> getLocation() async {
    try {
      // Verificar permissão para acessar a localização
      PermissionStatus permission = await Permission.location.status;

      if (permission.isGranted) {
        // Se a permissão foi concedida, obter a localização
        Position position = await Geolocator.getCurrentPosition();
        return 'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
      } else if (permission.isDenied) {
        // Se a permissão foi negada, pedir para o usuário autorizar
        PermissionStatus requestPermission = await Permission.location.request();
        
        if (requestPermission.isGranted) {
          // Se a permissão for concedida após a solicitação
          Position position = await Geolocator.getCurrentPosition();
          return 'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
        } else {
          // Se a permissão foi negada permanentemente
          return 'Permissão de localização negada. Vá até as configurações para autorizar.';
        }
      } else {
        return 'Erro ao acessar permissão de localização.';
      }
    } catch (e) {
      return 'Erro ao acessar localização: $e';
    }
  }
}
