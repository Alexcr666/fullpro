// ignore_for_file: file_names

import 'package:flutter/material.dart';

class DataLoadedProgress extends StatelessWidget {
  const DataLoadedProgress({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset('images/circleLoading.gif', width: 60);
  }
}
