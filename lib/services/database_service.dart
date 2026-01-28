import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/medicine.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'medicine_reminder.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE medicines (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        dosage TEXT,
        schedule TEXT,
        frequency TEXT,
        createdAt INTEGER,
        isActive INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE medicine_intakes (
        id TEXT PRIMARY KEY,
        medicineId TEXT,
        time INTEGER,
        note TEXT,
        FOREIGN KEY (medicineId) REFERENCES medicines (id)
      )
    ''');
  }

  // 药品相关操作
  Future<int> insertMedicine(Medicine medicine) async {
    final db = await database;
    return await db.insert('medicines', medicine.toMap());
  }

  Future<List<Medicine>> getMedicines() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('medicines',
        where: 'isActive = ?', whereArgs: [1], orderBy: 'name');

    return List.generate(maps.length, (index) {
      return Medicine.fromMap(maps[index]);
    });
  }

  Future<void> updateMedicine(Medicine medicine) async {
    final db = await database;
    await db.update(
      'medicines',
      medicine.toMap(),
      where: 'id = ?',
      whereArgs: [medicine.id],
    );
  }

  Future<void> deleteMedicine(String id) async {
    final db = await database;
    await db.delete(
      'medicines',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 服药记录相关操作
  Future<int> insertIntake(MedicineIntake intake) async {
    final db = await database;
    return await db.insert('medicine_intakes', intake.toMap());
  }

  Future<List<MedicineIntake>> getIntakesByMedicine(String medicineId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medicine_intakes',
      where: 'medicineId = ?',
      whereArgs: [medicineId],
      orderBy: 'time DESC',
    );

    return List.generate(maps.length, (index) {
      return MedicineIntake.fromMap(maps[index]);
    });
  }

  Future<List<MedicineIntake>> getIntakesByDateRange(DateTime start, DateTime end) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medicine_intakes',
      where: 'time BETWEEN ? AND ?',
      whereArgs: [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch],
      orderBy: 'time DESC',
    );

    return List.generate(maps.length, (index) {
      return MedicineIntake.fromMap(maps[index]);
    });
  }
}