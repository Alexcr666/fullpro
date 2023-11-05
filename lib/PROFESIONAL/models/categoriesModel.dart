// ignore_for_file: file_names
import 'package:firebase_database/firebase_database.dart';

class CategoriesModel {
  String? id;
  String? name;

  CategoriesModel({
    this.id = '',
    this.name = '',
  });

  CategoriesModel.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    name = snapshot.child('name').value.toString();
  }
}
