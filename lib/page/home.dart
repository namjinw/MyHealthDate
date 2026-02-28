import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_health_date/controller/info.dart';
import 'package:my_health_date/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final info = InfoController.info;
  late double bmi;

  @override
  Widget build(BuildContext context) {

    final double h = info.height / 100;
    bmi = info.weight / (h * h);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Column(children: [profile()]),
    );
  }

  Widget profile() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Hello ${info.mberNm},',
        style: TextStyle(
          fontSize: 24,
          fontFamily: fonts,
          fontWeight: FontWeight.w400,
        ),
      ),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Container(
          width: sizew(context),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 125,
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: profileInfo(),
        ),
      ),
    ],
  );

  Widget profileInfo() {
    String gender = info.sexdstn == 'M'
        ? 'man_FILL0_wght400_GRAD0_opsz24.svg'
        : 'woman_FILL0_wght400_GRAD0_opsz24.svg';

    return Row(
      children: [
        SizedBox(
          height: 105,
          width: 75,
          child: SvgPicture.asset(
            'assets/images/$gender',
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                bodyInfo(),
                Expanded(child: bmiGraph()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget bodyInfo() {
    final double h = info.height / 100;
    final double bmi = info.weight / (h * h);

    return Row(
      children: [
        Expanded(child: baseInfoItem('${info.height}', 'Cm')),
        Container(width: 2, height: 45, color: Colors.grey),
        Expanded(child: baseInfoItem('${info.weight}', 'Kg')),
        Container(width: 2, height: 45, color: Colors.grey),
        Expanded(child: baseInfoItem(bmi.toStringAsFixed(2), 'bmi')),
      ],
    );
  }

  Widget baseInfoItem(text, unit) => Column(
    children: [
      Text(
        text,
        style: const TextStyle(
          height: 0.6,
          fontWeight: FontWeight.w700,
          fontFamily: fonts,
          fontSize: 22,
        ),
      ),
      Text(
        unit,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontFamily: fonts,
          fontSize: 22,
        ),
      ),
    ],
  );

  Widget bmiGraph() => baseGraph(-4, bmi.toStringAsFixed(2), 20);

  Widget baseGraph(double top, text, double left) => Stack(
    children: [
      graphBody(),
      Positioned(
        left: left,
        top: 0,
        child: Column(
          children: [
            Container(width: 1, height: 15, color: background),
            const SizedBox(height: 10),
            baseGraphShowGauge(top, text),
          ],
        ),
      ),
    ],
  );

  Widget graphBody() => Container(
    width: sizew(context) * 0.6,
    height: 15,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFF069cf5),
          Color(0xFF5bc307),
          Color(0xFFf6e100),
          Color(0xFFf78100),
          Color(0xFFf78100),
          Color(0xFFf60000),
        ],
        stops: [0, 0.167, 0.431, 0.615, 0.787, 1],
      ),
      borderRadius: BorderRadius.circular(15),
    ),
  );

  Widget baseGraphShowGauge(double top, text) => Stack(
    clipBehavior: Clip.none,
    children: [
      Positioned(
        top: top,
        left: 15,
        child: Transform.rotate(
          angle: 0.8,
          child: Container(width: 10, height: 10, color: gaugeColor),
        ),
      ),
      Container(
        width: 45,
        height: 20,
        color: gaugeColor,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: background,
              fontFamily: fonts,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ),
    ],
  );
}
