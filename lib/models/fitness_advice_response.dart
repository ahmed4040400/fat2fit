class FitnessAdviceResponse {
  final String response;

  FitnessAdviceResponse({required this.response});

  factory FitnessAdviceResponse.fromJson(Map<String, dynamic> json) {
    return FitnessAdviceResponse(
      response: json['response'] ?? '',
    );
  }

  String get advice => response;
}
