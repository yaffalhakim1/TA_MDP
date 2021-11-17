import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_akhir_mdp/models/agent_detail_models.dart';
import 'package:tugas_akhir_mdp/theme.dart';

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
                      decoration: BoxDecoration(
                        color: Color(0xff13212E),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Text(
                                  snapshot.data.displayName.toUpperCase(),
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1.5,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  snapshot.data.role.displayName,
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1.5,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 190,
                            height: 230,
                            child: Image.network(snapshot.data.fullPortrait),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'DESCRIPTION',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: .5,
                              fontSize: 15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        snapshot.data.description,
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.white54,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'ABILITIES',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.white,
                            letterSpacing: .5,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      height: 400,
                      child: ListView.builder(
                        itemCount: snapshot.data.abilities.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Color(0xff13212E),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          width: 40,
                                          height: 40,
                                          child: Image.network(snapshot.data
                                              .abilities[index].displayIcon),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          snapshot.data.abilities[index]
                                              .displayName,
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              color: Colors.white,
                                              letterSpacing: .5,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      snapshot
                                          .data.abilities[index].description,
                                      textAlign: TextAlign.justify,
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white54,
                                          letterSpacing: .5,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ));
                        },
                      ),
                    )
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Gagal menampilkan data detail'),
              );
            }
            return const CircularProgressIndicator();
          },
        )),
      ),
    );
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
