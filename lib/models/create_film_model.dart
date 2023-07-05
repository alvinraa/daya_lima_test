class CreateFilmModel {
  String? status;
  String? data;
  dynamic info;

  CreateFilmModel({
    this.status,
    this.data,
    this.info,
  });

  factory CreateFilmModel.fromJson(Map<String, dynamic> json) =>
      CreateFilmModel(
        status: json["status"],
        data: json["data"],
        info: json["info"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data,
        "info": info,
      };
}
