// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  int temperature = 0;
  String location = "London";
  int woeid = 44418;
  String weather = "clear";
  String abbreviation = '';
  String errorMessage = '';

  String searchApiUrl =
      'https://www.metaweather.com/api/location/search/?query=';
  String locationApiUrl = 'https://www.metaweather.com/api/location/';

  @override
  void initState() {
    super.initState();
    fetchLocation();
  }

  void fetchSearch(String input) async {
    try {
      var oriSearchResult = searchApiUrl + input;
      var searchResults = await http.get(Uri.parse(oriSearchResult));
      var result = json.decode(searchResults.body)[0];

      setState(() {
        location = result["title"];
        woeid = result["woeid"];
        errorMessage = '';
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Sorry! Data not available.';
      });
    }
  }

  void fetchLocation() async {
    var oriLocationResult = locationApiUrl + woeid.toString();
    var locationResult = await http.get(Uri.parse(oriLocationResult));
    var result = json.decode(locationResult.body);
    var consolatedweather = result["consolidated_weather"];
    var data = consolatedweather[0];

    setState(() {
      temperature = data["the_temp"].round();
      weather = data["weather_state_name"].replaceAll(' ', '').toLowerCase();
      abbreviation = data['weather_state_abbr'];
    });
  }

  void onTextFieldSubmitted(input) async {
    fetchSearch(input);
    fetchLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/$weather.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      // ignore: unnecessary_null_comparison
      child: temperature == null
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Center(
                        child: Image.network(
                          'https://www.metaweather.com/static/img/weather/png/' +
                              abbreviation +
                              '.png',
                          width: 100,
                        ),
                      ),
                      Center(
                        child: Text(
                          temperature.toString() + 'C',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 60,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          location,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 60,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      // ignore: sized_box_for_whitespace
                      Container(
                        width: 300,
                        child: TextField(
                          onSubmitted: (String input) {
                            onTextFieldSubmitted(input);
                          },
                          style: const TextStyle(
                              color: Colors.white, fontSize: 25),
                          decoration: const InputDecoration(
                            hintText: 'Search Location',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}


/* Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "Exit",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 30,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyLogin(),
                          ),
                        );
                      },
                    ),
                  ],
                ), */