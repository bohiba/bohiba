import '/services/db_service.dart';
import 'package:hive/hive.dart';

part 'news_model.g.dart';

@HiveType(typeId: newsTypeID)
class NewsModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  String? image;

  @HiveField(4)
  String? authorUuid;

  @HiveField(5)
  String? createdAt;

  @HiveField(6)
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

  static List<NewsModel> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) {
      final map = json as Map<String, dynamic>;
      return NewsModel.fromJson(map);
    }).toList();
  }
}
