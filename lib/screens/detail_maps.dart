import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_akhir_mdp/models/maps_detail_model.dart';

// ignore: must_be_immutable
class DetailPageMaps extends StatefulWidget {
  final String title;
  final String item;
  DetailPageMaps({
    Key key,
    this.title,
    this.item,
  }) : super(key: key);

  @override
  _DetailPageMapsState createState() => _DetailPageMapsState();
}

class _DetailPageMapsState extends State<DetailPageMaps> {
  Future<MapsDetail> maps;

  @override
  void initState() {
    super.initState();
    maps = fetchMaps(widget.item);
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
            child: FutureBuilder<MapsDetail>(
          future: maps,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                        child: Image.network(snapshot.data.splash),
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
                            child: Image.network(snapshot.data.displayIcon),
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
                                snapshot.data.coordinates,
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

//fetch api

Future<MapsDetail> fetchMaps(uuid) async {
  String api = 'https://valorant-api.com/v1/maps/$uuid';
  final response = await http.get(
    Uri.parse(api),
  );

  if (response.statusCode == 200) {
    return MapsDetail.fromJson(json.decode(response.body)['data']);
  } else {
    throw Exception('Failed to load maps');
  }
}
