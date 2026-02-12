import 'package:cripto_din/pages/cadastro_usuario.dart/cadastro_usuario.dart';
import 'package:cripto_din/service/usuario_service.dart';
import 'package:cripto_din/theme/designer_cores.dart';
import 'package:cripto_din/theme/designer_espacamentos.dart';
import 'package:cripto_din/theme/designer_letras.dart';
import 'package:cripto_din/theme/designer_tamanhos.dart';
import 'package:cripto_din/widget/recuperar_senha.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> _loginComEmail() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: senhaController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Erro ao fazer login")),
        );
      }
    }
  }

  Future<void> loginComGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      //salvar usuário non Firebase
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await UsuarioService().saveUser(user);
      }
    } catch (e) {
      debugPrint("Erro no login Google: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao entrar com Google")),
        );
      }
    }
  }

  var emailController = TextEditingController();
  var senhaController = TextEditingController();
  bool isObscureText = true;

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: DesignerCores.corFundo,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DesignerEspacamentos.verticalGrande,
                Row(
                  children: [
                    const Spacer(),
                    FaIcon(
                      FontAwesomeIcons.bitcoin,
                      size: DesignerTamanhos.iconeGrande,
                      color: DesignerCores.ouro,
                    ),
                    Expanded(child: Container()),
                  ],
                ),
                DesignerEspacamentos.verticalMedio,
                const Text(
                  "Ja tem cadastro?",
                  style: DesignerLetras.subtituloEstilo,
                ),
                DesignerEspacamentos.verticalPequeno,
                const Text(
                  "Tenha acesso ao maior mercado de criptomoedas!",
                  style: DesignerLetras.fonteNormal,
                ),
                DesignerEspacamentos.verticalGrande,
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  height: 30,
                  alignment: Alignment.center,
                  child: TextField(
                    controller: emailController,
                    onChanged: (value) {
                      debugPrint(value);
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(top: 0),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: DesignerCores.ouro),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: DesignerCores.ouro),
                      ),
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.person, color: DesignerCores.ouro),
                    ),
                  ),
                ),
                DesignerEspacamentos.verticalPequeno,
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  height: 30,
                  alignment: Alignment.center,
                  child: TextField(
                    controller: senhaController,
                    obscureText: isObscureText,
                    onChanged: (value) {
                      debugPrint(value);
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(top: 0),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: DesignerCores.ouro),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: DesignerCores.ouro),
                      ),
                      hintText: "Senha",
                      hintStyle: const TextStyle(color: Colors.white),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: DesignerCores.ouro,
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            isObscureText = !isObscureText;
                          });
                        },
                        child: Icon(
                          isObscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: DesignerCores.ouro,
                        ),
                      ),
                    ),
                  ),
                ),
                DesignerEspacamentos.verticalMedio,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Divider(color: Colors.white),
                    Text("ou", style: TextStyle(color: Colors.white)),
                    Divider(color: Colors.white),
                  ],
                ),
                DesignerEspacamentos.verticalGrande,
                //entar com GOOGLE
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        await loginComGoogle();
                      },
                      style: ButtonStyle(
                        // ignore: deprecated_member_use
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all(Colors.black),
                      ),
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.google,
                            color: DesignerCores.ouro,
                          ),
                          DesignerEspacamentos.w8,
                          const Text(
                            "Entrar com Google",
                            style: TextStyle(
                              color: DesignerCores.ouro,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                DesignerEspacamentos.verticalMedio,
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        await _loginComEmail();
                      },
                      style: ButtonStyle(
                        // ignore: deprecated_member_use
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all(
                          DesignerCores.ouro,
                        ),
                      ),
                      child: const Text(
                        "ENTRAR",
                        style: DesignerLetras.botaoEstilo,
                      ),
                    ),
                  ),
                ),

                Expanded(child: Container()),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  height: 40,
                  alignment: Alignment.center,
                  child: const RecuperarSenhaButton(),
                ),
                DesignerEspacamentos.verticalMedio,
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  height: 40,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CadastroUsuario()),
                      );
                    },
                    child: Text(
                      "Criar conta",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                DesignerEspacamentos.verticalGrande,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
