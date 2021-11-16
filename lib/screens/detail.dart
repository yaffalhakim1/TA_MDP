import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class DetailPage extends StatefulWidget {
  final String title;
  final String item;
  DetailPage({
    Key key,
    this.title,
    this.item,
  }) : super(key: key);

  @override
  _DetailPageMapsState createState() => _DetailPageMapsState();
}

class _DetailPageMapsState extends State<DetailPage> {
  Future<AgentDetail> agentDetail;

  @override
  void initState() {
    super.initState();
    agentDetail = fetchAgentDetail(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1F1D2B),
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff1F1D2B),
        title: Text(
          'Details',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(color: Colors.white, letterSpacing: .5),
          ),
          overflow: TextOverflow.ellipsis,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
            child: FutureBuilder<AgentDetail>(
          future: agentDetail,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    //gambar gede
                    Container(
                      height: 350,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(snapshot.data.fullPortrait),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            child: Image.network(snapshot.data.fullPortrait),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data.displayName,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 14,
                                    letterSpacing: 0.2),
                                overflow: TextOverflow.fade,
                                maxLines: 2,
                              ),
                              // Row(
                              //   children: [
                              //     Text(
                              //       snapshot.data.episodes.toString() +
                              //           ' episodes',
                              //       style: GoogleFonts.poppins(
                              //           fontWeight: FontWeight.w400,
                              //           color: Colors.grey,
                              //           letterSpacing: 0.2),
                              //       maxLines: 1,
                              //     ),
                              //     SizedBox(
                              //       width: 5,
                              //     ),
                              //     Text(
                              //       '•',
                              //       style: TextStyle(
                              //           color: Colors.white, fontSize: 18),
                              //     ),
                              //     SizedBox(
                              //       width: 5,
                              //     ),
                              //     Text(
                              //       snapshot.data.broadcast,
                              //       style: GoogleFonts.poppins(
                              //           fontWeight: FontWeight.w400,
                              //           color: Colors.grey,
                              //           letterSpacing: 0.2),
                              //       maxLines: 1,
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Score',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                    letterSpacing: 0.2),
                              ),
                              Text(
                                snapshot.data.role.displayName,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    letterSpacing: 0.2),
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Description',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Colors.white,
                              letterSpacing: .5,
                              fontSize: 15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          snapshot.data.description,
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black87,
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Gagal menampilkan data detail'));
            }
            return const CircularProgressIndicator();
          },
        )),
      ),
    );
  }
}

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

// function untuk fetch api
Future<AgentDetail> fetchAgentDetail(uuid) async {
  String api = 'https://valorant-api.com/v1/agents/$uuid';
  final response = await http.get(
    Uri.parse(api),
  );

  if (response.statusCode == 200) {
    return AgentDetail.fromJson(json.decode(response.body)['data']);
  } else {
    throw Exception('Failed to load shows');
  }
}
