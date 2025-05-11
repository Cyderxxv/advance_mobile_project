class FileModel {
  final String? id;
  final String? createdAt;
  final String? updatedAt;
  final String? name;
  final String? extension;
  final String? mimeType;
  final int? size;
  final String? owner;
  final String? url;

  FileModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.extension,
    this.mimeType,
    this.size,
    this.owner,
    this.url,
  });

  FileModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'],
        name = json['name'],
        extension = json['extension'],
        mimeType = json['mime_type'],
        size = json['size'] is int ? json['size'] : int.tryParse(json['size'].toString()),
        owner = json['owner'],
        url = json['url'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'name': name,
      'extension': extension,
      'mime_type': mimeType,
      'size': size,
      'owner': owner,
      'url': url,
    };
  }
}
