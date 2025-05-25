class Job {
  final int id;
  final String position;
  final String company;
  final String description;

  Job({
    required this.id,
    required this.position,
    required this.company,
    required this.description,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json["id"] ?? 0,
      position: json["position"] ?? "No Position",
      company: json["company"] ?? "No Company",
      description: json["description"] ?? "No description available",
    );
  }
}
