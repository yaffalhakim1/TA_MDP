import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_akhir_mdp/models/maps_models.dart';
import 'package:tugas_akhir_mdp/screens/detail_maps.dart';
import 'package:http/http.dart' as http;

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
    return Scaffold(
      body: Padding(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
            },
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
