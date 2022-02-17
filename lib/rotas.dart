import 'package:get/get.dart';
import 'package:picker_native/menu.dart';
import 'package:picker_native/picker.dart';

rotas() {
  return [
    GetPage(name: '/', page: () => const Menu()),
    GetPage(
        name: '/menu/', page: () => const Menu(), transition: Transition.zoom),
    GetPage(
        name: '/picker/',
        page: () => const Picker(),
        transition: Transition.zoom),
  ];
}
