class PostalCodeResponse {
  final List<PostalCodeData> data;

  PostalCodeResponse({required this.data});

  factory PostalCodeResponse.fromJson(List<dynamic> json) {
    final data = json.map((item) => PostalCodeData.fromJson(item)).toList();
    return PostalCodeResponse(data: data);
  }
}

class PostalCodeData {
  final String postOfficeName;
  final String pincode;

  PostalCodeData({required this.postOfficeName, required this.pincode});

  factory PostalCodeData.fromJson(Map<String, dynamic> json) {
    return PostalCodeData(
      postOfficeName: json['PostOfficeName'],
      pincode: json['Pincode'],
    );
  }
}
