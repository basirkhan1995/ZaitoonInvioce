import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:zaitoon_invoice/DatabaseHelper/components.dart';
import 'package:zaitoon_invoice/DatabaseHelper/tables.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _db;

  // Private constructor
  DatabaseHelper._privateConstructor();

  // Open the database (or create it if it doesn't exist)
  static Future<void> initDatabase(String dbName) async {
    final path = await getApplicationDocumentsDirectory();
    final dbPath = join(path.path, dbName);

    if (_db != null) {
      close();
    }
    _db = sqlite3.open(dbPath);
    initTables();
    await DatabaseComponents.saveDatabasePath(dbPath);
  }

  // Only open Database method
  static Future<void> openDB(String completePath) async {
    // Close any previously opened database connection
    if (_db != null) {
      close();
    }
    _db = sqlite3.open(completePath);
  }

  static Future<void> initTables() async {
    if (_db != null) {
      _db!.execute(Tables.metaDataTable);
      _db!.execute(Tables.rolesPermissionsTable);
      _db!.execute(Tables.userRoleTable);
      _db!.execute(Tables.userTable);
    }
  }

  static Database get db => _db!;

  //static void close() => _db!.dispose();

  // Close the database connection
  static void close() {
    if (_db != null) {
      _db!.dispose();
      _db = null;
    }
  }
}
