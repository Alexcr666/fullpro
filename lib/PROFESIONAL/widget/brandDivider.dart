// ignore_for_file: file_names

import 'package:flutter/material.dart';

class BrandDivider extends StatelessWidget {
  const BrandDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 2,
      color: Color(0xFFe2e2e2),
      thickness: 1.0,
    );
  }
}
