import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:fullpro/config.dart';
import 'package:fullpro/utils/globalConstants.dart';
import 'package:fullpro/controller/loader.dart';
import 'package:fullpro/controller/pushnotificationservice.dart';
import 'package:fullpro/models/cartservices.dart';
import 'package:fullpro/pages/profile/orderspage.dart';
import 'package:fullpro/provider/Appdata.dart';
import 'package:fullpro/utils/orderConstants.dart';
import 'package:fullpro/utils/randomOrderID/orderid.dart';
import 'package:fullpro/utils/userpreferences.dart';
import 'package:fullpro/widgets/DataLoadedProgress.dart';
import 'package:fullpro/widgets/SelectOnceDialog.dart';
import 'package:fullpro/widgets/cart/assignedDialog.dart';
import 'package:fullpro/widgets/timerSnackbar.dart';

class CartController {
  //

  static void getCartData(BuildContext context, bool qtybutton, String? key, String? name, String? rating, String? image, String? chargemod,
      String? price, String? discount) {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;
    String? userid = currentFirebaseUser?.uid;
    int? quantity;
    int? totalprice;

    if (!singleService.contains(name!.toLowerCase())) {
      qtybutton == true
          ? showDialog(
              barrierColor: Colors.white,
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => const Center(
                child: DataLoadedProgress(),
              ),
            )
          : showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => const Center(
                child: DataLoadedProgress(),
              ),
            );
    }

    DatabaseReference cartRef = FirebaseDatabase.instance.ref().child('users').child(userid!).child('cart');

    cartRef.once().then((e) async {
      final kSnapshot = e.snapshot;
      print(kSnapshot.value);

      if (discount == 0) {
        if (kSnapshot.exists) {
          if (kSnapshot.child('totalprice').value.toString() != null) {
            totalprice = int.tryParse(kSnapshot.child('totalprice').value.toString());

            cartRef.update({'totalprice': totalprice! + int.tryParse(price!)!});
            totalprice = totalprice! + int.tryParse(price)!;
          } else {
            cartRef.update({'totalprice': int.tryParse(price!)!});
            totalprice = totalprice! + int.tryParse(price)!;
          }
        } else {
          cartRef.update({'totalprice': int.tryParse(price!)!});
          totalprice = totalprice! + int.tryParse(price)!;
        }
      } else {
        if (kSnapshot.exists) {
          if (kSnapshot.child('totalprice').value.toString() != null) {
            totalprice = int.tryParse(kSnapshot.child('totalprice').value.toString());

            cartRef.update({'totalprice': totalprice! + int.tryParse(price!)! - int.tryParse(discount!)!});
            totalprice = totalprice! + int.tryParse(price)! - int.tryParse(discount)!;
          } else {
            cartRef.update({'totalprice': int.tryParse(price!)! - int.tryParse(discount!)!});
            totalprice = totalprice! + int.tryParse(price)! - int.tryParse(discount)!;
          }
        } else {
          cartRef.update({'totalprice': int.tryParse(price!)! - int.tryParse(discount!)!});
          totalprice = totalprice! + int.tryParse(price)! - int.tryParse(discount)!;
        }
      }

      //
    });

    DatabaseReference requestRef = FirebaseDatabase.instance.ref().child('users').child(userid).child('cart').child('list').child(key!);

    requestRef.once().then((e) async {
      final DataSnapshot = e.snapshot;

      if (DataSnapshot.exists) {
        if (DataSnapshot.child('quantity').value.toString() != null) {
          if (singleService.contains(name.toLowerCase())) {
            // Select Only Once Dialog
            showDialog(
              context: context,
              builder: (BuildContext context) => const SelectOnceDialog(),
            );
            return;
          }
          quantity = int.tryParse(DataSnapshot.child('quantity').value.toString());

          Map requestMap = {
            'userId': userid,
            'serviceId': key,
            'serviceImage': image,
            'servicechargemod': chargemod,
            'serviceRating': rating,
            'serviceName': name,
            'servicePrice': price,
            'serviceDiscount': discount,
            'quantity': quantity! + 1,
          };
          requestRef.set(requestMap);

          cartbottomsheetHeight = 60;
          cartStatus = 'full';
          UserPreferences.setcartStatus('full');
          cartIcon = cartfull;
          qtybutton == true
              ? Future.delayed(const Duration(milliseconds: 2200), () {
                  Navigator.pop(context);
                })
              : Navigator.pop(context);

          qtybutton == true
              ? timerSnackbar(
                  context: context,
                  buttonLabel: '',
                  contentText: Locales.string(context, 'quantity_increased'),
                  afterTimeExecute: () => null,
                  second: 4,
                )
              : timerSnackbar(
                  context: context,
                  buttonLabel: Locales.string(context, 'lbl_checkout'),
                  contentText: Locales.string(context, 'item_added_to_cart'),
                  buttonPrefixWidget: const Icon(
                    FeatherIcons.arrowRight,
                    color: Colors.white,
                  ),
                  afterTimeExecute: () => null,
                  second: 4,
                );
          if (qtybutton == true) {
            cartItemsList.clear();
            if (cartItemsList.isEmpty) {
              userCart(context);
              cartItemsList = Provider.of<AppData>(context, listen: false).userCartData;
            }
          }
        } else {
          Map requestMap = {
            'userId': userid,
            'serviceId': key,
            'serviceImage': image,
            'servicechargemod': chargemod,
            'serviceRating': rating,
            'serviceName': name,
            'servicePrice': price,
            'serviceDiscount': discount,
            'quantity': 1,
          };
          requestRef.set(requestMap);

          cartbottomsheetHeight = 60;
          cartStatus = 'full';
          UserPreferences.setcartStatus('full');
          cartIcon = cartfull;
          Navigator.pop(context);
          timerSnackbar(
            context: context,
            buttonLabel: Locales.string(context, 'lbl_checkout'),
            contentText: Locales.string(context, 'item_added_to_cart'),
            buttonPrefixWidget: const Icon(
              FeatherIcons.arrowRight,
              color: Colors.white,
            ),
            afterTimeExecute: () => null,
            second: 4,
          );
        }
      } else {
        Map requestMap = {
          'userId': userid,
          'serviceId': key,
          'serviceImage': image,
          'servicechargemod': chargemod,
          'serviceRating': rating,
          'serviceName': name,
          'servicePrice': price,
          'serviceDiscount': discount,
          'quantity': 1,
        };
        requestRef.set(requestMap);

        cartbottomsheetHeight = 60;
        cartStatus = 'full';
        UserPreferences.setcartStatus('full');
        cartIcon = cartfull;
        Navigator.pop(context);

        timerSnackbar(
          context: context,
          buttonLabel: Locales.string(context, 'lbl_checkout'),
          contentText: Locales.string(context, 'item_added_to_cart'),
          buttonPrefixWidget: const Icon(
            FeatherIcons.arrowRight,
            color: Colors.white,
          ),
          afterTimeExecute: () => null,
          second: 4,
        );
      }
    });
  }

  // Check Cat Status ( is Full or Empty )
  static void checkCart() {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;
    String? userid = currentFirebaseUser?.uid;

    DatabaseReference requestRef = FirebaseDatabase.instance.ref().child('users').child(userid!).child('cart').child('list');

    requestRef.once().then((e) async {
      final DataSnapshot = e.snapshot;

      if (DataSnapshot.exists) {
        cartStatus = 'full';
        cartbottomsheetHeight = 60;
        UserPreferences.setcartStatus('full');
        cartIcon = cartfull;
      } else {
        UserPreferences.setcartStatus('empty');
        cartbottomsheetHeight = 0;
        cartIcon = cartEmpty;
        cartStatus = 'empty';
      }
    });
  }

  // Get Total Price of Cart Items
  static void getToatlPrice() {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;
    String? userid = currentFirebaseUser?.uid;

    DatabaseReference requestRef = FirebaseDatabase.instance.ref().child('users').child(userid!).child('cart').child('totalprice');

    requestRef.once().then((e) async {
      final DataSnapshot = e.snapshot;

      if (DataSnapshot.exists) {
        ktotalprice = int.tryParse(DataSnapshot.value.toString());
      }
    });
  }

  static void userCart(context) async {
    //
    DatabaseReference cartRef = FirebaseDatabase.instance.ref().child('users').child(currentFirebaseUser!.uid).child('cart').child('list');

    cartRef.once().then((e) async {
      final snapshot = e.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic> values = snapshot.value as Map;
        snapshot.value;
        int tripCount = values.length;

        List<String> ServicesKeys = [];
        values.forEach((key, value) {
          ServicesKeys.add(key);
        });
        Provider.of<AppData>(context, listen: false).updateCartKeys(ServicesKeys);

        userCartData(context);
        cartDataLoaded = true;
        cartItemsList = Provider.of<AppData>(context, listen: false).userCartData;
      } else {
        cartDataLoaded = true;
        cartListLoaded = true;
      }
    });
  }

  static void userCartData(context) {
    var keys = Provider.of<AppData>(context, listen: false).cartKeys;

    for (String key in keys) {
      DatabaseReference historyRef =
          FirebaseDatabase.instance.ref().child('users').child(currentFirebaseUser!.uid).child('cart').child('list').child(key);

      historyRef.once().then((e) async {
        final snapshot = e.snapshot;
        if (snapshot.value != null) {
          var services = CartServices.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false).updateCartData(services);
        }
      });
    }
    cartListLoaded = true;
  }

  // Remove From Cart Function
  static void removeFromCart(context, String key, String price, String discount) {
    int? quantity;
    int? totalprice;

    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.white,
      context: context,
      builder: (BuildContext context) => const Center(
        child: DataLoadedProgress(),
      ),
    );

    DatabaseReference cartRef = FirebaseDatabase.instance.ref().child('users').child(currentFirebaseUser!.uid).child('cart');

    cartRef.once().then((e) async {
      final kSnapshot = e.snapshot;
      print(kSnapshot.value);

      if (discount == 0) {
        if (kSnapshot.exists) {
          if (kSnapshot.child('totalprice').value.toString() != null) {
            totalprice = int.tryParse(kSnapshot.child('totalprice').value.toString());

            cartRef.update({'totalprice': totalprice! - int.tryParse(price)!});
          } else {
            cartRef.update({'totalprice': int.tryParse(price)!});
          }
        } else {
          cartRef.update({'totalprice': int.tryParse(price)!});
        }
      } else {
        if (kSnapshot.exists) {
          if (kSnapshot.child('totalprice').value.toString() != null) {
            totalprice = int.tryParse(kSnapshot.child('totalprice').value.toString());

            cartRef.update({'totalprice': totalprice! - int.tryParse(price)! + int.tryParse(discount)!});
          } else {
            cartRef.update({'totalprice': int.tryParse(price)! + int.tryParse(discount)!});
          }
        } else {
          cartRef.update({'totalprice': int.tryParse(price)! + int.tryParse(discount)!});
        }
      }

      //
    });

    DatabaseReference requestRef =
        FirebaseDatabase.instance.ref().child('users').child(currentFirebaseUser!.uid).child('cart').child('list').child(key);

    DatabaseReference cartDataRef = FirebaseDatabase.instance.ref().child('users').child(currentFirebaseUser!.uid).child('cart');

    requestRef.once().then((e) async {
      final DataSnapshot = e.snapshot;
      if (DataSnapshot.exists) {
        if (DataSnapshot.value != null) {
          if (int.tryParse(DataSnapshot.child('quantity').value.toString())! > 1) {
            quantity = int.tryParse(DataSnapshot.child('quantity').value.toString());

            requestRef.update({'quantity': quantity! - 1});

            cartItemsList.clear();
            // cartDataLoaded = false;
            // cartListLoaded = false;
            if (cartItemsList.isEmpty) {
              userCart(context);
              cartItemsList = Provider.of<AppData>(context, listen: false).userCartData;
              Future.delayed(const Duration(milliseconds: 2200), () {
                Navigator.pop(context);
                timerSnackbar(
                  context: context,
                  buttonLabel: '',
                  contentText: Locales.string(context, 'quantity_decreased'),
                  afterTimeExecute: () => null,
                  second: 2,
                );
              });
            }
          } else {
            requestRef.remove();
            cartItemsList.clear();
            // cartDataLoaded = false;
            // cartListLoaded = false;
            if (cartItemsList.isEmpty) {
              userCart(context);
              cartItemsList = Provider.of<AppData>(context, listen: false).userCartData;
              Future.delayed(const Duration(milliseconds: 2200), () {
                Navigator.pop(context);
                timerSnackbar(
                  context: context,
                  buttonLabel: '',
                  contentText: Locales.string(context, 'lbl_item_removed'),
                  afterTimeExecute: () => null,
                  second: 2,
                );
              });
            }
          }
        } else {
          cartDataRef.remove();
          cartItemsList.clear();
          // cartDataLoaded = false;
          // cartListLoaded = false;
          if (cartItemsList.isEmpty) {
            userCart(context);
            cartItemsList = Provider.of<AppData>(context, listen: false).userCartData;
            Future.delayed(const Duration(milliseconds: 2200), () {
              Navigator.pop(context);
              timerSnackbar(
                context: context,
                buttonLabel: '',
                contentText: Locales.string(context, 'lbl_item_removed'),
                afterTimeExecute: () => null,
                second: 2,
              );
            });
          }
        }
      }
    });
  }

  // Remove All From Cart Function
  static void removeAllFromCart(context) {
    int? quantity;
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.white,
      context: context,
      builder: (BuildContext context) => const Center(
        child: DataLoadedProgress(),
      ),
    );

    DatabaseReference cartDataRef = FirebaseDatabase.instance.ref().child('users').child(currentFirebaseUser!.uid).child('cart');
    timerSnackbar(
      context: context,
      buttonLabel: '',
      contentText: Locales.string(context, 'lbl_all_items_removed'),
      afterTimeExecute: () => null,
      second: 4,
    );

    cartDataRef.remove();
    cartItemsList.clear();
    if (cartItemsList.isEmpty) {
      userCart(context);
      cartItemsList = Provider.of<AppData>(context, listen: false).userCartData;
      Future.delayed(const Duration(milliseconds: 2200), () {
        Navigator.pop(context);
      });
    }
  }

  // Create Service Request
  static void createRequest(context, String prob) {
    String? userLocation;
    String? userLocationStatus;
    String? requestID;
    List<dynamic> cartItems = [];
    String? requestKey;
    var orderId = Xid();

    PushNotificationService pushNotificationService = PushNotificationService();

    pushNotificationService.getToken();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => const Center(
        child: DataLoadedProgress(),
      ),
    );

    DatabaseReference cartData = FirebaseDatabase.instance.ref().child('users').child(currentUserInfo!.id!).child('cart').child('list');
    //
    // Ad ItemNames Data
    cartData.once().then((e) async {
      final snapshot = e.snapshot;
      Map<dynamic, dynamic> values = snapshot.value as Map;
      values.forEach((key, value) {
        itemNamesList.add(key);
      });
    });

    orderRef = FirebaseDatabase.instance.ref().child('requests').push();

    // Get New Request Key
    requestKey = orderRef?.key;

    // User Current Location Map
    Map currentAddMap = {
      'latitude': currentUserInfo?.currentAddressLatitude,
      'longitude': currentUserInfo?.currentAddressLongitude,
    };
    // User Current Location Map
    Map manualAddMap = {
      'latitude': currentUserInfo?.manualAddressLatitude,
      'longitude': currentUserInfo?.manualAddressLongitude,
    };

    DatabaseReference curAddressRef = FirebaseDatabase.instance.ref().child('users/${currentFirebaseUser?.uid}').child('AddressinUse');
    curAddressRef.once().then((e) async {
      final DataSnapshot = e.snapshot;

      if (DataSnapshot.value != null) {
        userLocationStatus = DataSnapshot.value.toString();
        if (userLocationStatus != null && itemNamesList.isNotEmpty) {
          Map rideMap = {
            'order_number': 'UST-${orderId.toString().substring(5)}',
            'itemsNames': itemNamesList,
            'created_at': DateTime.now().toString(),
            'description': prob,
            'booker_name': currentUserInfo?.fullName,
            'booker_id': currentUserInfo?.id,
            'booker_token': userToken,
            'booker_phone': currentUserInfo?.phone,
            'bookforDate': kSelectedDate,
            'bookforTime': kselectedTime,
            'address': userLocationStatus == 'current' ? currentUserInfo?.currentAddress : currentUserInfo?.manualAddress,
            'location': {
              'latitude':
                  userLocationStatus == 'current' ? currentUserInfo?.currentAddressLatitude : currentUserInfo?.manualAddressLatitude,
              'longitude':
                  userLocationStatus == 'current' ? currentUserInfo?.currentAddressLongitude : currentUserInfo?.manualAddressLongitude
            },
            'payment_method': 'cash',
            'partner_id': 'Waiting',
            'partner_name': 'Waiting',
            'partner_phone': 'Waiting',
            'status': 'Pending',
            'totalprice': ktotalprice,
          };
          orderRef?.set(rideMap).then((e) => itemNamesList.clear());

          cartData.once().then((e) async {
            final snapshot = e.snapshot;
            Map<dynamic, dynamic> values = snapshot.value as Map;
            values.forEach((key, value) {
              DatabaseReference requestRef =
                  FirebaseDatabase.instance.ref().child('requests').child(requestKey!).child('items').child(key!);
              requestRef.set(value);
            });
          });

          DatabaseReference userData = FirebaseDatabase.instance.ref().child('users/${currentFirebaseUser?.uid}').child('history');

          userData.once().then((e) async {
            final DataSnapshot = e.snapshot;
            if (DataSnapshot.exists) {
              userData.update({'$requestKey': true});
            } else {
              userData.set({'$requestKey': true});
            }
          });

          if (await Geolocator.isLocationServiceEnabled()) {
            Geofire.initialize('ordersAvailable');
            Geofire.setLocation(
                orderRef!.key!,
                userLocationStatus == 'current'
                    ? double.parse(currentUserInfo!.currentAddressLatitude!)
                    : double.parse(currentUserInfo!.manualAddressLatitude!),
                userLocationStatus == 'current'
                    ? double.parse(currentUserInfo!.currentAddressLongitude!)
                    : double.parse(currentUserInfo!.manualAddressLongitude!));
          }

          DatabaseReference cartRef = FirebaseDatabase.instance.ref().child('users').child(currentUserInfo!.id!).child('cart');
          // cartRef.remove();
          Navigator.pop(context);
          Navigator.pop(context);

          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => Center(
              child: Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                backgroundColor: Colors.transparent,
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset(
                          'images/confirm/chear.gif',
                          width: 300,
                        ),
                        Text(
                          Locales.string(context, 'lbl_order_placed'),
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          Locales.string(context, 'lbl_thank_for_order'),
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
                            Loader.page(
                                context,
                                MyOrdersProfile(
                                  tabIndicator: 1,
                                ));
                            //Loader.PagewithHome(context, const OrdersPage());
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Text(
                              Locales.string(context, 'lbl_track_order'),
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );

          orderSubscription = orderRef!.onValue.listen((
            event,
          ) async {
            //check for null snapshot
            if (event.snapshot.value == null) {
              return;
            }
            print('order value is ${event.snapshot.value}');

            // get driver name
            partnerFullName = event.snapshot.child('partner_name').value.toString();

            // get driver phone number
            if (event.snapshot.child('partner_phone').value != null) {
              partnerPhone = event.snapshot.child('partner_phone').value.toString();
            }
            if (event.snapshot.child('status').value != null) {
              status = event.snapshot.child('status').value.toString();
            }

            if (status == 'completed') {
              if (event.snapshot.child('totalprice').value != null) {
                int fee = int.parse(event.snapshot.child('totalprice').value.toString());

                var response = await showDialog(
                    context: context, barrierDismissible: false, builder: (BuildContext context) => AssignedDialog(orderID: status));

                if (response == 'close') {
                  orderRef?.onDisconnect();
                  orderRef = null;
                  orderSubscription?.cancel();
                  orderSubscription = null;
                }
              }
            }
          });
        } else {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => Center(
              child: Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                backgroundColor: Colors.transparent,
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(Icons.wifi_off_outlined, color: Colors.red),
                        Text(
                          Locales.string(context, 'error_no_internet'),
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          Locales.string(context, 'error_try_again'),
                          style: const TextStyle(fontSize: 14),
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
                            // Back
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Text(
                              Locales.string(context, 'lbl_close'),
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      }
    });

    // END
  }
}
