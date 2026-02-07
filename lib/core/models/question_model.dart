class QuestionModel {
  final int id;
  final String text;

  QuestionModel({
    required this.id,
    required this.text,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as int,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }

  @override
  String toString() => 'QuestionModel(id: $id, text: $text)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuestionModel && other.id == id && other.text == text;
  }

  @override
  int get hashCode => id.hashCode ^ text.hashCode;
}
