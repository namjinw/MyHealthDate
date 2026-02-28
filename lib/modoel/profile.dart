class Profile {
  final String mberNm;
  final String sexdstn;
  final double height;
  final double weight;
  final int stepTarget;
  final int waterTarget;

  Profile({
    required this.mberNm,
    required this.sexdstn,
    required this.height,
    required this.weight,
    required this.stepTarget,
    required this.waterTarget,
  });

  factory Profile.None() {
    return Profile(
      mberNm: '',
      sexdstn: '',
      height: 0.0,
      weight: 0.0,
      stepTarget: 0,
      waterTarget: 0,
    );
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      mberNm: json['mberNm'],
      sexdstn: json['sexdstn'],
      height: json['height'],
      weight: json['weight'],
      stepTarget: json['stepTarget'],
      waterTarget: json['waterTarget'],
    );
  }
}
