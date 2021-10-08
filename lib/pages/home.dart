import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};

  bool isNetworkAvailable;

  @override
  Widget build(BuildContext context) {
    String bgImage;
    Color bgColor;
    print(bgImage);

    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    print(data);
    String _timeHasData = data['time'];
    bool _nightOrDay = data['isDayTime'];

    if (_timeHasData == 'network no dey') {
      isNetworkAvailable = false;
    } else {
      isNetworkAvailable = true;
    }
    if (_nightOrDay == false) {
      bgImage = 'night.png';
      bgColor = Colors.indigo[700];
    } else if (_nightOrDay == true) {
      bgImage = 'day.png';
      bgColor = Colors.blue;
    }

    void setupWorldTime() async {
      WorldTime instance = WorldTime(
          location: 'Lagos', url: 'Africa/Lagos', flag: 'germany.png');
      await instance.getTime();
      Navigator.pushReplacementNamed(context, '/home', arguments: {
        'location': instance.location,
        'flag': instance.flag,
        'time': instance.time,
        'isDayTime': instance.isDayTime
      });
    }

    return Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/$bgImage'), fit: BoxFit.cover)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 120, 0, 0),
              child: Column(
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      dynamic result =
                          await Navigator.pushNamed(context, '/location');
                      setState(() {
                        data = {
                          'time': result['time'],
                          'location': result['location'],
                          'isDayTime': result['isDayTime'],
                          'flag': result['flag']
                        };
                      });
                    },
                    icon: Icon(
                      Icons.edit_location_outlined,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Change Location',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data['location'],
                        style: TextStyle(
                            fontSize: 28.0,
                            letterSpacing: 2.0,
                            color: Colors.white),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  isNetworkAvailable == true
                      ? Text(
                          data['time'],
                          style: TextStyle(fontSize: 66, color: Colors.white),
                        )
                      : AlertDialog(
                          title: Text('No Network'),
                          content: ElevatedButton(
                            onPressed: () async {
                              setupWorldTime();
                              setState(() {
                                isNetworkAvailable = false;
                              });
                            },
                            child: Text('Retry'),
                          ),
                        ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
