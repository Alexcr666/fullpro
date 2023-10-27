import 'package:flutter/material.dart';
import 'package:fullpro/styles/statics.dart' as Static;

class DataLoadedProgress extends StatelessWidget {
  const DataLoadedProgress({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset('images/loading.gif', width: 60);
  }
}
