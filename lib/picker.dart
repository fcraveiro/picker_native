import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supabase/supabase.dart';
import 'package:picker_native/config.cfg';
import 'dart:io';

class Picker extends StatefulWidget {
  const Picker({Key? key}) : super(key: key);

  @override
  _PickerState createState() => _PickerState();
}

File pathFoto = '' as File;
bool temFoto = false;
bool foiSalva = false;
var idFoto = '';
var pathImage = '';
var pathServerNormal = '';
var pathServerThumb = '';

class _PickerState extends State<Picker> {
  SupabaseClient cliente = SupabaseClient(supabaseUrl, supabaseKey);

  @override
  void initState() {
    super.initState();
    log(pathServerNormal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capturar Imagem'),
        centerTitle: true,
        backgroundColor: const Color(0xFF48426D),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 10,
          height: MediaQuery.of(context).size.height - 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 280,
                height: 365,
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.only(top: 45),
                child: temFoto
                    ? Image.file(File(pathFoto.path))
                    : const Text('nova'),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  temFoto
                      ? SizedBox(
                          width: 130,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              gravacao();
                              setState(() {
                                temFoto = false;
                              });
                              _showToast(context);
                            },
                            child: const Text('Salvar'),
                          ),
                        )
                      : const SizedBox(
                          width: 130,
                          height: 40,
                        ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 130,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        foiSalva = false;
                        _showSelectImageDialog();
                      },
                      child: const Text('Escolher Imagem'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleImage({required ImageSource source}) async {
    Navigator.pop(context);
    XFile? image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      pathFoto = File(image.path);
      setState(() {
        temFoto = true;
      });
    }
  }

  gravaFoto(String nomeDaFoto, File pathFoto) async {
    await cliente.storage
        .from('pronto')
        .upload(nomeDaFoto, pathFoto)
        .then((value) {
      var response = cliente.storage.from('pronto').getPublicUrl(nomeDaFoto);
      pathImage = response.data.toString();
      // ignore: avoid_print
//      print('Path Servidor Normal : $pathServerNormal');
    });
  }

  geraThumb(File foto) async {
    File response = await FlutterNativeImage.compressImage(
      foto.path,
      quality: 65,
      percentage: 25,
    );
    pathFoto = File(response.path);
    return pathFoto;
  }

  gravacao() async {
    var dnow = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd-hh-mm-ss');
    var dataHoje = formatter.format(dnow);
    idFoto = dataHoje + '.jpg';
    await gravaFoto(idFoto, pathFoto);
    pathServerNormal = pathImage;
    await geraThumb(pathFoto);
    idFoto = dataHoje + '-thumb.jpg';
    await gravaFoto(idFoto, pathFoto);
    pathServerThumb = pathImage;
    foiSalva = true;
    log(pathServerThumb);
    log(pathServerNormal);
  }

  void _showSelectImageDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Add Photo'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text('Take Photo'),
              onPressed: () => _handleImage(source: ImageSource.camera),
            ),
            CupertinoActionSheetAction(
              child: const Text('Choose From Gallery'),
              onPressed: () => _handleImage(source: ImageSource.gallery),
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        );
      },
    );
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      const SnackBar(
        elevation: 10,
        duration: Duration(seconds: 2),
        content: Text(
          'Salvando a Imagem !!',
          style: TextStyle(
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
