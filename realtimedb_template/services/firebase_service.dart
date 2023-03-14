import 'package:firebase_dart/firebase_dart.dart';

import '../config/configurations.dart';

class FirebaseService {
  FirebaseService();

  bool _initialized = false;
  FirebaseApp? _firebaseApp;
  FirebaseAuth? _firebaseAuth;
  FirebaseDatabase? _realtimeDatabase;

  bool get isInitialized => _initialized;

  FirebaseApp get firebaseApp {
    assert(_firebaseApp == null, 'FirebaseApp is not initialized');
    return _firebaseApp!;
  }

  FirebaseAuth get firebaseAuth {
    assert(_firebaseAuth == null, 'FirebaseAuth is not initialized');
    return _firebaseAuth!;
  }

  FirebaseDatabase get realtimeDatabase {
    assert(_realtimeDatabase == null, 'Realtime Database is not initialized');
    return _realtimeDatabase!;
  }

  Future<void> init() async {
    if (!_initialized) {
      FirebaseDart.setup();
      _firebaseApp = await Firebase.initializeApp(
        options: FirebaseOptions.fromMap(Configurations.firebaseConfig),
      );
      _firebaseAuth = FirebaseAuth.instanceFor(app: firebaseApp);
      _realtimeDatabase = FirebaseDatabase(
        app: firebaseApp,
        databaseURL: Configurations.databaseUrl,
      );
      _initialized = true;
    }
  }
}
