import 'dart:convert';
import 'package:appmensajeros/perfilmensajero.dart';
import 'package:appmensajeros/post.dart';
import 'package:appmensajeros/service/future_post.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

Future<List<Post>> listarPost(http.Client client) async {
  final response = await http.get(Uri.parse(
      'https://desarolloweb2021a.000webhostapp.com/API/listarmensajeros.php'));

  return compute(pasaraListas, response.body);
}

List<Post> pasaraListas(String responseBody) {
  final pasar = json.decode(responseBody).cast<Map<String, dynamic>>();

  return pasar.map<Post>((json) => Post.fromJson(json)).toList();
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.green),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado Mensajeros Juan Herrera Joiro'),
      ),
      body: getInfo(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            getInfo(context);
          });
        },
        tooltip: 'Refrescar',
        child: Icon(Icons.refresh),
      ),
    );
  }
}

Widget getInfo(BuildContext context) {
  return FutureBuilder(
    future: listarPost(http.Client()),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return Center(child: CircularProgressIndicator());
        case ConnectionState.done:
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          return snapshot.data != null
              ? Vistamensajeros(posts: snapshot.data)
              : Text('Sin Datos');
        default:
          return Text('Presiona el boton para recargar');
      }
    },
  );
}

class Vistamensajeros extends StatelessWidget {
  final List<Post> posts;

  const Vistamensajeros({Key key, this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts == null ? 0 : posts.length,
      itemBuilder: (context, posicion) {
        consulta(posts[posicion].id, posts[posicion]);
        return FutureBuilder(
          future: Consultar_Post_Total(),
          builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
            if (snapshot.hasData) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Perfilmensajero(
                              perfil: snapshot.data, idperfil: posicion)));
                },
                leading: Container(
                  padding: EdgeInsets.all(5.0),
                  width: 50,
                  height: 50,
                  child: Image.network(snapshot.data[posicion].foto),
                ),
                title: Text(snapshot.data[posicion].nombre),
                subtitle: Text(snapshot.data[posicion].moto),
                trailing: Container(
                  width: 80,
                  height: 40,
                  color: Colors.yellowAccent,
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Text(snapshot.data[posicion].placa),
                ),
              );
            }
            return CircularProgressIndicator();
          },
        );
      },
    );
  }
}

List<Post> listPost = new List<Post>();

consulta(String id, Post post) async {
  listPost.clear();
  listPost = await Consultar_Post(id);

  if (listPost == null) {
    Guardar_Post(post);
  }
}
