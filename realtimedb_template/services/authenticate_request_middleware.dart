import 'package:dart_frog/dart_frog.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

import '../config/configurations.dart';

Middleware authenticateRequest() {
  return provider<bool>((context) {
    final request = context.request;
    final headers = request.headers as Map<String, String>;
    final authData = headers['Authorization'];

    try {
      final receivedToken = authData!.trim();
      verifyJwtHS256Signature(
        receivedToken,
        Configurations.secretJwt,
      );
      return true;
    } catch (e) {
      return false;
    }
  });
}
