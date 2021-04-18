import 'package:appmensajeros/post.dart';
import 'package:appmensajeros/providers/post_db.dart';
import 'package:flutter/cupertino.dart';

Future<List<Post>> Consultar_Post_Total() async {
  List<Post> listaPost = await Post_DB.db.getAllPost();

  if (listaPost == null) {
    return null;
  } else {
    return listaPost;
  }
}

Future<List<Post>> Consultar_Post(String id) async {
  List<Post> listaPost = await Post_DB.db.getPost2(id);

  if (listaPost == null) {
    return null;
  } else {
    return listaPost;
  }
}

void Guardar_Post(Post post) {
  FutureBuilder(
    future: Post_DB.db.addPostToDatabase(post),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      print("[id]" + snapshot.data);
      return snapshot.data;
      
    },
  );
}

void Actualizar_Post(Post post) {
  FutureBuilder(
    future: Post_DB.db.updatePost(post),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return snapshot.data;
    },
  );
}

void Eliminar_Post(Post post) {
  FutureBuilder(
    future: Post_DB.db.deletePost(post),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return snapshot.data;
    },
  );
}

void Eliminar_Todo() {
  FutureBuilder(
    future: Post_DB.db.deleteAll(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return snapshot.data;
    },
  );
}

