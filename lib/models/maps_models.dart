class MapsModel {
  final String uuid;
  final String displayName;
  final String coordinates;
  final String splash;

  MapsModel({
    this.coordinates,
    this.displayName,
    this.splash,
    this.uuid,
  });

  factory MapsModel.fromJson(Map<String, dynamic> json) {
    return MapsModel(
      uuid: json['uuid'],
      displayName: json['displayName'],
      coordinates: json["coordinates"],
      splash: json['splash'],
    );
  }
}
