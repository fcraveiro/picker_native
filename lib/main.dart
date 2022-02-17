import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:picker_native/menu.dart';
import 'package:picker_native/rotas.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF48426D),
      ),
    );

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rotas Getx',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), //
        Locale('pt', 'BR'), //
      ],
      locale: const Locale('pt', 'BR'),
      initialRoute: '/',
      unknownRoute: GetPage(name: '/notfound', page: () => const Menu()),
      getPages: rotas(),
    );
  }
}
