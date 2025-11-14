class NewsModel {
  int? id;
  String? title;
  String? description;
  String? image;
  String? authorUuid;
  String? createdAt;
  String? updatedAt;

  NewsModel({
    this.id,
    this.title,
    this.description,
    this.image,
    this.authorUuid,
    this.createdAt,
    this.updatedAt,
  });

  static NewsModel fromDB(Map mapObj) {
    return NewsModel(
      id: mapObj['id'],
      title: mapObj['title'],
      description: mapObj['description'],
      image: mapObj['image'],
      updatedAt: mapObj['updatedAt'],
    );
  }

  static Map<String, dynamic> toDB(Map json) {
    return {
      'id': json['id'],
      'title': json['title'],
      'description': json['description'],
      'image': json['news_image'],
      'updatedAt': json['updated_at']
    };
  }
}
