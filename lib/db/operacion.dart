import 'package:crud_practica/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class operacion {
  static Future<Database> _openDB() async {
    return openDatabase(join(await getDatabasesPath(), 'notes.db'),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE notes (id INTEGER PRIMARY KEY, title TEXT, content TEXT)");
    }, version: 1);
  }

  static Future<int> insert(Note note) async {
    Database database = await _openDB();

    //return database.insert("notes", note.toMap());
    Map<String, dynamic> noteMap = note.toMap();

    // Eliminar el id de noteMap para que la base de datos lo genere automáticamente
    noteMap.remove('id');

    int id = await database.insert("notes", noteMap);

    return id;
  }

  static Future<int> delete(Note note) async {
    Database database = await _openDB();

    //return database.insert("notes", note.toMap());
    Map<String, dynamic> noteMap = note.toMap();

    // Eliminar el id de noteMap para que la base de datos lo genere automáticamente
    noteMap.remove('id');

    int id = await database.delete(
      "notes",
      where: 'id = ?',
      whereArgs: [note.id],
    );

    return id;
  }

  static Future<int> update(Note note) async {
    Database database = await _openDB();

    //return database.insert("notes", note.toMap());
    Map<String, dynamic> noteMap = note.toMap();

    // Eliminar el id de noteMap para que la base de datos lo genere automáticamente
    noteMap.remove('id');

    int id = await database.update(
      "notes",
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );

    return id;
  }

  static Future<List<Note>> notes() async {
    final Database database = await _openDB();

    final List<Map<String, dynamic>> notesMap = await database.query("notes");

    for (var n in notesMap) {
      print("_____" + n['title']);
    }

    return List.generate(
      notesMap.length,
      (i) => Note(
          id: notesMap[i]['id'] as int,
          title: notesMap[i]['title'] as String,
          content: notesMap[i]['content'] as String),
    );
  }
}
