class MapsDetail {
  final String uuid;
  final String displayName;
  final String coordinates;
  final String splash;
  final String displayIcon;

  MapsDetail({
    this.coordinates,
    this.displayName,
    this.splash,
    this.uuid,
    this.displayIcon,
  });

  factory MapsDetail.fromJson(Map<String, dynamic> json) {
    return MapsDetail(
      uuid: json['uuid'],
      displayName: json['displayName'],
      coordinates: json["coordinates"],
      splash: json['splash'],
      displayIcon: json['displayIcon'],
    );
  }
}
