import 'package:flutter/material.dart';
import 'package:my_health_date/controller/user.dart';
import 'package:my_health_date/utils.dart';

class Selectbirthday extends StatefulWidget {
  const Selectbirthday({super.key});

  @override
  State<Selectbirthday> createState() => _SelectbirthdayState();
}

class _SelectbirthdayState extends State<Selectbirthday> {
  final yController = FixedExtentScrollController();
  final mController = FixedExtentScrollController();
  final dController = FixedExtentScrollController();

  DateTime now = UserController.time;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: sizew(context),
        height: 270,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Birthday',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: fonts,
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: sizew(context),
                height: 100,
                child: Row(
                  children: [YearPicker(), MontyPicker(), DayPicker()],
                ),
              ),

              const SizedBox(height: 40),
              submitButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget YearPicker() {
    return basePicker(
      yController,
      ListWheelChildLoopingListDelegate(
        children: List.generate(
          70,
          (index) => Center(child: Text('${DateTime.now().year - index}')),
        ),
      ),
      (index) {
        print(DateTime.now().year - index);
        now = DateTime((DateTime.now().year - index).toInt(), now.month, now.day);
        print('year pick $now');
        setState(() {});
      },
    );
  }

  Widget MontyPicker() {
    return basePicker(
      mController,
      ListWheelChildLoopingListDelegate(
        children: List.generate(
          12,
          (index) => Center(child: Text('${index + 1}')),
        ),
      ),
      (index) {
        print(index + 1);
        now = DateTime(now.year, index + 1, 1);
        print('month pick $now');
        setState(() {});
      },
    );
  }

  Widget DayPicker() {
    DateTime maxDay = DateTime(now.year, now.month + 1, 0);

    return basePicker(
      dController,
      ListWheelChildLoopingListDelegate(
        children: List.generate(
          maxDay.day,
          (index) => Center(child: Text('${index + 1}')),
        ),
      ),
      (index) {
        print(index + 1);
        now = DateTime(now.year, now.month, index + 1);
        print('day pick $now');
        setState(() {});
      },
    );
  }

  Widget basePicker(controller, child, onChange) => Expanded(
    child: DefaultTextStyle(
      style: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontFamily: fonts,
        fontWeight: FontWeight.w700,
      ),
      child: ListWheelScrollView.useDelegate(
        itemExtent: 50,
        diameterRatio: 500,
        useMagnifier: true,
        magnification: 1.1,
        onSelectedItemChanged: onChange,
        physics: FixedExtentScrollPhysics(),
        controller: controller,
        childDelegate: child,
      ),
    ),
  );

  Widget submitButton() => GestureDetector(
    onTap: () {
      UserController.submitTime = '${now.year}-${now.month}-${now.day}';
      print('Confirm submit time : ${now.year}-${now.month}-${now.day}');
      Navigator.pop(context);
      setState(() {});
    },
    child: Container(
      width: sizew(context),
      height: 45,
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
          'Confirm',
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
}
