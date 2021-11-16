import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_akhir_mdp/screens/detail.dart';
import 'package:tugas_akhir_mdp/screens/detail_maps.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<MapsModel>> maps;
  Future<List<Agent>> agent;

  @override
  void initState() {
    super.initState();
    maps = fetchMaps();
    agent = fetchAgent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1F1D2B),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 30,
                  ),
                  Text(
                    'Laborant',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Colors.white, letterSpacing: .5, fontSize: 20),
                    ),
                  ),
                  Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 30,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 30),
              child: Text(
                'Maps',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Colors.white, letterSpacing: .5, fontSize: 15),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                top: 20,
              ),
              child: SizedBox(
                height: 180.0,
                child: FutureBuilder<List<MapsModel>>(
                    future: maps,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) =>
                              GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPageMaps(
                                    item: snapshot.data[index].uuid,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              height: 400,
                              width: 315,
                              decoration: BoxDecoration(
                                  color: Color(0xff252836),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Image.network(
                                        snapshot.data[index].splash,
                                        fit: BoxFit.cover,
                                        width: 315,
                                        height: 110,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data[index].displayName,
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              fontSize: 14,
                                              letterSpacing: 0.2),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          snapshot.data[index].coordinates,
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey,
                                              fontSize: 14,
                                              letterSpacing: 0.2),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Gagal menampilkan data Airing');
                      }
                      return CircularProgressIndicator();
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Text(
                'TOP ANIME',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Colors.white, letterSpacing: .5, fontSize: 15),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                // height: 200.0,
                child: FutureBuilder<List<Agent>>(
                  future: agent,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) =>
                            Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Card(
                            color: Color(0xff252836),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 0,
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  snapshot.data[index].displayIcon,
                                ),
                              ),
                              title: Text(
                                snapshot.data[index].displayName,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 14,
                                    letterSpacing: 0.2),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              subtitle: Text(
                                snapshot.data[index].role.displayName,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                    fontSize: 14,
                                    letterSpacing: 0.2),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPage(
                                      title: snapshot.data[index].displayName,
                                      item: snapshot.data[index].uuid,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

//fetch api

Future<List<MapsModel>> fetchMaps() async {
  String api = 'https://valorant-api.com/v1/maps';
  final response = await http.get(
    Uri.parse(api),
  );

  if (response.statusCode == 200) {
    var mapsJson = jsonDecode(response.body)['data'] as List;

    return mapsJson.map((maps) => MapsModel.fromJson(maps)).toList();

    //jika tidak di mapping hanya mendapat instance
    //intance of keynya
  } else {
    throw Exception('Failed to load maps');
  }
}

class Agent {
  String uuid;
  String displayName;
  String displayIcon;
  Role role;

  Agent({this.uuid, this.displayName, this.displayIcon, this.role});

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      uuid: json['uuid'],
      displayName: json['displayName'],
      displayIcon: json['displayIcon'],
      role: json['role'] != null ? Role.fromJson(json['role']) : null,
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

// function untuk fetch api
Future<List<Agent>> fetchAgent() async {
  String api = 'https://valorant-api.com/v1/agents';
  final response = await http.get(
    Uri.parse(api),
  );

  if (response.statusCode == 200) {
    var agentShowsJson = jsonDecode(response.body)['data'] as List,
        agentShows =
            agentShowsJson.map((agent) => Agent.fromJson(agent)).toList();

    agentShows.removeWhere(
        (role) => role.uuid == 'ded3520f-4264-bfed-162d-b080e2abccf9');
    //ngilangin ini gara2 rolenya sova yg pertama null
    return agentShows;
    //jika tidak di mapping hanya mendapat instance
    //intance of keynya
  } else {
    throw Exception('Failed to load shows');
  }
}
