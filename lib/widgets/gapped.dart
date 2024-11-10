import 'package:flutter/material.dart';

List<Widget> gapped(List<Widget> widgets,
    {Widget spacer = const SizedBox(width: 10, height: 10)}) {
  List<Widget> returnArr = [];
  for (int i = 0; i < widgets.length; i++) {
    returnArr.add(widgets[i]);
    if (i < widgets.length - 1) returnArr.add(spacer);
  }
  return returnArr;
}
