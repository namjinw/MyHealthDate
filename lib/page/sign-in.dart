import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_health_date/utils.dart';

class Sign_inPage extends StatefulWidget {
  const Sign_inPage({super.key});

  @override
  State<Sign_inPage> createState() => _Sign_inPageState();
}

class _Sign_inPageState extends State<Sign_inPage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: appBar(),
        body: Column(
          children: [
            const SizedBox(height: 40),
            title(),
            const SizedBox(height: 25),
            form(),
          ],
        ),
      ),
    );
  }

  Widget title() => Center(
    child: Column(
      children: [
        Image.asset('assets/images/symbol.png', width: 140),
        const SizedBox(height: 25),
        const Text(
          'Please enter your information.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w700,
            fontFamily: fonts,
          ),
        ),
      ],
    ),
  );

  Widget form() => Form(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          input(Icons.person, 'Username', username),
          const SizedBox(height: 10),
          input(Icons.lock, 'Username', username),
          const SizedBox(height: 20),
          button(() {}, Colors.black.withAlpha(90), 'Sign in', radius: 12),
        ],
      ),
    ),
  );

  Widget input(icon, label, controller) => Container(
    height: 50,
    decoration: BoxDecoration(
      color: inputColor,
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: [
        Icon(icon, weight: 25, color: iconColor),
        Expanded(
          child: TextFormField(
            cursorColor: Colors.black,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: fonts,
              fontWeight: FontWeight.w500,
            ),
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.transparent,
              hintText: label,
              hintStyle: const TextStyle(color: iconColor),
            ),
          ),
        ),
      ],
    ),
  );

  Widget button(VoidCallback ontap, color, text, {borderColor = Colors.transparent, double radius = 0}) => GestureDetector(
    onTap: ontap,
    child: Container(
      width: sizew(context),
      height: 55,
      decoration: BoxDecoration(
        color: Color(0xff393838),
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: background,
            fontWeight: FontWeight.w700,
            fontFamily: fonts,
          ),
        ),
      ),
    ),
  );

  AppBar appBar() => AppBar(
    toolbarHeight: 100,
    title: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            'MY Health DATA',
            style: TextStyle(
              fontSize: 26,
              color: background,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
    backgroundColor: Colors.black,
  );
}
