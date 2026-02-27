import 'dart:ffi';

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:my_health_date/controller/user.dart';
import 'package:my_health_date/modoel/profile_target.dart';
import 'package:my_health_date/page/sign-in.dart';
import 'package:my_health_date/utils.dart';

import 'component/selectBirthday.dart';

class profile_tagetPage extends StatefulWidget {
  const profile_tagetPage({super.key});

  @override
  State<profile_tagetPage> createState() => _profile_tagetPageState();
}

class _profile_tagetPageState extends State<profile_tagetPage> {
  String sexdstn = 'M';

  final profileFormat = NumberFormat('0.0');
  final targetFormat = NumberFormat('#,###');

  final TextEditingController mberNm = TextEditingController(
    text: UserController.user.mberNm,
  );
  final TextEditingController height = TextEditingController();
  final TextEditingController weight = TextEditingController();
  final TextEditingController brthdy = TextEditingController();
  final TextEditingController stepTarget = TextEditingController();
  final TextEditingController waterTarget = TextEditingController();

  void formating(String value, TextEditingController controller) {
    if (value.isEmpty) return;

    final number = double.tryParse(value); // 변환하기
    if (number == null) return; // 만약 아무값도 입력하지 않으면 그냥 반환

    final newNumber = profileFormat.format(number); // 변환하기

    controller.value = TextEditingValue(text: newNumber);
  }

  void targetFormating(String value, TextEditingController controller) {
    if (value.isEmpty) return;

    String clean = value.replaceAll(',', '');

    final number = int.tryParse(clean);
    if (number == null) return;

    final newNumber = targetFormat.format(number);

    controller.value = TextEditingValue(text: newNumber);
  }

  Future<void> set_profile() async {
    if (mberNm.text.isEmpty) {
      ShowSnackerBar(context, Icons.error_outline, '유저 이름이 입력 되지 않았습니다.');
    } else if (mberNm.text.length < 3) {
      ShowSnackerBar(context, Icons.error_outline, '유저 이름은 4자 이상이여야 합니다.');
    } else if (height.text.isEmpty) {
      ShowSnackerBar(context, Icons.error_outline, '키가 입력 되지 않았습니다.');
    } else if (weight.text.isEmpty) {
      ShowSnackerBar(context, Icons.error_outline, '몸무게가 입력 되지 않았습니다.');
    } else if (UserController.submitTime == '') {
      ShowSnackerBar(context, Icons.error_outline, '생년월일이 입력 되지 않았습니다.');
    } else if (stepTarget.text.isEmpty) {
      ShowSnackerBar(context, Icons.error_outline, '걸음 수가 입력 되지 않았습니다.');
    } else if (waterTarget.text.isEmpty) {
      ShowSnackerBar(context, Icons.error_outline, '물(ml)이 입력 되지 않았습니다.');
    } else {
      final response = await UserController.serProfile(
        profile_taget_Request(
          token: UserController.user.tkn,
          mberNm: mberNm.text,
          sexdstn: sexdstn,
          height: double.tryParse(height.text) ?? 0.0,
          weight: double.tryParse(weight.text) ?? 0.0,
          brthdy: brthdy.text,
          stepTarget: int.tryParse(stepTarget.text) ?? 0,
          waterTarget: int.tryParse(waterTarget.text) ?? 0,
        ),
      );

      if (response == true) UserController.submitTime = '';
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Sign_inPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: background,
        resizeToAvoidBottomInset: false,
        appBar: appBar(),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Hi ${UserController.user.mberNm}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    fontFamily: fonts,
                  ),
                ),
                const SizedBox(height: 20),

                selectMW(),
                const SizedBox(height: 25),

                profile(),
                const SizedBox(height: 75),

                target(),
                const SizedBox(height: 35),
                submitButton(),

                const SizedBox(height: 45),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget selectMW() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Profile,',
        style: TextStyle(
          color: Colors.black,
          fontSize: 28,
          fontWeight: FontWeight.w800,
          fontFamily: fonts,
        ),
      ),

      const SizedBox(height: 8),

      Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            selectButton(
              () => setState(() {
                sexdstn = 'M';
              }),
              'M',
              'man_FILL0_wght400_GRAD0_opsz24.svg',
              'Male',
            ),
            selectButton(
              () => setState(() {
                sexdstn = 'S';
              }),
              'S',
              'woman_FILL0_wght400_GRAD0_opsz24.svg',
              'Female',
            ),
          ],
        ),
      ),
    ],
  );

  Widget selectButton(ontap, index, svg, text) {
    bool isTrue = sexdstn == index;

    return GestureDetector(
      onTap: ontap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 145,
        height: 145,
        decoration: BoxDecoration(
          color: inputColor,
          border: Border.all(
            width: 2,
            color: isTrue ? Colors.black : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/$svg',
              height: 85,
              colorFilter: ColorFilter.mode(
                isTrue ? Colors.black : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: fonts,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profile() => Column(
    spacing: 15,
    children: [
      username(),
      input(
        height,
        SvgPicture.asset(
          'assets/images/height-svgrepo-com.svg',
          height: 30,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
        'height',
        'Cm',
        [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          // 0~9 . 만 입력되게
        ],
        5,
        onTapOutside: formating,
      ),
      input(
        weight,
        SvgPicture.asset(
          'assets/images/weight-svgrepo-com.svg',
          height: 26,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
        'weight',
        'Kg',
        [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          // 0~9 . 만 입력되게
        ],
        5,
        onTapOutside: formating,
      ),

      birth(),
    ],
  );

  Widget username() => noclickInput(
    Colors.grey,
    mberNm.text,
    Icon(Icons.person, size: 26, color: iconColor),
    ontap: () {},
  );

  Widget birth() => noclickInput(
    UserController.submitTime == '' ? Colors.grey : Colors.black,
    UserController.submitTime == ''
        ? 'Birthday'
        : UserController.submitTime.replaceAll('-', '.'),
    SvgPicture.asset(
      'assets/images/cake-svgrepo-com.svg',
      height: 26,
      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
    ),
    ontap: () {
      showDialog(
        context: context,
        builder: (context) => Selectbirthday(),
        barrierDismissible: false,
      );
    },
  );

  Widget noclickInput(color, text, icon, {ontap}) => GestureDetector(
    onTap: ontap,
    child: Container(
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
            child: Text(
              text,
              style: TextStyle(color: color, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    ),
  );

  Widget target() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 15,
    children: [
      const Text(
        'Target,',
        style: TextStyle(
          color: Colors.black,
          fontSize: 28,
          fontWeight: FontWeight.w800,
          fontFamily: fonts,
        ),
      ),

      input(
        stepTarget,
        SvgPicture.asset(
          'assets/images/footprint_FILL0_wght400_GRAD0_opsz24.svg',
          height: 30,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
        '5.000',
        'Steps',
        [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
          // 0~9 . 만 입력되게
        ],
        10,
        onChanged: targetFormating,
      ),
      input(
        waterTarget,
        SvgPicture.asset(
          'assets/images/water_drop_FILL0_wght400_GRAD0_opsz24.svg',
          height: 26,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
        '2.000',
        'ml',
        [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
          // 0~9 . 만 입력되게
        ],
        10,
        onChanged: targetFormating,
      ),
    ],
  );

  Widget input(
    TextEditingController controller,
    icon,
    label,
    suffix,
    inputFormat,
    length, {
    onChanged,
    onTapOutside,
    suffixShow = true,
    keyboardType = TextInputType.number,
  }) => Container(
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
            maxLength: length,
            controller: controller,
            inputFormatters: inputFormat,
            keyboardType: keyboardType,
            onChanged: (value) => onChanged(value, controller),
            onTapOutside: (event) {
              if (onTapOutside != null) {
                FocusManager.instance.primaryFocus?.unfocus();
                (controller.text, controller);
              }
            },
            onFieldSubmitted: (value) {
              if (onTapOutside != null) onTapOutside(value, controller);
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: label,
              labelStyle: TextStyle(color: Colors.grey),
              counterText: '',
              suffixText: suffixShow ? suffix : null,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixStyle: TextStyle(color: iconColor),
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

  Widget submitButton() => GestureDetector(
    onTap: set_profile,
    child: Container(
      width: sizew(context),
      height: 50,
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
          'Complete',
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

  AppBar appBar() => AppBar(
    centerTitle: true,
    backgroundColor: appBarColor,
    leading: IconButton(
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Sign_inPage()),
          (route) => false,
        );
      },
      icon: const Icon(Icons.arrow_back, color: background, size: 30),
    ),
    title: const Text(
      'Profile & Target',
      style: TextStyle(
        fontWeight: FontWeight.w700,
        color: background,
        fontFamily: fonts,
        fontSize: 16,
      ),
    ),
  );
}
