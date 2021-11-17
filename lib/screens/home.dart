import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_akhir_mdp/models/agent_models.dart';
import 'package:tugas_akhir_mdp/screens/detail.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Agent>> agent;

  @override
  void initState() {
    super.initState();

    agent = fetchAgent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0F1923),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
              child: Center(
                child: Image.asset(
                  'assets/logo.png',
                  scale: 40,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Center(
                child: Text(
                  'Choose your awesome agents',
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SizedBox(
                // height: 200.0,
                child: FutureBuilder<List<Agent>>(
                  future: agent,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 2.0,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 5,
                        ),
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) => Card(
                          color: Color(0xff13212E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 0,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            leading: CircleAvatar(
                              radius: 20,
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
                                  fontSize: 10,
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
                      );
                    }
                    return Center(child: CircularProgressIndicator());
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

//fetch api

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
