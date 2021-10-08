import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  WorldTime({this.url, this.flag, this.location});

  String location; // location for the UI
  String time; // the time in that location
  String flag; // url to an asset flag icon
  String url; // location url for api endpoint
  bool isDayTime; // true or false if daytime or not

  Future<void> getTime() async {
    try {
      Response response =
          await get(Uri.parse("https://worldtimeapi.org/api/timezone/$url"));
      Map data = jsonDecode(response.body);
      // print(data);
      String datetime = data['utc_datetime'];
      String offset = data['utc_offset'].toString().substring(1, 3);
      // print(datetime);
      // print(offset);

      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: int.parse(offset)));

      if (now.hour > 5 && now.hour < 20) {
        isDayTime = true;
      } else {
        isDayTime = false;
      }
      time = DateFormat.jm().format(now);
    } catch (e) {
      print('caught error $e');
      time = 'network no dey';
    }
  }
}
