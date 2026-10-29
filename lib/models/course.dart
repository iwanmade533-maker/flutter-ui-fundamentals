
class Course {
  final int? id;
  final String code;
  final String title;
  final int credits;
  final String status;

  const Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    this.status = 'planned',
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse('${json['id']}'),
      code: json['code']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      credits: json['credits'] is int
          ? json['credits'] as int
          : int.tryParse('${json['credits']}') ?? 0,
      status: json['status']?.toString() ?? 'planned',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'title': title,
      'credits': credits,
      'status': status,
    };
  }
}
