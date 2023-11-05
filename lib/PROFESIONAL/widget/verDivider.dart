// ignore_for_file: file_names

import 'package:flutter/material.dart';

class VerDivider extends StatelessWidget {
  const VerDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const  VerticalDivider(
      width: 2,
      color: Color(0xFFe2e2e2),
      thickness: 1.0,
    );
  }
}
