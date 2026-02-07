import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/data/repositories/question_repository.dart';
import 'game_event.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final QuestionRepository questionRepository;

  GameBloc({required this.questionRepository}) : super(const GameInitial()) {
    on<LoadQuestionsEvent>(_onLoadQuestions);
    on<NextQuestionEvent>(_onNextQuestion);
    on<PreviousQuestionEvent>(_onPreviousQuestion);
    on<ShuffleQuestionsEvent>(_onShuffleQuestions);
    on<JumpToQuestionEvent>(_onJumpToQuestion);
  }

  Future<void> _onLoadQuestions(
    LoadQuestionsEvent event,
    Emitter<GameState> emit,
  ) async {
    try {
      emit(const GameLoading());

      // Load questions from repository
      final questions = await questionRepository.loadQuestions(
        event.categoryId,
        event.languageCode,
      );

      if (questions.isEmpty) {
        emit(const GameError(GameErrorType.noQuestions));
        return;
      }

      // Shuffle questions for randomization
      final shuffledQuestions = questionRepository.shuffleQuestions(questions);

      emit(GameLoaded(
        questions: shuffledQuestions,
        currentIndex: 0,
        categoryId: event.categoryId,
      ));
    } catch (e) {
      emit(GameError(GameErrorType.loadFailed, details: e.toString()));
    }
  }

  void _onNextQuestion(
    NextQuestionEvent event,
    Emitter<GameState> emit,
  ) {
    if (state is GameLoaded) {
      final currentState = state as GameLoaded;
      if (currentState.hasNext) {
        emit(currentState.copyWith(
          currentIndex: currentState.currentIndex + 1,
        ));
      }
    }
  }

  void _onPreviousQuestion(
    PreviousQuestionEvent event,
    Emitter<GameState> emit,
  ) {
    if (state is GameLoaded) {
      final currentState = state as GameLoaded;
      if (currentState.hasPrevious) {
        emit(currentState.copyWith(
          currentIndex: currentState.currentIndex - 1,
        ));
      }
    }
  }

  void _onShuffleQuestions(
    ShuffleQuestionsEvent event,
    Emitter<GameState> emit,
  ) {
    if (state is GameLoaded) {
      final currentState = state as GameLoaded;
      final shuffledQuestions = questionRepository.shuffleQuestions(
        currentState.questions,
      );
      emit(currentState.copyWith(
        questions: shuffledQuestions,
        currentIndex: 0,
      ));
    }
  }

  void _onJumpToQuestion(
    JumpToQuestionEvent event,
    Emitter<GameState> emit,
  ) {
    if (state is GameLoaded) {
      final currentState = state as GameLoaded;
      if (event.index >= 0 && event.index < currentState.questions.length) {
        emit(currentState.copyWith(currentIndex: event.index));
      }
    }
  }
}
