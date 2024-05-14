class WordModel {
  String? id;
  String? english;
  String? vietnam;
  String? topicId;
  bool isFavorite;

  WordModel({
    this.id,
    this.english,
    this.vietnam,
    this.topicId,
    this.isFavorite = false,
  });
}
