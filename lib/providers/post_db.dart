import 'dart:io';
import 'package:appmensajeros/post.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Post_DB {
  static final Post_DB db = Post_DB._();
  Database _database;
  Post_DB._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstanace();
    return _database;
  }

  Future<Database> getDatabaseInstanace() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'Mensajero.db');
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Mensajero ('
          ' id TEXT NOT NULL PRIMARY KEY,'
          ' nombre TEXT NOT NULL,'
          ' foto TEXT NOT NULL,'
          ' placa TEXT NOT NULL,'
          ' telefono TEXT NOT NULL,'
          ' whatsapp TEXT NOT NULL,'
          ' moto TEXT NOT NULL'
          ')');
    });
  }
  //Consulta Total
  Future<List<Post>> getAllPost() async {
    final db = await database;
    var response = await db.query('Mensajero');
    List<Post> list = response.map((c) => Post.fromJson(c)).toList();
    return list;
  }

  Future<Post> getPost(String id) async {
    final db = await database;
    var results = await db.rawQuery("SELECT * FROM Mensajero WHERE id='$id'");
    if (results.isNotEmpty) {
      //print("[3]1" + Estudiante_DB.fromMap(results.first).id);
      return Post.fromJson(results.first);
    } else {
      return null;
    }
  }

  Future<List<Post>> getPost2(String id) async {
    final db = await database;
    var results = await db.rawQuery("SELECT * FROM Mensajero WHERE id='${id}'");

    List<Post> list;
    if (results.isNotEmpty) {
      list = results.map((c) => Post.fromJson(c)).toList();
      //print("[3] " +list[list.length - 1].id +" - " +list[list.length - 1].estado);
    } else {
      list = null;
      //print("[3]2 " + list.toString());
    }
    return list;
  }
  //Insert
  addPostToDatabase(Post post) async {
    final db = await database;
    //var result = await db.insert('Mensajero', post.toMap());
    var result = await db.rawInsert(
        "INSERT INTO Mensajero (id,nombre,foto,placa,telefono,whatsapp,moto)"
        " VALUES (${post.id}, '${post.nombre}', '${post.foto}', '${post.placa}', '${post.telefono}', '${post.whatsapp}', '${post.moto}')");
    print("[id]" + result.toString());
    return result;
  }
  //Update
  updatePost(Post post) async {
    final db = await database;
    //var result1 = await db.update('Mensajero', post.toMap());
    var result = await db.rawUpdate(
        "UPDATE Mensajero SET estado = '${post.nombre}', foto = '${post.foto}', placa = '${post.placa}', telefono = '${post.telefono}', whatsapp = '${post.whatsapp}', moto = '${post.moto}'"
        " WHERE id = '${post.id}'");
    return result;
  }
  //Delete
  deletePost(Post post) async {
    final db = await database;
    var result = await db.rawDelete("DELETE FROM Mensajero"
        " WHERE id = '${post.id}'");
    return result;
  }
  //Delete Todos Los Registros
  deleteAll() async {
    final db = await database;
    return await db.rawDelete('DELETE FROM Mensajero');
  }

}
