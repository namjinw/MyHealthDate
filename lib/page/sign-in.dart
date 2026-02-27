import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_health_date/controller/user.dart';
import 'package:my_health_date/page/home.dart';
import 'package:my_health_date/page/sign_up.dart';
import 'package:my_health_date/utils.dart';

class Sign_inPage extends StatefulWidget {
  const Sign_inPage({super.key});

  @override
  State<Sign_inPage> createState() => _Sign_inPageState();
}

class _Sign_inPageState extends State<Sign_inPage> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<void> login() async {
    if (username.text == null || username.text.isEmpty) {
      ShowSnackerBar(context, Icons.error_outline, '유저 이름을 공백으로 제출하면 안됩니다.');
      return;
    }
    if (username.text.length < 3) {
      ShowSnackerBar(context, Icons.error_outline, '유저 이름은 4자 이상이여야 합니다.');
      return;
    }
    if (password.text.length < 3) {
      ShowSnackerBar(context, Icons.error_outline, '비밀번호는 4자 이상이여야 합니다.');
      return;
    }

    final response = await UserController.SignIn(username.text, password.text);

    if (response != null && response.success) {
      UserController.user = response;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: background,
        resizeToAvoidBottomInset: false,
        appBar: appBar(),
        body: SizedBox.expand(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    title(),
                    const SizedBox(height: 25),
                    form(),
                  ],
                ),
              ),

              bottomnav(),
            ],
          ),
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
          input(Icons.lock, 'Password', password, password: true),
          const SizedBox(height: 20),
          button(login, Color(0xff393838), 'Sign in', radius: 12),
        ],
      ),
    ),
  );

  Widget input(icon, label, controller, {password = false}) => Container(
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
            obscureText: password,
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

  Widget button(
    VoidCallback ontap,
    color,
    text, {
    borderColor = Colors.transparent,
    double radius = 0,
    bottom = false,
  }) => GestureDetector(
    onTap: ontap,
    child: Container(
      width: sizew(context),
      height: bottom == true ? 45 : 50,
      decoration: BoxDecoration(
        color: color,
        boxShadow: bottom == true
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withAlpha(90),
                  blurRadius: 3,
                  offset: const Offset(0, 3),
                ),
              ],
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(width: 1, color: borderColor),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: bottom == true ? 17 : 13,
            color: color == background ? Colors.black : background,
            fontWeight: FontWeight.w800,
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

  Widget bottomnav() => Positioned(
    left: 0,
    right: 0,
    bottom: 0,
    child: Container(
      height: 220,
      decoration: BoxDecoration(color: bottomMenuColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            button(
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Sign_upPage()),
                );
              },
              Colors.black,
              'Sign Up',
              bottom: true,
            ),
            const SizedBox(height: 20),
            button(
              () {
                ShowSnackerBar(
                  context,
                  Icons.add_circle_outline,
                  '아직 준비 중인 기능입니다!',
                );
              },
              background,
              'Password Reset',
              bottom: true,
              borderColor: Colors.grey,
            ),
          ],
        ),
      ),
    ),
  );
}
