import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

locationPermision() async {
  PermissionStatus locationStatus = await Permission.location.request();

  // Map<Permission, PermissionStatus> statuses = await [
  //   Permission.location,
  //   Permission.storage,
  // ].request();

  if (await Permission.location.isDenied ||
      await Permission.location.serviceStatus.isDisabled) {
    await Permission.location.request();
    // openAppSettings();
  } else if (locationStatus == PermissionStatus.permanentlyDenied) {
    openAppSettings();
  }

  if (!await Geolocator.isLocationServiceEnabled()) {
    Geolocator.getCurrentPosition().catchError((e) {
      print(e);
    });
  }
}
