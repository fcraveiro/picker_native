import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

var estilo1 = ElevatedButton.styleFrom(
  elevation: 7,
  fixedSize: const Size(220, 35),
  primary: const Color(0xFF48426D),
  onSurface: Colors.black,
);

var estilo2 = ElevatedButton.styleFrom(
  elevation: 7,
  fixedSize: const Size(155, 35),
  primary: const Color.fromARGB(255, 49, 112, 12),
  onSurface: Colors.black,
);

class _MenuState extends State<Menu> {
  texto(texto) {
    return Text(
      texto,
      style: GoogleFonts.montserratAlternates(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Menu'),
        centerTitle: true,
        backgroundColor: const Color(0xFF48426D),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              style: estilo1,
              onPressed: () {
                Get.toNamed("/picker/");
              },
              child: texto('Picker'),
            ),
          ],
        ),
      ),
    );
  }
}
