import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cripto_din/presentation/app/app_startup.dart';
import 'package:cripto_din/presentation/controllers/homepage_controller.dart';
import 'package:cripto_din/presentation/theme/design_tema_controller.dart';
import 'package:cripto_din/presentation/theme/design_temas.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cripto_din/presentation/pages/login_page/login_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  await dotenv.load(
    fileName: "local.env",
  ); //não esta no github o local_teste.env
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => HomepageController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, themeController, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: DesignTemas.claro,
          darkTheme: DesignTemas.escuro,
          themeMode: context.read<ThemeController>().themeMode,
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasData) {
                //return TabNavigationWidget(tabs: AppTabsConfig.tabs);
                return const AppStartup();
              }

              return const LoginPage();
            },
          ),
        );
      },
    );
  }
}
