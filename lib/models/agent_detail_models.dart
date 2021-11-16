class AgentDetail {
  String uuid;
  String displayName;
  String description;
  String fullPortrait;
  Role role;
  List<Ability> abilities;

  AgentDetail(
      {this.uuid,
      this.displayName,
      this.fullPortrait,
      this.role,
      this.abilities,
      this.description});

  factory AgentDetail.fromJson(Map<String, dynamic> json) {
    return AgentDetail(
      uuid: json['uuid'],
      displayName: json['displayName'],
      fullPortrait: json['fullPortrait'],
      description: json['description'],
      role: json['role'] != null ? Role.fromJson(json['role']) : null,
      abilities:
          List<Ability>.from(json["abilities"].map((x) => Ability.fromJson(x))),
    );
  }
}

class Role {
  Role({
    this.uuid,
    this.displayName,
    this.description,
    this.displayIcon,
    this.assetPath,
  });

  String uuid;
  String displayName;
  String description;
  String displayIcon;
  String assetPath;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        uuid: json["uuid"],
        displayName: json["displayName"],
        description: json["description"],
        displayIcon: json["displayIcon"],
        assetPath: json["assetPath"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "displayName": displayName,
        "description": description,
        "displayIcon": displayIcon,
        "assetPath": assetPath,
      };
}

class Ability {
  Ability({
    this.slot,
    this.displayName,
    this.description,
    this.displayIcon,
  });

  String slot;
  String displayName;
  String description;
  String displayIcon;

  factory Ability.fromJson(Map<String, dynamic> json) => Ability(
        slot: json["slot"],
        displayName: json["displayName"],
        description: json["description"],
        displayIcon: json["displayIcon"] == null ? null : json["displayIcon"],
      );

  Map<String, dynamic> toJson() => {
        "slot": slot,
        "displayName": displayName,
        "description": description,
        "displayIcon": displayIcon == null ? null : displayIcon,
      };
}

enum Slot { ABILITY1, ABILITY2, GRENADE, ULTIMATE, PASSIVE }
final slotValues = EnumValues({
  "Ability1": Slot.ABILITY1,
  "Ability2": Slot.ABILITY2,
  "Grenade": Slot.GRENADE,
  "Passive": Slot.PASSIVE,
  "Ultimate": Slot.ULTIMATE
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
