class Project {
  final String id;
  final String name;
  final String? description;
  final String organizationId;

  const Project({
    required this.id,
    required this.name,
    this.description,
    required this.organizationId,
  });
}
