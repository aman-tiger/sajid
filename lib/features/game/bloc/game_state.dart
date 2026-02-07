import 'package:equatable/equatable.dart';
import '../../../core/models/question_model.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {
  const GameInitial();
}

class GameLoading extends GameState {
  const GameLoading();
}

class GameLoaded extends GameState {
  final List<QuestionModel> questions;
  final int currentIndex;
  final String categoryId;

  const GameLoaded({
    required this.questions,
    required this.currentIndex,
    required this.categoryId,
  });

  QuestionModel get currentQuestion => questions[currentIndex];
  int get totalQuestions => questions.length;
  bool get hasNext => currentIndex < questions.length - 1;
  bool get hasPrevious => currentIndex > 0;

  GameLoaded copyWith({
    List<QuestionModel>? questions,
    int? currentIndex,
    String? categoryId,
  }) {
    return GameLoaded(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  List<Object?> get props => [questions, currentIndex, categoryId];
}

class GameError extends GameState {
  final GameErrorType type;
  final String? details;

  const GameError(this.type, {this.details});

  @override
  List<Object?> get props => [type, details];
}

enum GameErrorType {
  noQuestions,
  loadFailed,
}
