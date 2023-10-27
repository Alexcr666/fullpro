import 'package:firebase_database/firebase_database.dart';

class CartServices {
  String? key;
  String? image;
  String? name;
  String? price;
  String? discount;
  String? chargemod;
  String? rating;
  String? quanity;

  CartServices({
    required this.key,
    required this.image,
    required this.name,
    required this.price,
    required this.discount,
    required this.chargemod,
    required this.rating,
    required this.quanity,
  });

  CartServices.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    image = snapshot.child('serviceImage').value.toString();
    name = snapshot.child('serviceName').value.toString();
    price = snapshot.child('servicePrice').value.toString();
    discount = snapshot.child('serviceDiscount').value.toString();
    chargemod = snapshot.child('servicechargemod').value.toString();
    rating = snapshot.child('serviceRating').value.toString();
    quanity = snapshot.child('quantity').value.toString();
  }
}
