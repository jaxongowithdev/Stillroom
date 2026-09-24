import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/practice_models.dart';
import '../models/user_preferences.dart';

class StorageManager {
  static final StorageManager instance = StorageManager._init();
  static Database? _database;

  StorageManager._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('gesso_attic.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE settings(
        id INTEGER PRIMARY KEY CHECK (id = 1),
        theme TEXT NOT NULL DEFAULT 'light',
        wash TEXT NOT NULL DEFAULT 'ease',
        minutes INTEGER NOT NULL DEFAULT 17,
        tooth TEXT NOT NULL DEFAULT 'even',
        showOnboarding INTEGER NOT NULL DEFAULT 1
      )
    ''');
    await db.execute('''
      CREATE TABLE logs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sessionId TEXT NOT NULL,
        title TEXT NOT NULL,
        minutes INTEGER NOT NULL,
        completedAt TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE journal(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mood TEXT NOT NULL,
        prompt TEXT NOT NULL,
        body TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
    await db.insert('settings', UserPreferences().toMap()..['id'] = 1);
  }

  Future<UserPreferences> getPreferences() async {
    final db = await database;
    final maps = await db.query('settings', where: 'id = 1');
    if (maps.isEmpty) return UserPreferences();
    return UserPreferences.fromMap(maps.first);
  }

  Future<void> savePreferences(UserPreferences prefs) async {
    final db = await database;
    await db.update('settings', prefs.toMap(), where: 'id = 1');
  }

  Future<int> insertLog(PracticeLog log) async {
    final db = await database;
    return db.insert('logs', log.toMap());
  }

  Future<List<PracticeLog>> recentLogs({int limit = 20}) async {
    final db = await database;
    final maps = await db.query('logs', orderBy: 'completedAt DESC', limit: limit);
    return maps.map(PracticeLog.fromMap).toList();
  }

  Future<int> minutesThisWeek() async {
    final logs = await recentLogs(limit: 80);
    final start = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
    final floor = DateTime(start.year, start.month, start.day);
    var sum = 0;
    for (final log in logs) {
      final at = DateTime.tryParse(log.completedAt);
      if (at != null && !at.isBefore(floor)) sum += log.minutes;
    }
    return sum;
  }

  Future<int> streak() async {
    final logs = await recentLogs(limit: 80);
    if (logs.isEmpty) return 0;
    final days = <String>{};
    for (final log in logs) {
      final at = DateTime.tryParse(log.completedAt);
      if (at != null) days.add('${at.year}-${at.month}-${at.day}');
    }
    var n = 0;
    var cursor = DateTime.now();
    while (true) {
      final key = '${cursor.year}-${cursor.month}-${cursor.day}';
      if (!days.contains(key)) {
        if (n == 0) {
          cursor = cursor.subtract(const Duration(days: 1));
          if (!days.contains('${cursor.year}-${cursor.month}-${cursor.day}')) return 0;
          continue;
        }
        return n;
      }
      n += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }
  }

  Future<int> insertJournal(JournalEntry entry) async {
    final db = await database;
    return db.insert('journal', entry.toMap());
  }

  Future<List<JournalEntry>> allJournal() async {
    final db = await database;
    final maps = await db.query('journal', orderBy: 'createdAt DESC');
    return maps.map(JournalEntry.fromMap).toList();
  }

  Future<void> deleteJournal(int id) async {
    final db = await database;
    await db.delete('journal', where: 'id = ?', whereArgs: [id]);
  }
}
