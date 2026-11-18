
import 'package:flutter_test/flutter_test.dart';
import 'package:think_flash/model/flash_card.dart';
import 'package:think_flash/model/flash_card_group.dart';
import 'package:think_flash/service/evaluation_service.dart';

void main() {
  late EvaluationService evaluationService;
  late FlashCardGroup flashcardGroup;
  late List<FlashCard> cards;

  setUp(() {
    evaluationService = EvaluationService();

    cards = [
      FlashCard(question: 'What is Flutter?', answer: 'A UI toolkit'),
      FlashCard(question: 'What is Dart?', answer: 'A programming language'),
      FlashCard(question: 'What is a widget?', answer: 'A UI building block'),
    ];

    flashcardGroup = FlashCardGroup(
      name: 'Programming',
      flashcards: cards.toSet(),
    );
  });

  group('EvaluationService Tests', () {

    // Start a new evaluation
    test('should create a new evaluation history', () {
      final history =
          evaluationService.startEvaluation(flashcardGroup);

      expect(history.cardEvaluations, isEmpty);
      expect(
        flashcardGroup.evaluationHistories,
        contains(history),
      );
    });

    // Evaluate a card as correct
    test('should record a correct card evaluation', () {
      final history =
          evaluationService.startEvaluation(flashcardGroup);

      evaluationService.evaluateCard(
        history: history,
        flashcardId: cards[0].id,
        isCorrect: true,
      );

      expect(history.cardEvaluations.length, 1);
      expect(history.cardEvaluations.first.isCorrect, true);
    });

    // Evaluate a card as incorrect
    test('should record an incorrect card evaluation', () {
      final history =
          evaluationService.startEvaluation(flashcardGroup);

      evaluationService.evaluateCard(
        history: history,
        flashcardId: cards[0].id,
        isCorrect: false,
      );

      expect(history.cardEvaluations.length, 1);
      expect(history.cardEvaluations.first.isCorrect, false);
    });

    // All cards answered correctly
    test('should calculate 100 percent when all cards are correct', () {
      final history =
          evaluationService.startEvaluation(flashcardGroup);

      for (final card in cards) {
        evaluationService.evaluateCard(
          history: history,
          flashcardId: card.id,
          isCorrect: true,
        );
      }

      expect(evaluationService.calculateScore(history), 100);
    });

    // All cards answered incorrectly
    test('should calculate zero percent when all cards are incorrect', () {
      final history =
          evaluationService.startEvaluation(flashcardGroup);

      for (final card in cards) {
        evaluationService.evaluateCard(
          history: history,
          flashcardId: card.id,
          isCorrect: false,
        );
      }

      expect(evaluationService.calculateScore(history), 0);
    });

    // Some correct and some incorrect
    test('should calculate the correct percentage for mixed results', () {
      final history =
          evaluationService.startEvaluation(flashcardGroup);

      evaluationService.evaluateCard(
        history: history,
        flashcardId: cards[0].id,
        isCorrect: true,
      );

      evaluationService.evaluateCard(
        history: history,
        flashcardId: cards[1].id,
        isCorrect: false,
      );

      evaluationService.evaluateCard(
        history: history,
        flashcardId: cards[2].id,
        isCorrect: true,
      );

      expect(evaluationService.calculateScore(history), closeTo(66.67, 0.01));
    });

    // No cards evaluated
    test('should return zero when no cards have been evaluated', () {
      final history =
          evaluationService.startEvaluation(flashcardGroup);

      expect(evaluationService.calculateScore(history), 0);
    });

    // Retrieve evaluation history
    test('should retrieve all evaluation histories for a group', () {
      evaluationService.startEvaluation(flashcardGroup);
      evaluationService.startEvaluation(flashcardGroup);

      final histories =
          evaluationService.getHistory(flashcardGroup);

      expect(histories.length, 2);
    });

    // Retrieve history with an invalid ID
    test('should return null when history ID does not exist', () {
      final result =
          evaluationService.getHistoryById(flashcardGroup, -1);

      expect(result, isNull);
    });

    // Multiple evaluation sessions
    test('should keep results separate across evaluation sessions', () {
      final firstHistory =
          evaluationService.startEvaluation(flashcardGroup);

      evaluationService.evaluateCard(
        history: firstHistory,
        flashcardId: cards[0].id,
        isCorrect: true,
      );

      final secondHistory =
          evaluationService.startEvaluation(flashcardGroup);

      evaluationService.evaluateCard(
        history: secondHistory,
        flashcardId: cards[1].id,
        isCorrect: false,
      );

      expect(firstHistory.cardEvaluations.length, 1);
      expect(secondHistory.cardEvaluations.length, 1);

      expect(evaluationService.calculateScore(firstHistory), 100);
      expect(evaluationService.calculateScore(secondHistory), 0);
    });
  });
}
