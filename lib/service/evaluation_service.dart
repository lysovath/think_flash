import 'package:think_flash/model/flash_card_group.dart';
import 'package:think_flash/model/evaluation_history.dart';
import 'package:think_flash/model/card_evaluation.dart';

class EvaluationService {
  // Start a new evaluation session
  EvalHistory startEvaluation(FlashCardGroup group) {
    final history = EvalHistory(cardEvaluations: []);

    group.evaluationHistories.add(history);

    return history;
  }

  // Evaluate an individual flashcard
  void evaluateCard({
    required EvalHistory history,
    required int flashcardId,
    required bool isCorrect,
  }) {
    final evaluation = CardEvaluation(
      flashcardId: flashcardId,
      isCorrect: isCorrect,
    );

    history.cardEvaluations.add(evaluation);
  }

  // Calculate the score of an evaluation session
  double calculateScore(EvalHistory history) {
    if (history.cardEvaluations.isEmpty) {
      return 0;
    }

    final correctCount = history.cardEvaluations
        .where((evaluation) => evaluation.isCorrect)
        .length;

    return (correctCount / history.cardEvaluations.length) * 100;
  }

  // Get total correct answers
  int getCorrectCount(EvalHistory history) {
    return history.cardEvaluations
        .where((evaluation) => evaluation.isCorrect)
        .length;
  }

  // Get total incorrect answers
  int getIncorrectCount(EvalHistory history) {
    return history.cardEvaluations
        .where((evaluation) => !evaluation.isCorrect)
        .length;
  }

  // Get all evaluation histories of a group
  List<EvalHistory> getHistory(FlashCardGroup group) {
    return group.evaluationHistories;
  }

  // Get evaluation history by ID
  EvalHistory? getHistoryById(FlashCardGroup group, int historyId) {
    for (final history in group.evaluationHistories) {
      if (history.id == historyId) {
        return history;
      }
    }

    return null;
  }
}
