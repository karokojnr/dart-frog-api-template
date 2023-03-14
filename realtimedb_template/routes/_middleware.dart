import 'package:dart_frog/dart_frog.dart';

import '../services/firebase_service.dart';
import '../services/authenticate_request_middleware.dart';

final firebaseService = FirebaseService();

Handler middleware(Handler handler) {
  return handler.use(
    provider<Future<FirebaseService>>((_) async {
      await firebaseService.init();
      return firebaseService;
    }),
  ).use(
    (handler) => handler.use(authenticateRequest()),
  );
}
