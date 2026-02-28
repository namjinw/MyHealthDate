import 'dart:convert';

import 'package:http/http.dart';
import 'package:my_health_date/modoel/homeInfo.dart';
import 'package:my_health_date/modoel/profile.dart';
import 'package:my_health_date/utils.dart';

class InfoController {
  static HomeInfo info = HomeInfo.None();

  static Future<void> infoInit(String token, String today) async {
    final Profile profile = await getProfile(token);
    final int steps = await getSteps(token, today);
    final Map<String, int> heartRate = await getHeartRate(token, today);
    final List<FoodImg> foods = await getFoods(token, today);
    final int water = await getWater(token, today);

    final HomeInfo infoCopy = HomeInfo(
      mberNm: profile.mberNm,
      sexdstn: profile.sexdstn,
      height: profile.height,
      weight: profile.weight,
      totalStep: steps,
      minHeartRate: heartRate['min']!,
      maxHeartRate: heartRate['max']!,
      footImg: foods,
      totalWater: water,
    );

    print(infoCopy);

    info = infoCopy;
  }

  static Future<Profile> getProfile(String token) async {
    try {
      final response = await get(
        Uri.parse('${BaseUrl}/api/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print(response.statusCode);
      print(response.body);
      final Map<String, dynamic> json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return Profile.fromJson(json);
      }
      return Profile.None();
    } catch (e) {
      print(e);
      return Profile.None();
    }
  }

  static Future<int> getSteps(String token, String today) async {
    try {
      final response = await get(
        Uri.parse('${BaseUrl}/api/step/$today'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return json['totalStep'];
      }
      return 0;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  static Future<Map<String, int>> getHeartRate(
    String token,
    String today,
  ) async {
    try {
      final response = await get(
        Uri.parse('${BaseUrl}/api/heart/$today'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return {'min': json['totalStep'], 'max': json['totalStep']};
      }
      return {'min': 0, 'max': 0};
    } catch (e) {
      print(e);
      return {'min': 0, 'max': 0};
    }
  }

  static Future<List<FoodImg>> getFoods(String token, String today) async {
    try {
      final response = await get(
        Uri.parse('${BaseUrl}/api/food/$today'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final List<FoodImg> foodList = [];
        for (var i in json['list']) {
          foodList.add(FoodImg.fromJson(i));
        }
        return foodList;
      }
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<int> getWater(String token, String today) async {
    try {
      final response = await get(
        Uri.parse('${BaseUrl}/api/water/$today'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return json['totalWater'];
      }
      return 0;
    } catch (e) {
      print(e);
      return 0;
    }
  }
}
