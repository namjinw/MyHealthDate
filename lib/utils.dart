import 'package:flutter/material.dart';

const Color background = Colors.white;
const String fonts = 'NotoSansKR';
const Color inputColor = Color(0xfff6f6f6);
const Color iconColor = Color(0xff9f9f9f);
const Color boxColor = Color(0xffe3e3e3);
const Color gaugeColor = Color(0xffb6b6b6);
const Color bottomMenuColor = Color(0xfff8f8f8);
const Color appBarColor = Color(0xff252525);
const String BaseUrl = 'http://10.0.2.2:8000';
const header = {"Content-Type": "application/json"};
tokenHeader(String token) => {
  "Content-Type": "application/json",
  "Authorization": "Bearer $token"
};
const header2 = {
  "Content-Type" : "application/x-www-form-urlencoded"
};

ShowSnackerBar(context, icon, text) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Row(
          children: [
            Icon(icon, color: background),
            const SizedBox(width: 15),
            Text(
              text,
              style: const TextStyle(
                color: background,
                fontFamily: fonts,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );

double sizew(context) => MediaQuery.sizeOf(context).width;
double sizeh(context) => MediaQuery.sizeOf(context).height;
