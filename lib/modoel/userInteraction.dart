class SignResponse {
  final bool success;
  final String tkn;
  final String mberId;
  final String mberNm;

  SignResponse({
    required this.success,
    required this.tkn,
    required this.mberId,
    required this.mberNm,
  });

  factory SignResponse.fromJson(Map<String, dynamic> json) {
    return SignResponse(
      success: json['success'],
      tkn: json['tkn'],
      mberId: json['mberId'],
      mberNm: json['mberNm'],
    );
  }
}