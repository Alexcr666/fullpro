// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:fullpro/PROFESIONAL/config.dart';
import 'package:fullpro/PROFESIONAL/controllers/loader.dart';
import 'package:fullpro/PROFESIONAL/views/homepage.dart';

import '../../styles/statics.dart' as appcolors;

class HowToPay extends StatefulWidget {
  const HowToPay({Key? key}) : super(key: key);
  static const String id = 'HowToPay';

  @override
  State<HowToPay> createState() => _HowToPayState();
}

class _HowToPayState extends State<HowToPay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appcolors.dashboardBG,
      appBar: AppBar(
        backgroundColor: appcolors.dashboardBG,
        elevation: 0.0,
        toolbarHeight: 80,
        leadingWidth: 80,
        leading: IconButton(
          splashColor: Colors.transparent,
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How To Pay',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto-Bold',
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '$appName Fee Payment is very simple Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed diam erat, aliquet id dui egestas, maximus scelerisque purus. Nam in lectus ultricies, eleifend est a.',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Roboto-Regular',
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 30),

                  //    EASYPESA START
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Bank Transfer:',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Roboto-Bold',
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 15),
                      Text(
                        '- Nullam lacinia metus at tellus venenatis,',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Roboto-Regular',
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        '- Non cursus quam tempus. Mauris odio arcu',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Roboto-Regular',
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 10),
                      Text(
                        '- Pellentesque consequat eget ex sed ullamcorper',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Roboto-Regular',
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        '  eros eget auctor euismod, lorem magna sodales',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Roboto-Regular',
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 10),
                      Text(
                        '- Vestibulum mollis ligula vel dui fringilla, quis blandit.',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Roboto-Bold',
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        '- Cras purus ex, elementum nec mauris id',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Roboto-Bold',
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                  const SizedBox(height: 40),
                  MaterialButton(
                    onPressed: () {
                      Loader.page(context, const HomePage());
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    elevation: 0,
                    highlightElevation: 0,
                    color: Colors.black87,
                    textColor: Colors.white,
                    child: const Text(
                      'Go Home ━━━',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
