import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/categories.dart';
import '../../../../core/data/repositories/question_repository.dart';
import '../../../../core/models/category_model.dart';
import '../../../../core/services/share_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../settings/bloc/settings_bloc.dart';
import '../../../settings/bloc/settings_state.dart';
import '../../bloc/game_bloc.dart';
import '../../bloc/game_event.dart';
import '../../bloc/game_state.dart';
import '../widgets/question_card.dart';
import '../widgets/game_controls.dart';

class GamePage extends StatelessWidget {
  final String categoryId;

  const GamePage({
    super.key,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    final languageCode = context.select<SettingsBloc, String>((bloc) {
      final state = bloc.state;
      return state is SettingsLoaded ? state.language : 'en';
    });
    return BlocProvider(
      create: (context) => GameBloc(
        questionRepository: QuestionRepository(),
      )..add(LoadQuestionsEvent(
          categoryId: categoryId,
          languageCode: languageCode,
        )),
      child: _GamePageContent(categoryId: categoryId),
    );
  }
}

class _GamePageContent extends StatefulWidget {
  final String categoryId;

  const _GamePageContent({required this.categoryId});

  @override
  State<_GamePageContent> createState() => _GamePageContentState();
}

class _GamePageContentState extends State<_GamePageContent> {
  int? _lastIndex;
  bool _isForward = true;

  @override
  Widget build(BuildContext context) {
    final category = AppCategories.getById(widget.categoryId);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context, category),
        body: BlocConsumer<GameBloc, GameState>(
          listener: (context, state) {
            if (state is GameLoaded) {
              if (_lastIndex != null) {
                _isForward = state.currentIndex >= _lastIndex!;
              }
              _lastIndex = state.currentIndex;
            }
          },
          builder: (context, state) {
            if (state is GameLoading) {
              return _buildLoading(context, category.color);
            } else if (state is GameLoaded) {
              return _buildGameContent(context, state, category, _isForward);
            } else if (state is GameError) {
              final message = _getErrorMessage(context, state);
              return _buildError(context, message);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, CategoryModel category) {
    final t = AppLocalizations.of(context)!;
    final categoryName = AppCategories.localizedName(t, category.id);
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: AppColors.textLight,
          size: 20.sp,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          if (state is GameLoaded) {
            return Column(
              children: [
                Text(
                  categoryName,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                ),
                Text(
                  '${state.currentIndex + 1}/${state.totalQuestions}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textGreyLight,
                  ),
                ),
              ],
            );
          }
          return Text(
            categoryName,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          );
        },
      ),
      centerTitle: true,
    );
  }

  Widget _buildLoading(BuildContext context, Color categoryColor) {
    final t = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(categoryColor),
          ),
          SizedBox(height: 24.h),
          Text(
            t.game_loading,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textGreyLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameContent(
    BuildContext context,
    GameLoaded state,
    CategoryModel category,
    bool isForward,
  ) {
    return Column(
      children: [
        // Question card
        Expanded(
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                final beginOffset = isForward ? const Offset(1, 0) : const Offset(-1, 0);
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: beginOffset,
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: QuestionCard(
                key: ValueKey(state.currentQuestion.id),
                question: state.currentQuestion,
                categoryColor: category.color,
                onSwipeLeft: state.hasPrevious
                    ? () => context.read<GameBloc>().add(const PreviousQuestionEvent())
                    : null,
                onSwipeRight: state.hasNext
                    ? () => context.read<GameBloc>().add(const NextQuestionEvent())
                    : null,
              ),
            ),
          ),
        ),

        // Game controls
        SafeArea(
          child: GameControls(
            hasPrevious: state.hasPrevious,
            hasNext: state.hasNext,
            onPrevious: state.hasPrevious
                ? () => context.read<GameBloc>().add(const PreviousQuestionEvent())
                : null,
            onNext: state.hasNext
                ? () => context.read<GameBloc>().add(const NextQuestionEvent())
                : null,
            onShuffle: () => context.read<GameBloc>().add(const ShuffleQuestionsEvent()),
            onShare: () => _shareQuestion(context, state.currentQuestion.text),
          ),
        ),
      ],
    );
  }

  String _getErrorMessage(BuildContext context, GameError error) {
    final t = AppLocalizations.of(context)!;
    switch (error.type) {
      case GameErrorType.noQuestions:
        return t.game_error_no_questions;
      case GameErrorType.loadFailed:
        if (error.details != null && error.details!.isNotEmpty) {
          return t.error_loading_questions(error.details!);
        }
        return t.game_error_failed_load;
    }
  }

  Widget _buildError(BuildContext context, String message) {
    final t = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: AppColors.error,
            ),
            SizedBox(height: 24.h),
            Text(
              t.game_error_title,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textGreyLight,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Text(
                t.button_back,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareQuestion(BuildContext context, String questionText) async {
    final t = AppLocalizations.of(context)!;
    final shared = await ShareService.shareText(
      context,
      t.game_share_text(questionText),
      subject: t.main_menu_title,
    );

    if (!context.mounted || shared) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          t.common_error,
          style: TextStyle(color: AppColors.textLight, fontSize: 14.sp),
        ),
        backgroundColor: AppColors.error,
      ),
    );
  }
}
