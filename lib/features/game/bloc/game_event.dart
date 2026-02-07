import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuestionsEvent extends GameEvent {
  final String categoryId;
  final String languageCode;

  const LoadQuestionsEvent({
    required this.categoryId,
    this.languageCode = 'en',
  });

  @override
  List<Object?> get props => [categoryId, languageCode];
}

class NextQuestionEvent extends GameEvent {
  const NextQuestionEvent();
}

class PreviousQuestionEvent extends GameEvent {
  const PreviousQuestionEvent();
}

class ShuffleQuestionsEvent extends GameEvent {
  const ShuffleQuestionsEvent();
}

class JumpToQuestionEvent extends GameEvent {
  final int index;

  const JumpToQuestionEvent(this.index);

  @override
  List<Object?> get props => [index];
}
