class ModelReport {
  int? id;
  String? code;
  int? status;
  Null? createdBy;
  String? createdAt;
  Null? updatedBy;
  String? updatedAt;
  List<Detail>? detail;

  ModelReport(
      {this.id,
        this.code,
        this.status,
        this.createdBy,
        this.createdAt,
        this.updatedBy,
        this.updatedAt,
        this.detail});

  ModelReport.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    status = json['status'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
    if (json['detail'] != null) {
      detail = <Detail>[];
      json['detail'].forEach((v) {
        detail!.add(new Detail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['status'] = this.status;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_by'] = this.updatedBy;
    data['updated_at'] = this.updatedAt;
    if (this.detail != null) {
      data['detail'] = this.detail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Detail {
  int? id;
  int? receiptId;
  int? menuId;
  int? qty;
  String? createdAt;
  String? updatedAt;
  Menu? menu;

  Detail(
      {this.id,
        this.receiptId,
        this.menuId,
        this.qty,
        this.createdAt,
        this.updatedAt,
        this.menu});

  Detail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    receiptId = json['receipt_id'];
    menuId = json['menu_id'];
    qty = json['qty'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    menu = json['menu'] != null ? new Menu.fromJson(json['menu']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['receipt_id'] = this.receiptId;
    data['menu_id'] = this.menuId;
    data['qty'] = this.qty;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.menu != null) {
      data['menu'] = this.menu!.toJson();
    }
    return data;
  }
}

class Menu {
  int? id;
  String? name;
  String? desc;
  String? pic;
  int? price;
  Null? createdBy;
  String? createdAt;
  Null? updatedBy;
  String? updatedAt;

  Menu(
      {this.id,
        this.name,
        this.desc,
        this.pic,
        this.price,
        this.createdBy,
        this.createdAt,
        this.updatedBy,
        this.updatedAt});

  Menu.fromJson(Map<String, dynamic> json) {
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
