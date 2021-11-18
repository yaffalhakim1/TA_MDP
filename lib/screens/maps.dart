import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_akhir_mdp/models/maps_models.dart';
import 'package:tugas_akhir_mdp/screens/detail_maps.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_akhir_mdp/theme.dart';

class MapsView extends StatefulWidget {
  const MapsView({Key key}) : super(key: key);

  @override
  _MapsViewState createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  Future<List<MapsModel>> maps;
  @override
  void initState() {
    super.initState();
    maps = fetchMaps();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff0F1923),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Center(
                  child: Image.asset(
                    'assets/logo.png',
                    scale: 40,
                  ),
                ),
              ),
              Text(
                'Choose your favorite maps',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.white,
                    letterSpacing: .5,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 20,
                  right: 20,
                ),
                child: FutureBuilder<List<MapsModel>>(
                  future: maps,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
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
                            margin: EdgeInsets.only(bottom: 10),
                            height: 180,
                            width: 300,
                            decoration: BoxDecoration(
                                color: gridColor,
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                      child: Image.network(
                                        snapshot.data[index].splash,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 110,
                                      ),
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
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
