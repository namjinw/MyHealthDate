import 'package:flutter/material.dart';
import 'package:my_health_date/page/sign-in.dart';

import '../utils.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool symbolShow = false;
  bool symbolTextShow = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 800));
      symbolShow = true;
      setState(() {});

      await Future.delayed(Duration(milliseconds: 1200));
      symbolTextShow = true;
      setState(() {});

      await Future.delayed(Duration(milliseconds: 800));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Sign_inPage()),
        (route) => false,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 450),
                  padding: EdgeInsets.only(bottom: symbolShow == true ? 0 : 50),
                  curve: Curves.easeInOut,
                  child: AnimatedOpacity(
                    opacity: symbolShow == true ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                    child: Image.asset('assets/images/symbol.png', width: 140),
                  ),
                ),
                SizedBox(height: 20),
                AnimatedOpacity(
                  opacity: symbolTextShow == true ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                  child: const Text(
                    'My Health DATA',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
