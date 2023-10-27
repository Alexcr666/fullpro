import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RequestController {
  static Future<dynamic> getRequest(url, context) async {
    http.Response response = await http.get(url).catchError((e) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => Center(
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.all(16.0),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(4)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'No Internet Connection!',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      'No Stable Internet Connection Found',
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Center(
                        child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.black,
                        ),
                        foregroundColor: MaterialStateProperty.all(
                          Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Text('Try Again'),
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });

    try {
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);

        return decodedData;
      } else {
        return 'Failed';
      }
    } catch (e) {
      return 'Failed';
    }
  }
}
