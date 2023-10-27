// ignore_for_file: file_names

import 'package:firebase_database/firebase_database.dart';

class OrdersModel {
  String? key;
  String? booker_id;
  String? itemsNames;
  String? address;
  String? bookforDate;
  String? bookforTime;
  String? created_at;
  String? status;
  String? totalprice;
  String? partner;
  String? partner_name;
  String? partnerPhone;
  String? orderNumber;

  // Item Info
  String? image;
  String? quantity;
  String? name;
  String? price;
  String? discount;
  String? chargemod;
  String? rating;

  OrdersModel({
    required this.key,
    required this.booker_id,
    required this.itemsNames,
    required this.address,
    required this.bookforDate,
    required this.bookforTime,
    required this.created_at,
    required this.status,
    required this.totalprice,
    required this.partner,
    required this.partner_name,
    required this.partnerPhone,
    required this.orderNumber,

    // Item Info
    required this.image,
    required this.quantity,
    required this.name,
    required this.price,
    required this.discount,
    required this.chargemod,
    required this.rating,
  });

  OrdersModel.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    booker_id = snapshot.child('booker_id').value.toString();
    itemsNames = snapshot
        .child('itemsNames')
        .value
        .toString()
        .replaceAll(']', '')
        .replaceAll('[', '')
        // AC Services
        .replaceAll('ac_installation', 'Air')
        .replaceAll('electrical_wiring', 'Air')
        .replaceAll('ac_dismounting', 'Air')
        .replaceAll('ac_master_services', 'Air')
        .replaceAll('ac_mounting_and_dismounting', 'Air')
        .replaceAll('ac_repairing', 'Air')
        .replaceAll('fan_dimmer_switch_installation', 'Air')
        .replaceAll('mixer_tap_installation', 'Air')
        .replaceAll('single_phase_breaker_replacement', 'Air')
        .replaceAll('sofa_cleaning', 'Air')
        .replaceAll('ups_installation_wo_wiring', 'Air')
        // Carpenter
        .replaceAll('catcher_replacement', 'Carpenter')
        .replaceAll('drawer_lock_installation', 'Carpenter')
        .replaceAll('drawer_repairing', 'Carpenter')
        .replaceAll('room_door_lock_installation', 'Carpenter')
        .replaceAll('carpenter_work', 'Carpenter')
        // Carpenter
        .replaceAll('5_seater_sofa_set_cleaning', 'Cleaning')
        .replaceAll('6_seater_sofa_set_cleaning', 'Cleaning')
        .replaceAll('7_seater_set_cleaning', 'Cleaning')
        .replaceAll('carpet_cleaning', 'Cleaning')
        .replaceAll('chair_cleaning', 'Cleaning')
        .replaceAll('double_mattress_cleaning', 'Cleaning')
        .replaceAll('single_mattress_cleaning', 'Cleaning')
        .replaceAll('single_sofa_cleaning', 'Cleaning')
        // Electrician
        .replaceAll('32_42_inch_led_tv_mounting', 'Electrician')
        .replaceAll('43_65_inch_led_tv_mounting', 'Electrician')
        .replaceAll('ceiling_fan_isntallation', 'Electrician')
        .replaceAll('smd_lights_installation', 'Electrician')
        .replaceAll('switchboard_button_replacement', 'Electrician')
        .replaceAll('change_over_switch_installation', 'Electrician')
        .replaceAll('pressure_motor_installation', 'Electrician')
        .replaceAll('single_phase_breaker_replacement', 'Electrician')
        .replaceAll('single_phase_distribution_box_installation', 'Electrician')
        .replaceAll('water_tank_automatic_switch_installation', 'Electrician')
        .replaceAll('manual_washing_machine_repairing', 'Electrician')
        .replaceAll('fan_dimmer_switch_installation', 'Electrician')
        .replaceAll('ups_repairing', 'Electrician')
        .replaceAll('ups_installation_wo_wiring', 'Electrician')
        .replaceAll('exhaust_fan_installation', 'Electrician')
        .replaceAll('new_house_wiring', 'Electrician')
        .replaceAll('electrical_wiring', 'Electrician')
        .replaceAll('house_electric_work', 'Electrician')
        .replaceAll('door_piller_lights', 'Electrician')
        .replaceAll('fancy_light_installation_wo_wiring', 'Electrician')
        .replaceAll('ups_wiring', 'Electrician')
        .replaceAll('led_tv_dismounting', 'Electrician')
        .replaceAll('kitchen_hood_rpairing', 'Electrician')
        .replaceAll('automatic_washing_machine_repairing', 'Electrician')
        .replaceAll('kitchen_hood_installation', 'Electrician')
        .replaceAll('fancy_light_installation_with_wiring', 'Electrician')
        .replaceAll('smd_lights_installation_with_wiring', 'Electrician')
        .replaceAll('switchboard_socket_replacement', 'Electrician')
        .replaceAll('power_plug_wo_wiring', 'Electrician')
        .replaceAll('power_plug_with_wiring', 'Electrician')
        .replaceAll('light_plug_wo_wiring', 'Electrician')
        .replaceAll('ceiling_fan_repairing', 'Electrician');

    // itemsNames = snapshot.child('itemsNames').value.toString();

    address = snapshot.child('address').value.toString();
    bookforDate = snapshot.child('bookforDate').value.toString();
    bookforTime = snapshot.child('bookforTime').value.toString();
    created_at = snapshot.child('created_at').value.toString();
    status = snapshot.child('status').value.toString();
    totalprice = snapshot.child('totalprice').value.toString();
    partner = snapshot.child('partner_id').value.toString();
    partner_name = snapshot.child('partner_name').value.toString();
    partnerPhone = snapshot.child('partner_phone').value.toString();
    orderNumber = snapshot.child('order_number').value.toString();

    // Item Info
    image = snapshot.child('serviceImage').value.toString();
    quantity = snapshot.child('quantity').value.toString();
    name = snapshot.child('serviceName').value.toString();
    price = snapshot.child('servicePrice').value.toString();
    discount = snapshot.child('serviceDiscount').value.toString();
    chargemod = snapshot.child('servicechargemod').value.toString();
    rating = snapshot.child('serviceRating').value.toString();
  }
}
