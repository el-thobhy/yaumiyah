class Item {
  final int? id;
  final String item_name;
  final String description;
  final String status;
  final bool is_deleted;
  final String inserted_at;
  final String? updated_at;

  Item(
      {this.id,
      required this.status,
      required this.item_name,
      required this.description,
      required this.is_deleted,
      required this.inserted_at,
      this.updated_at});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "item_name": item_name,
      "description": description,
      "status": status,
      "is_deleted": is_deleted ? 1 : 0,
      "inserted_at": inserted_at,
      "updated_at": updated_at,
    };
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        id: json["id"],
        item_name: json["item_name"],
        description: json["description"],
        status: json["status"],
        is_deleted: json["is_deleted"] as int == 0,
        inserted_at: json["inserted_at"],
        updated_at: json["updated_at"]);
  }
}
