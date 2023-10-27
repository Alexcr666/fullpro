import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {
  final String? id;
  final String? name;
  final bool? isBlocked;
  String? address;
  final Map? coordinates;
  final List? sexualOrientation;
  final String? gender;
  final String? showGender;
  final int? age;
  final String? phoneNumber;
  int? maxDistance;
  Timestamp? lastmsg;
  final Map? ageRange;
  final Map? editInfo;
  List? imageUrl = [];
  var distanceBW;
  User({
    this.id,
    this.age,
    this.address,
    this.isBlocked,
    this.coordinates,
    this.name,
    this.imageUrl,
    this.phoneNumber,
    this.lastmsg,
    this.gender,
    this.showGender,
    this.ageRange,
    this.maxDistance,
    this.editInfo,
    this.distanceBW,
    this.sexualOrientation,
  });

  @override
  String toString() {
    return 'User: {id: $id,name:$name, isBlocked: $isBlocked, address: $address, coordinates: $coordinates, sexualOrientation: $sexualOrientation, gender: $gender, showGender: $showGender, age: $age, phoneNumber: $phoneNumber, maxDistance: $maxDistance, lastmsg: $lastmsg, ageRange: $ageRange, editInfo: $editInfo, distanceBW : $distanceBW }';
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    // DateTime date = DateTime.parse(doc["user_DOB"]);
    return User(
        id: doc.data().toString().contains('userId') ? doc.get('userId') : '0',
        // id: doc.get('userId')! ?? "",
        isBlocked: doc.data().toString().contains('isBlocked') ? doc.get('isBlocked') : false,
        // isBlocked: doc.get('isBlocked')! ?? "false",
        // doc.get('isBlocked') : false,
        phoneNumber: doc.data().toString().contains('phoneNumber') ? doc.get('phoneNumber') : '',

        //   phoneNumber: doc.get('phoneNumber')! ?? "",
        name: doc.data().toString().contains('UserName') ? doc.get('UserName') : '',
        // name: doc.get('UserName') ?? "",\\\
        editInfo: doc.data().toString().contains('editInfo') ? doc.get('editInfo') : [], //List<dynamic>

        // editInfo: doc.get('editInfo'),
        ageRange: doc.data().toString().contains('age_range') ? doc.get('age_range') : [], //List<dynamic>

        //   ageRange: doc.get('age_range'),
        showGender: doc.data().toString().contains('showGender') ? doc.get('showGender') : [], //List<dynamic>

        //   showGender: doc.get('showGender') ?? "",
        maxDistance: doc.data().toString().contains('maximum_distance') ? doc.get('maximum_distance') : 0, //Number

        //  maxDistance: doc.get('maximum_distance'),
        sexualOrientation:
            doc.data().toString().contains('sexualOrientation') ? doc.get('sexualOrientation')['orientation'] : [], //List<dynamic>

        // sexualOrientation: doc.get('sexualOrientation')['orientation'] ?? "",
        //  age: doc.data().toString().contains('amount') ? doc.get('amount') : 0,//Number

        age: ((DateTime.now().difference(DateTime.parse(doc.get('user_DOB'))).inDays) / 365.2425).truncate(),
        address: doc.data().toString().contains('location') ? doc.get('location')['address'] : '',

        //  address: doc.get('location')['address'],
        coordinates: doc.data().toString().contains('location') ? doc.get('location') : [],
        //   coordinates: doc.get('location'),
        // university: doc['editInfo']['university'],
        imageUrl: doc.get('Pictures') != null
            ? List.generate(doc.get('Pictures').length, (index) {
                return doc.get('Pictures')[index];
              })
            : []);
  }
}
