import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(WeatherApp());

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  double temperature = 0;
  String location = 'Gaza';
  String weather_description = "clear";
  // String cityname = 'London';
  String searchApiUrl =
      "https://api.openweathermap.org/data/2.5/weather?q=Gaza&appid=10edd29a4b3f02d6048a18589d3fc036";

  String weather = "weather";
  String random_weather_img = "https://source.unsplash.com/random/?weather";
  String icon_weather = 'cold';
  String icon_url = "http://openweathermap.org/img/w/";
  String error_msg = "";

  Future<void> fetchSearch(String cityname) async {
    try {
      searchApiUrl =
          'https://api.openweathermap.org/data/2.5/weather?q=$cityname&appid=10edd29a4b3f02d6048a18589d3fc036';

      final searchResult = await http.get(Uri.parse(searchApiUrl));
      var result = json.decode(searchResult.body);

      setState(() {
        icon_url = "http://openweathermap.org/img/w/";
        location = result['name'];
        temperature = (result['main']['temp']); //kelvin
        temperature = temperature - 273.15;
        weather_description = result['weather'][0]['description'];
        random_weather_img = random_weather_img + weather_description;
        icon_weather = result['weather'][0]['icon'];
        icon_url = icon_url + icon_weather + ".png";
      });
    } catch (e) {
      setState(() {
        error_msg = "Sorry , we don't have data about this city,try again";
      });
    }
  }

  void onTextfeildClicked(String cityname) async {
    await fetchSearch(cityname);
  }

  @override
  void initState() {
    fetchSearch('Gaza');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(random_weather_img),
            fit: BoxFit.cover,
          ),
        ),
        child: new BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: new Container(
            decoration: new BoxDecoration(color: Colors.white.withOpacity(0.0)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Center(
                        child: Image(
                          image: NetworkImage(icon_url, scale: 0.5),
                        ),
                      ),
                      Center(
                        child: Text(
                          temperature.round().toString() + '°C',
                          style: TextStyle(color: Colors.white, fontSize: 70),
                        ),
                      ),
                      Center(
                        child: Text(
                          location,
                          style: TextStyle(color: Colors.white, fontSize: 30.0),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          weather_description,
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 300,
                        child: TextField(
                          onSubmitted: (value) => onTextfeildClicked(value),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                          decoration: InputDecoration(
                              hintText: 'Search another location ...',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.white,
                              )),
                        ),
                      ),
                      Text(
                        error_msg,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.redAccent, fontSize: 15),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
