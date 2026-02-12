import 'package:cloud_firestore/cloud_firestore.dart';

class UsuarioModel {
  final String? nome;
  final String? email;
  final bool? aceitouTermos;
  final String? foto;
  final String apiKey;
  final String secretKey;

  UsuarioModel({
    this.nome,
    this.email,
    this.aceitouTermos,
    this.foto,
    required this.apiKey,
    required this.secretKey,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      nome: json['nome'],
      email: json['email'],
      aceitouTermos: json['aceitouTermos'],
      foto: json['foto'],
      apiKey: json['apiKey'] ?? '',
      secretKey: json['secretKey'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'aceitouTermos': aceitouTermos,
      'foto': foto,
      'apiKey': apiKey,
      'secretKey': secretKey,
    };
  }
}
