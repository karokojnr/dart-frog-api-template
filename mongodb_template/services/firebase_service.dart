import 'package:firebase_dart/firebase_dart.dart';

import '../config/configurations.dart';

class FirebaseService {
  FirebaseService();

  bool _initialized = false;
  FirebaseApp? _firebaseApp;
  FirebaseAuth? _firebaseAuth;

  bool get isInitialized => _initialized;

  FirebaseApp get firebaseApp {
    assert(_firebaseApp == null, 'FirebaseApp is not initialized');
    return _firebaseApp!;
  }

  FirebaseAuth get firebaseAuth {
    assert(_firebaseAuth == null, 'FirebaseAuth is not initialized');
    return _firebaseAuth!;
  }

  Future<void> init() async {
    if (!_initialized) {
      FirebaseDart.setup();
      _firebaseApp = await Firebase.initializeApp(
        options: FirebaseOptions.fromMap(Configurations.firebaseConfig),
      );
      _firebaseAuth = FirebaseAuth.instanceFor(app: firebaseApp);
      _initialized = true;
    }
  }
}
