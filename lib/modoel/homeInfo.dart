class HomeInfo {
  final String mberNm;
  final String sexdstn;
  final double height;
  final double weight;
  final int stepTarget;
  final int waterTarget;
  final int totalStep;
  final int minHeartRate;
  final int maxHeartRate;
  final List<FoodImg> footImg;
  final int totalWater;

  HomeInfo({
    required this.mberNm,
    required this.sexdstn,
    required this.height,
    required this.weight,
    required this.stepTarget,
    required this.waterTarget,
    required this.totalStep,
    required this.minHeartRate,
    required this.maxHeartRate,
    required this.footImg,
    required this.totalWater,
  });

  factory HomeInfo.None() {
    return HomeInfo(
      mberNm: '',
      sexdstn: '',
      height: 0.0,
      weight: 0.0,
      stepTarget: 0,
      waterTarget: 0,
      totalStep: 0,
      minHeartRate: 0,
      maxHeartRate: 0,
      footImg: [],
      totalWater: 0,
    );
  }

  factory HomeInfo.fromJson(Map<String, dynamic> json) {
    return HomeInfo(
      mberNm: json['mberNm'],
      sexdstn: json['sexdstn'],
      height: json['height'],
      weight: json['weight'],
      stepTarget: json['stepTarget'],
      waterTarget: json['waterTarget'],
      totalStep: json['totalStep'],
      minHeartRate: json['minHeartRate'],
      maxHeartRate: json['maxHeartRate'],
      footImg: (json['list'] as List).map((e) => FoodImg.fromJson(e)).toList(),
      totalWater: json['totalWater'],
    );
  }
}

class FoodImg {
  final int foodUid;
  final String fileNm;

  FoodImg({required this.foodUid, required this.fileNm});

  factory FoodImg.fromJson(Map<String, dynamic> json) {
    return FoodImg(foodUid: json['foodUid'], fileNm: json['fileNm']);
  }
}
