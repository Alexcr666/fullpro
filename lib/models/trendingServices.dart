import 'package:firebase_database/firebase_database.dart';

class TrendingServices {
  String? key;
  String? image;
  String? name;
  String? price;
  String? discount;
  String? chargemod;
  String? rating;

  TrendingServices({
    required this.key,
    required this.image,
    required this.name,
    required this.price,
    required this.discount,
    required this.chargemod,
    required this.rating,
  });

  TrendingServices.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    image = snapshot.child('image').value.toString();
    name = snapshot.child('name').value.toString();
    price = snapshot.child('price').value.toString();
    discount = snapshot.child('discount').value.toString();
    chargemod = snapshot.child('chargemod').value.toString();
    rating = snapshot.child('rating').value.toString();
  }
}
