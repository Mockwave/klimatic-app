import 'package:flutter/material.dart';
import '../utils/info.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class KlimaticHome extends StatefulWidget {
  @override
  _KlimaticHomeState createState() => _KlimaticHomeState();
}

class _KlimaticHomeState extends State<KlimaticHome> {
  String _enteredCity;

  Future _cityData(BuildContext context) async {
    Map results = await Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return CityScreen();
    }));
    if (results['enter'] != null && results.containsKey('enter')) {
      _enteredCity = results['enter'];
    } else {
      _enteredCity = "$defaultCity";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Container(
            alignment: Alignment.center,
            child: CircleAvatar(
              backgroundImage: AssetImage('images/icon.jpg'),
            ),
          ),
          title: new Text(
            "Klimatic",
            style: TextStyle(
                fontStyle: FontStyle.italic,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w400),
          ),
          backgroundColor: Colors.blue.shade300,
          actions: <Widget>[
            new IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  _cityData(context);
                }),
          ],
        ),
        body: new Stack(children: <Widget>[
          new Center(
            child: Image.asset('images/mountains.jpg',
                width: 1200.0, height: 1200.0, fit: BoxFit.fill),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.fromLTRB(0.0, 30.0, 40.0, 0.0),
            child: Text(
              "${_enteredCity == null ? defaultCity : _enteredCity.toUpperCase()}",
              style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                  fontStyle: FontStyle.italic),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(80.0, 120.0, 0.0, 0.0),
            child: new ListTile(
              title: updateTemp(
                  "${_enteredCity == null ? defaultCity : _enteredCity}"),
            ),
          ),
        ]));
  }
}

Future<Map> getClimateData(String appId, String city) async {
    var apiUrl =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$appId&units=metric";
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
    }

Widget updateTemp(String city) {
    return FutureBuilder(
      future: getClimateData(appId, city == null ? defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasData) {
          Map content = snapshot.data;
          return Container(
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: new ListTile(
              title: new Text(
                "${content['main']['temp']}°C",
                style: TextStyle(
                    fontSize: 50.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w800),
              ),
              subtitle: new Text(
                "Humidity: ${content['main']['humidity']}%\n"
                    "${content['weather'][0]['description']}".toUpperCase(),
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,fontStyle: FontStyle.italic),
              ),
            ),
          );
        } else
          return Container();
      },
    );

}

class CityScreen extends StatelessWidget {
  var _cityController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text(
            "Klimatic",
            style: TextStyle(
                fontStyle: FontStyle.italic,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w400),
          ),
          backgroundColor: Colors.grey.shade700,
        ),
        body: new Stack(children: <Widget>[
          new Center(
            child: Image.asset('images/street.jpg',
                width: 1200.0, height: 1200.0, fit: BoxFit.fill),
          ),
          Column(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  controller: _cityController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "Enter a city",
                      hintStyle:
                          TextStyle(color: Colors.white70, fontSize: 15.0),
                      icon: Icon(
                        Icons.location_city,
                        color: Colors.amber,
                      )),
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 180.0,
                height: 50.0,
                child: ListTile(
                    title: FlatButton(
                  onPressed: () {
                    if (_cityController.text.isNotEmpty) {
                      return Navigator.pop(
                          context, {'enter': _cityController.text});
                    } else
                      return Navigator.pop(context, {'empty': "$defaultCity"});
                  },
                  child: new Text("Get Weather",),
                  color: Colors.amber,
                  shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    )),
              )
            ],
          )
        ]));
  }
}
