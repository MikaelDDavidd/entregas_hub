import 'dart:io';

class ApiConfig {
  static const bool usePhysicalDevice = true;
  static const String macIpAddress = '192.168.100.223';

  static String get baseUrl {
    if (usePhysicalDevice) {
      return 'http://$macIpAddress:3000/api';
    }

    if (Platform.isIOS) {
      return 'http://localhost:3000/api';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000/api';
    } else {
      return 'http://localhost:3000/api';
    }
  }

  static String get uploadsUrl {
    if (usePhysicalDevice) {
      return 'http://$macIpAddress:3000';
    }

    if (Platform.isIOS) {
      return 'http://localhost:3000';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    } else {
      return 'http://localhost:3000';
    }
  }

  static const bool useLocalServer = true;
}
