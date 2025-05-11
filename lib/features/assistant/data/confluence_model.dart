class ConfluenceModel {
  final String? id;
  final String? name;
  final String? type;
  final int? size;
  final bool? status;
  final String? userId;
  final Map<String, dynamic>? metadata;
  final String? knowledgeId;
  final String? createdBy;
  final String? updatedBy;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  ConfluenceModel({
    this.id,
    this.name,
    this.type,
    this.size,
    this.status,
    this.userId,
    this.metadata,
    this.knowledgeId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  ConfluenceModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        type = json['type'],
        size = json['size'],
        status = json['status'],
        userId = json['userId'],
        metadata = json['metadata'],
        knowledgeId = json['knowledgeId'],
        createdBy = json['createdBy'],
        updatedBy = json['updatedBy'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'],
        deletedAt = json['deletedAt'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'size': size,
      'status': status,
      'userId': userId,
      'metadata': metadata,
      'knowledgeId': knowledgeId,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }
}
