import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_akhir_mdp/models/agent_detail_models.dart';

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
                      child: Image.network(snapshot.data.fullPortrait),
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
