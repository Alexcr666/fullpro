import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

getStateOrder(BuildContext context, int position) {
  /*List stateOrder = [
    Locales.string(context, "lang_pending"),
    Locales.string(context, "lang_pending"),
    Locales.string(context, "lang_process"),
    Locales.string(context, "lang_process"),
    Locales.string(context, "lang_finish"),
    Locales.string(context, "lang_cancelstate")
  ];*/

  List stateOrder = ["Pendiente", "Pendiente", "Aceptado", "En camino", "En proceso", "Terminado", "Cancelado"];
  return stateOrder[position];
}

List stateOrderColor = [
  Color.fromARGB(255, 199, 209, 0),
  Color.fromARGB(255, 199, 209, 0),
  Color(0xff05C3FF),
  Color(0xff00A811),
  Color(0xff00A811),
  Color(0xff05C3FF),
  Color(0xffF20000)
];

//STATE USER

List stateOrderUser = ["Aprobrado", "Suspendido", "Eliminado"];
List stateSupport = ["Pendiente", "Resuelto", "Suspendido", "Eliminado"];
List stateOrderProfessional = ["Pendiente", "Aprobrado", "Suspendido", "Eliminado"];
