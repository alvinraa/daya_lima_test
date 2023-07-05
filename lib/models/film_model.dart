class FilmModel {
  String? status;
  List<Datum>? data;
  dynamic info;

  FilmModel({
    this.status,
    this.data,
    this.info,
  });

  factory FilmModel.fromJson(Map<String, dynamic> json) => FilmModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        info: json["info"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "info": info,
      };
}

class Datum {
  int? id;
  String? title;
  String? description;
  String? poster;
  DateTime? createdDate;

  Datum({
    this.id,
    this.title,
    this.description,
    this.poster,
    this.createdDate,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        poster: json["poster"],
        createdDate: DateTime.parse(json["created_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "poster": poster,
        "created_date": createdDate!.toIso8601String(),
      };
}
