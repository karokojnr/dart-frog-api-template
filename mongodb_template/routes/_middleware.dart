import 'package:dart_frog/dart_frog.dart';
import '../services/authenticate_request_middleware.dart';
import '../services/firebase_service.dart';
import '../services/mongo_db_service.dart';

final firebaseService = FirebaseService();
final mongoDbService = MongoDBService();

Handler middleware(Handler handler) {
  return handler.use(
    provider<Future<FirebaseService>>((_) async {
      await firebaseService.init();
      return firebaseService;
    }),
  ).use(
    provider<Future<MongoDBService>>((_) async {
      await mongoDbService.init();
      return mongoDbService;
    }),
  ).use(
    (handler) => handler.use(
      authenticateRequest(),
    ),
  );
}
