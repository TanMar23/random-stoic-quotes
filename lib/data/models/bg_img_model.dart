class BgImgModel {
  final String id;
  final int width;
  final int height;
  final UrlsModel urls;

  BgImgModel({
    required this.id,
    required this.width,
    required this.height,
    required this.urls,
  });

  factory BgImgModel.fromJson(Map<String, dynamic> json) {
    return BgImgModel(
      height: json['height'],
      id: json['id'],
      width: json['width'],
      urls: UrlsModel(
        full: json['urls']['full'],
        regular: json['urls']['regular'],
        small: json['urls']['small'],
      ),
    );
  }
}

class UrlsModel {
  final String full;
  final String regular;
  final String small;

  UrlsModel({
    required this.full,
    required this.regular,
    required this.small,
  });

  factory UrlsModel.fromJson(Map<String, dynamic> json) {
    return UrlsModel(
      full: json['urls']['full'],
      regular: json['urls']['regular'],
      small: json['urls']['small'],
    );
  }
}
