class DatasourceModel {
  final String? createdAt;
  final String? updatedAt;
  final String? createdBy;
  final String? updatedBy;
  final String? id;
  final String? name;
  final bool? status;
  final String? userId;
  final String? knowledgeId;

  DatasourceModel({
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.id,
    this.name,
    this.status,
    this.userId,
    this.knowledgeId,
  });

  DatasourceModel.fromJson(Map<String, dynamic> json)
      : createdAt = json['createdAt'],
        updatedAt = json['updatedAt'],
        createdBy = json['createdBy'],
        updatedBy = json['updatedBy'],
        id = json['id'],
        name = json['name'],
        status = json['status'],
        userId = json['userId'],
        knowledgeId = json['knowledgeId'];
}
