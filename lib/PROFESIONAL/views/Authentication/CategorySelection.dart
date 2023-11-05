// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter_locales/flutter_locales.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fullpro/PROFESIONAL/controllers/categoriesController.dart';
import 'package:fullpro/PROFESIONAL/controllers/mainController.dart';
import 'package:fullpro/PROFESIONAL/models/categoriesModel.dart';
import 'package:fullpro/PROFESIONAL/utils/globalConstants.dart';
import 'package:fullpro/PROFESIONAL/views/homepage.dart';
import 'package:fullpro/PROFESIONAL/widget/DataLoadedProgress.dart';

import 'package:fullpro/styles//statics.dart' as appcolors;

class CategorySelection extends StatefulWidget {
  static const String id = 'CategorySelection';
  final String? userID;

  const CategorySelection({Key? key, this.userID}) : super(key: key);

  @override
  _CategorySelectionState createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  String _groupValue = "null";
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // Repeating Function
    timer = Timer.periodic(
      repeatTime,
      (Timer t) => setState(() {
        if (parentCatDataLoaded == false && parentCatItemsList.isEmpty) {
          CategoriesController.getParentCategory(context);
        }
      }),
    );
  }

  void addCategory(String key) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => const Center(
        child: DataLoadedProgress(),
      ),
    );
    _groupValue = "ac_services";

    if (_groupValue != 'null') {
      DatabaseReference parentCatRef = FirebaseDatabase.instance.ref().child('services').child(key);

      parentCatRef.once().then((e) async {
        final snapshot = e.snapshot;

        if (snapshot.exists && snapshot.value != '' && snapshot.value != null) {
          Map<dynamic, dynamic> values = snapshot.value as Map;
          snapshot.value;

          List<String> servicesKeys = [];
          values.forEach((key, value) {
            servicesKeys.add(key);
          });

          // subCatItemsList
          DatabaseReference catAddRef = FirebaseDatabase.instance.ref().child("partners").child(widget.userID!);

          catAddRef.update({'category': servicesKeys}).then((value) {
            Navigator.pop(context);
            MainControllerProfesional.showErrorDialog(
                context, Locales.string(context, 'lbl_success'), Locales.string(context, 'lbl_category_added'));
            // Navigator.pushNamedAndRemoveUntil(context, HomePage.id, (route) => false);
            //change pro
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          });
        } else {
          Navigator.pop(context);
          MainControllerProfesional.showErrorDialog(
              context, Locales.string(context, 'lbl_error'), Locales.string(context, 'lbl_category_not_available'));
        }
      });
    } else {
      Navigator.pop(context);

      MainControllerProfesional.showErrorDialog(
          context, Locales.string(context, 'lbl_error'), Locales.string(context, 'lbl_select_category_first'));
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 90,
        iconTheme: const IconThemeData(
          color: Colors.black,
          size: 20,
        ),
        leadingWidth: 100,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          Locales.string(context, 'lbl_select_category'),
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            parentCatDataLoaded == true
                ? parentCatItemsList.isNotEmpty || parentCatListLoaded == true
                    ? parentCatItemsList.isNotEmpty
                        ? Container(
                            width: MediaQuery.of(context).size.width * 1,
                            height: parentCatItemsList.length * 66,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: parentCatItemsList.length,
                              itemBuilder: (context, index) {
                                return catRadio(
                                  catIndex: parentCatItemsList[index],
                                  catLength: parentCatItemsList.length,
                                );
                              },
                            ),
                          )
                        : Container(
                            color: appcolors.dashboardBG,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    DataLoadedProgress(),
                                  ],
                                ),
                              ),
                            ),
                          )
                    : Container(
                        color: appcolors.dashboardBG,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                DataLoadedProgress(),
                              ],
                            ),
                          ),
                        ),
                      )
                : Container(
                    color: appcolors.dashboardBG,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            DataLoadedProgress(),
                          ],
                        ),
                      ),
                    ),
                  ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _groupValue = "ac_services";
                      addCategory(_groupValue);
                      //CategoriesController.getParentCategory(context);
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(appcolors.themeColor[500]!),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(
                        Locales.string(context, 'lbl_submit'),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Image.asset(
                    'images/logo.png',
                    width: 110,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  catRadio({required CategoriesModel catIndex, catLength}) {
    return addressRadio(
      selected: false,
      background: Colors.grey.shade200,
      title: MainControllerProfesional.capitalize(catIndex.id.toString().replaceAll('_', ' ')),
      value: catIndex.id.toString(),
      onChanged: (status) {
        setState(() {
          _groupValue = catIndex.id.toString();
        });
      },
    );
  }

  Widget addressRadio(
      {required String title,
      required String value,
      required bool selected,
      required Color background,
      required Function(Object?) onChanged}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: background,
        ),
        child: Theme(
          data: Theme.of(context).copyWith(),
          child: RadioListTile(
            value: value,
            groupValue: _groupValue,
            onChanged: onChanged,
            selected: selected,
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
