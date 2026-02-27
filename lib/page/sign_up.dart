import 'package:flutter/material.dart';
import 'package:my_health_date/controller/user.dart';
import 'package:my_health_date/page/profile_taget.dart';
import 'package:my_health_date/page/sign-in.dart';
import 'package:my_health_date/utils.dart';

class Sign_upPage extends StatefulWidget {
  const Sign_upPage({super.key});

  @override
  State<Sign_upPage> createState() => _Sign_upPageState();
}

class _Sign_upPageState extends State<Sign_upPage> {
  final TextEditingController mberId = TextEditingController();
  final TextEditingController mberPassword = TextEditingController();
  final TextEditingController mberNm = TextEditingController();
  final TextEditingController checkMberPassword = TextEditingController();

  Future<void> signUp() async {
    if (mberId.text.isEmpty) {
      ShowSnackerBar(context, Icons.error_outline, '유저 아이디는 필수입니다.');
      return;
    }
    if (mberNm.text.isEmpty) {
      ShowSnackerBar(context, Icons.error_outline, '유저 이름은 필수입니다.');
      return;
    }
    if (mberNm.text.length < 3) {
      ShowSnackerBar(context, Icons.error_outline, '유저 이름은 4자 이상입니다.');
      return;
    }
    if (mberPassword.text.isEmpty) {
      ShowSnackerBar(context, Icons.error_outline, '비밀번호는 필수입니다.');
      return;
    }
    if (mberPassword.text.length < 3) {
      ShowSnackerBar(context, Icons.error_outline, '비밀번호는 4자 이상입니다.');
      return;
    }
    if (checkMberPassword.text.isEmpty) {
      ShowSnackerBar(context, Icons.error_outline, '비밀번호 확인은 필수입니다.');
      return;
    }
    if (checkMberPassword.text.length < 3) {
      ShowSnackerBar(context, Icons.error_outline, '비밀번호 확인은 4자 이상입니다.');
      return;
    }
    if (checkMberPassword.text != mberPassword.text) {
      ShowSnackerBar(context, Icons.error_outline, '비밀번호가 일치하지 않습니다.');
      return;
    }

    final response = await UserController.SignUp(
      mberId.text,
      mberPassword.text,
      mberNm.text,
    );

    if (response != null && response.success) {
      UserController.user = response;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => profile_tagetPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: appbar(),
        backgroundColor: background,
        resizeToAvoidBottomInset: false, // 요소 안 밀리게 고정
        body: SizedBox.expand(
          child: Stack(children: [signUpForm(), bottomBar()]),
        ),
      ),
    );
  }

  Widget signUpForm() => SingleChildScrollView(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Your information,',
            style: TextStyle(
              color: Colors.black,
              fontFamily: fonts,
              fontWeight: FontWeight.w700,
              fontSize: 30,
            ),
          ),

          const SizedBox(height: 40),

          form(),
        ],
      ),
    ),
  );

  Widget form() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Form(
      child: Column(
        spacing: 12,
        children: [
          input(
            mberId,
            Icon(Icons.person, color: iconColor, size: 28),
            'UserID',
          ),
          input(
            mberNm,
            Icon(Icons.badge_outlined, color: iconColor, size: 32),
            'Username',
          ),
          input(
            mberPassword,
            Icon(Icons.lock_sharp, color: iconColor, size: 26),
            'Password',
            password: true,
          ),
          input(
            checkMberPassword,
            Icon(Icons.lock_reset_outlined, color: iconColor, size: 28),
            'Confirm Password',
            password: true,
          ),

          const SizedBox(height: 12),

          submitButton(),
        ],
      ),
    ),
  );

  Widget submitButton() => GestureDetector(
    onTap: () => signUp(),
    child: Container(
      width: sizew(context),
      height: 55,
      decoration: BoxDecoration(
        color: appBarColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Sign Up',
          style: TextStyle(
            color: background,
            fontWeight: FontWeight.w700,
            fontSize: 14,
            fontFamily: fonts,
          ),
        ),
      ),
    ),
  );

  Widget bottomBar() => Positioned(
    left: 0,
    right: 0,
    bottom: 0,
    child: Container(
      height: 210,
      width: sizew(context),
      decoration: BoxDecoration(color: bottomMenuColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          bottomButton(
            () => Navigator.pop(context),
            'Sign In',
          ),
          const SizedBox(height: 15),
          bottomButton(
            () => ShowSnackerBar(
              context,
              Icons.add_circle_outline,
              '아직 준비 중인 기능입니다!',
            ),
            'Password Reset',
          ),
        ],
      ),
    ),
  );

  Widget bottomButton(ontap, text) => GestureDetector(
    onTap: ontap,
    child: Container(
      width: sizew(context) * 0.7,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(width: 1, color: Colors.grey.shade400),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: fonts,
          ),
        ),
      ),
    ),
  );

  Widget input(controller, icon, label, {password = false}) => Container(
    width: sizew(context),
    height: 50,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: inputColor,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Center(
          child: SizedBox(width: 30, child: Center(child: icon)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            obscureText: password,
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: label,
              hintStyle: const TextStyle(
                color: iconColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  AppBar appbar() => AppBar(
    centerTitle: true,
    backgroundColor: appBarColor,
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back, color: background, size: 30),
    ),
    title: const Text(
      'Sign Up',
      style: TextStyle(
        fontWeight: FontWeight.w700,
        color: background,
        fontFamily: fonts,
        fontSize: 16,
      ),
    ),
  );
}
