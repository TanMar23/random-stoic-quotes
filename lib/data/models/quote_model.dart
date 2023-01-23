class QuoteModel {
  final String author;
  final String body;
  final int id;

  QuoteModel({
    required this.author,
    required this.body,
    required this.id,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      author: json['author'],
      body: json['body'],
      id: json['id'],
    );
  }
}
