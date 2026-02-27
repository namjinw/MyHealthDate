import 'dart:convert';

import 'package:http/http.dart';
import 'package:my_health_date/modoel/profile_target.dart';
import 'package:my_health_date/utils.dart';

import '../modoel/userInteraction.dart';

class UserController {
  static SignResponse user = SignResponse(success: false, tkn: '', mberId: '', mberNm: '');
  static DateTime time = DateTime(DateTime.now().year, 1, 1);
  static String submitTime = '';

  static Future<SignResponse?> SignIn (String username, String password) async {
    try {
      final response = await post(
        Uri.parse('${BaseUrl}/api/authenticate/signin'),
        headers: header,
        body: jsonEncode({
          "mberId" : username,
          "mberPassword" : password
        })
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return SignResponse.fromJson(json);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<SignResponse?> SignUp (String mberId, String mberPassword, String mberNm) async {
    try {
      final response = await post(
        Uri.parse("${BaseUrl}/api/authenticate/signup"),
        headers: header2,
        body: {
          'mberId' : mberId,
          'mberPassword' : mberPassword,
          'mberNm' : mberNm
        }
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return SignResponse.fromJson(json);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }


  static Future<bool> serProfile(profile_taget_Request request) async {
    try {
      final response = await put(
        Uri.parse('${BaseUrl}/api/profile'),
        headers: tokenHeader(request.token),
        body: jsonEncode({
          "mberNm" : request.mberNm,
          "sexdstn" : request.sexdstn,
          "height" : request.height,
          "weight" : request.weight,
          "brthdy" : request.brthdy,
          "stepTarget" : request.stepTarget,
          "waterTarget" : request.waterTarget,
        })
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}