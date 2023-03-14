
import 'package:mongo_dart/mongo_dart.dart';
import '../config/configurations.dart';
 
class MongoDBService {
 MongoDBService();
 
 bool _initialized = false;
 Db? _database;
 
 bool get isInitialized => _initialized;
 
 Db get database {
   assert(_database == null, 'MongoDb is not initialized');
   return _database!;
 }
 
 Future<void> init() async {
   if (!_initialized) {
     _database = await Db.create(Configurations.mongoDbUrl);
     _initialized = true;
   }
 }
 
 Future<void> openDb() async {
   await _database!.open();
 }
 
 Future<void> closeDb() async {
   await _database!.close();
 }
}
