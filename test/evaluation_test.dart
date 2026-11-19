import 'package:flutter_test/flutter_test.dart';
import 'package:think_flash/model/flash_card.dart';
import 'package:think_flash/model/flash_card_group.dart';
import 'package:think_flash/service/evaluation_service.dart';

void main() {
  // Start a new evaluation
  test('starts a new evaluation history', () {
    final evaluationService = EvaluationService();

    final cards = {
      FlashCard(question: 'What is Flutter?', answer: 'A UI toolkit'),
      FlashCard(question: 'What is Dart?', answer: 'A programming language'),
    };

    final flashcardGroup = FlashCardGroup(
      name: 'Programming',
      flashcards: cards,
    );

    final history = evaluationService.startEvaluation(flashcardGroup);

    expect(history.cardEvaluations.length, 0);
    expect(flashcardGroup.evaluationHistories.length, 1);
  });

  // Evaluate a card as correct
  test('records a correct card evaluation', () {
    final evaluationService = EvaluationService();

    final card = FlashCard(
      question: 'What is Flutter?',
      answer: 'A UI toolkit',
    );

    final flashcardGroup = FlashCardGroup(
      name: 'Programming',
      flashcards: {card},
    );

    final history = evaluationService.startEvaluation(flashcardGroup);

    evaluationService.evaluateCard(
      history: history,
      flashcardId: card.id,
      isCorrect: true,
    );

    expect(history.cardEvaluations.length, 1);
    expect(history.cardEvaluations.first.isCorrect, true);
  });

  // Evaluate a card as incorrect
  test('records an incorrect card evaluation', () {
    final evaluationService = EvaluationService();

    final card = FlashCard(
      question: 'What is Dart?',
      answer: 'A programming language',
    );

    final flashcardGroup = FlashCardGroup(
      name: 'Programming',
      flashcards: {card},
    );

    final history = evaluationService.startEvaluation(flashcardGroup);

    evaluationService.evaluateCard(
      history: history,
      flashcardId: card.id,
      isCorrect: false,
    );

    expect(history.cardEvaluations.length, 1);
    expect(history.cardEvaluations.first.isCorrect, false);
  });

  // All cards are correct
  test('calculates 100 percent when all cards are correct', () {
    final evaluationService = EvaluationService();

    final card1 = FlashCard(question: 'Question 1', answer: 'Answer 1');
    final card2 = FlashCard(question: 'Question 2', answer: 'Answer 2');

    final flashcardGroup = FlashCardGroup(
      name: 'Programming',
      flashcards: {card1, card2},
    );

    final history = evaluationService.startEvaluation(flashcardGroup);

    for (final card in flashcardGroup.flashcards) {
      evaluationService.evaluateCard(
        history: history,
        flashcardId: card.id,
        isCorrect: true,
      );
    }

    expect(evaluationService.calculateScore(history), 100.00);
  });

  // All cards are incorrect
  test('calculates zero percent when all cards are incorrect', () {
    final evaluationService = EvaluationService();

    final card1 = FlashCard(question: 'Question 1', answer: 'Answer 1');
    final card2 = FlashCard(question: 'Question 2', answer: 'Answer 2');

    final flashcardGroup = FlashCardGroup(
      name: 'Programming',
      flashcards: {card1, card2},
    );

    final history = evaluationService.startEvaluation(flashcardGroup);

    for (final card in flashcardGroup.flashcards) {
      evaluationService.evaluateCard(
        history: history,
        flashcardId: card.id,
        isCorrect: false,
      );
    }

    expect(evaluationService.calculateScore(history), 0.0);
  });

  // Some cards are correct and others are incorrect
  test('calculates the correct percentage for mixed results', () {
    final evaluationService = EvaluationService();

    final card1 = FlashCard(question: 'Question 1', answer: 'Answer 1');
    final card2 = FlashCard(question: 'Question 2', answer: 'Answer 2');

    final flashcardGroup = FlashCardGroup(
      name: 'Programming',
      flashcards: {card1, card2},
    );

    final history = evaluationService.startEvaluation(flashcardGroup);

    evaluationService.evaluateCard(
      history: history,
      flashcardId: card1.id,
      isCorrect: true,
    );

    evaluationService.evaluateCard(
      history: history,
      flashcardId: card2.id,
      isCorrect: false,
    );

    expect(evaluationService.calculateScore(history), 50.00);
  });

  // No cards have been evaluated
  test('returns zero when no cards have been evaluated', () {
    final evaluationService = EvaluationService();

    final flashcardGroup = FlashCardGroup(name: 'Programming', flashcards: {});

    final history = evaluationService.startEvaluation(flashcardGroup);

    expect(evaluationService.calculateScore(history), 0);
  });

  // Retrieve evaluation histories
  test('retrieves all evaluation histories of a flashcard group', () {
    final evaluationService = EvaluationService();

    final flashcardGroup = FlashCardGroup(name: 'Programming', flashcards: {});

    evaluationService.startEvaluation(flashcardGroup);
    evaluationService.startEvaluation(flashcardGroup);

    final histories = evaluationService.getHistory(flashcardGroup);

    expect(histories.length, 2);
  });

  // Multiple evaluation sessions keep results separate
  test('keeps results separate across evaluation sessions', () {
    final evaluationService = EvaluationService();

    final card1 = FlashCard(question: 'Question 1', answer: 'Answer 1');
    final card2 = FlashCard(question: 'Question 2', answer: 'Answer 2');

    final flashcardGroup = FlashCardGroup(
      name: 'Programming',
      flashcards: {card1, card2},
    );

    final firstHistory = evaluationService.startEvaluation(flashcardGroup);

    evaluationService.evaluateCard(
      history: firstHistory,
      flashcardId: card1.id,
      isCorrect: true,
    );

    final secondHistory = evaluationService.startEvaluation(flashcardGroup);

    evaluationService.evaluateCard(
      history: secondHistory,
      flashcardId: card2.id,
      isCorrect: false,
    );

    expect(firstHistory.cardEvaluations.length, 1);
    expect(secondHistory.cardEvaluations.length, 1);

    expect(evaluationService.calculateScore(firstHistory), 100);
    expect(evaluationService.calculateScore(secondHistory), 0);
  });
}
