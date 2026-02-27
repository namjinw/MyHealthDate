class profile_taget_Request {
  final String token;
  final String mberNm;
  final String sexdstn;
  final double height;
  final double weight;
  final String brthdy;
  final int stepTarget;
  final int waterTarget;

  profile_taget_Request({
    required this.token,
    required this.mberNm,
    required this.sexdstn,
    required this.height,
    required this.weight,
    required this.brthdy,
    required this.stepTarget,
    required this.waterTarget,
  });
}
