class Movie {
  String? name;
  String? genre;
  dynamic year;
  String? imageUrl;

  Movie({this.name, this.genre, this.year, this.imageUrl});

  Movie.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    genre = json['genre'];
    year = json['year'];
    imageUrl = json['imageUrl'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['genre'] = genre;
    data['year'] = year;
    data['imageUrl'] = imageUrl;

    return data;
  }
}