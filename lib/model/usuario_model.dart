
import 'package:flutter/material.dart';

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

   //Model vindo do Firestore
  factory UsuarioModel.fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
      nome: map['nome'],
      email: map['email'],
      aceitouTermos: map['aceitouTermos'],
      foto: map['foto'],
      apiKey: map['apiKey'],
      secretKey: map['secretKey'],
    );
  }

  Map<String, dynamic> toMap() {
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
