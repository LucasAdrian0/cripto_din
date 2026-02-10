class UsuarioModel {
  String? nome;
  String? email;
  String? password;
  bool? aceitouTermos;
  String? apiKey;
  String? secretKey;

  UsuarioModel({this.nome, this.email, this.password, this.aceitouTermos});

  UsuarioModel.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    email = json['email'];
    password = json['password'];
    aceitouTermos = json['aceitouTermos'];
    apiKey = json['apiKey'];
    secretKey = json['secretKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['email'] = this.email;
    data['password'] = this.password;
    data['aceitouTermos'] = this.aceitouTermos;
    //cadastro para obter o acessoa as chaves da API da Binance
    data['apiKey'] = this.apiKey;
    data['secretKey'] = this.secretKey;
    return data;
  }
}
