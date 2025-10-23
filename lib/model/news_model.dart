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

  factory NewsModel.fromJson(Map<dynamic, dynamic> json) => NewsModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        image: json['news_image'] == null
            ? null
            : 'https://bohiba.com/storage/images/news/${json['news_image']}',
        authorUuid: json['author_uuid'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  Map<dynamic, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'news_image': image,
        'author_uuid': authorUuid,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  static List<Map<String, dynamic>> mapJsonNewsToDbList(
      List<dynamic> jsonNews) {
    return jsonNews.map((json) {
      Map<String, dynamic> news = json as Map<String, dynamic>;
      return {
        'id': news['id'],
        'title': news['title'],
        'description': news['description'],
        'image': news['image'],
        'updatedAt': news['updated_at']
      };
    }).toList();
  }

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
      'image': json['image'],
      'updatedAt': json['updated_at']
    };
  }
}
