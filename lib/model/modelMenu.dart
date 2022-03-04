class ModelMenu {
  int? id;
  String? name;
  String? desc;
  String? pic;
  int? price;
  Null? createdBy;
  String? createdAt;
  Null? updatedBy;
  String? updatedAt;

  ModelMenu(
      {this.id,
        this.name,
        this.desc,
        this.pic,
        this.price,
        this.createdBy,
        this.createdAt,
        this.updatedBy,
        this.updatedAt});

  ModelMenu.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    desc = json['desc'];
    pic = json['pic'];
    price = json['price'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['desc'] = this.desc;
    data['pic'] = this.pic;
    data['price'] = this.price;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_by'] = this.updatedBy;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
