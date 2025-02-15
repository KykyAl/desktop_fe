class DataModel {
  String? noNfc;

  DataModel({this.noNfc});

  DataModel.fromJson(dynamic json) {
    noNfc = json["no_nfc"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["no_nfc"] = noNfc;
    return data;
  }
}
