class Address {
  String placeName;
  double latitude;
  double longitude;
  String placeId;
  String placeFormattedAddress;

  Address({
    this.placeId = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.placeName = '',
    this.placeFormattedAddress = '',
  });
}
