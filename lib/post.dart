import 'dart:convert';

Post tasksFromJson(String str) {
  final jsonData = json.decode(str);
  return Post.fromJson(jsonData);
}

String tasksToJson(Post data) {
  final dyn = data.toMap();
  return jsonEncode(dyn);
}

class Post {
  final String id;
  final String nombre;
  final String foto;
  final String placa;
  final String telefono;
  final String whatsapp;
  final String moto;

  Post(
      {this.id,
      this.nombre,
      this.foto,
      this.placa,
      this.telefono,
      this.whatsapp,
      this.moto});

  factory Post.fromJson(Map<String, dynamic> json) => new Post(
        id: json['id'],
        nombre: json['nombre'],
        foto: json['foto'],
        placa: json['placa'],
        telefono: json['telefono'],
        whatsapp: json['whatsapp'],
        moto: json['moto'],
      );
  Map<String, dynamic> toMap() => {
        "id": id,
        "nombre": nombre,
        "foto": foto,
        "placa": placa,
        "telefono": telefono,
        "whatsapp": whatsapp,
        "moto": moto,
      };
}
