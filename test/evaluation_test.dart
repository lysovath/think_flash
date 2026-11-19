import 'package:flutter_test/flutter_test.dart';
import 'package:think_flash/model/flashcard.dart';
import 'package:think_flash/model/flashcard_group.dart';
import 'package:think_flash/service/evaluation_service.dart';

void main() {
  // Start a new evaluation
  test('starts a new evaluation history', () {
    final evaluationService = EvaluationService();

    final flashcardGroup = FlashcardGroup(name: 'Programming');

    final history = evaluationService.startEvaluation(flashcardGroup);

    expect(history.cardEvaluations.length, 0);
    expect(flashcardGroup.evaluationHistories.length, 1);
  });

  // Evaluate a card as correct
  test('records a correct card evaluation', () {
    final evaluationService = EvaluationService();

    final card = Flashcard(
      question: 'What is Flutter?',
      answer: 'A UI toolkit',
    );

    final flashcardGroup = FlashcardGroup(
      name: 'Programming',
      flashcards: [card],
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

    final card = Flashcard(
      question: 'What is Dart?',
      answer: 'A programming language',
    );

    final flashcardGroup = FlashcardGroup(
      name: 'Programming',
      flashcards: [card],
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

    final card1 = Flashcard(question: 'Question 1', answer: 'Answer 1');
    final card2 = Flashcard(question: 'Question 2', answer: 'Answer 2');

    final flashcardGroup = FlashcardGroup(
      name: 'Programming',
      flashcards: [card1, card2],
    );

    final history = evaluationService.startEvaluation(flashcardGroup);

    for (final card in flashcardGroup.flashcards) {
      evaluationService.evaluateCard(
        history: history,
        flashcardId: card.id,
        isCorrect: true,
      );
    }

    expect(evaluationService.calculateScore(history), 100.0);
  });

  // All cards are incorrect
  test('calculates zero percent when all cards are incorrect', () {
    final evaluationService = EvaluationService();

    final card1 = Flashcard(question: 'Question 1', answer: 'Answer 1');
    final card2 = Flashcard(question: 'Question 2', answer: 'Answer 2');

    final flashcardGroup = FlashcardGroup(
      name: 'Programming',
      flashcards: [card1, card2],
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

  // Mixed correct and incorrect results
  test('calculates the correct percentage for mixed results', () {
    final evaluationService = EvaluationService();

    final card1 = Flashcard(question: 'Question 1', answer: 'Answer 1');
    final card2 = Flashcard(question: 'Question 2', answer: 'Answer 2');

    final flashcardGroup = FlashcardGroup(
      name: 'Programming',
      flashcards: [card1, card2],
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

    expect(evaluationService.calculateScore(history), 50.0);
  });

  // No cards evaluated
  test('returns zero when no cards have been evaluated', () {
    final evaluationService = EvaluationService();

    final flashcardGroup = FlashcardGroup(name: 'Programming');

    final history = evaluationService.startEvaluation(flashcardGroup);

    expect(evaluationService.calculateScore(history), 0.0);
  });

  // Retrieve all evaluation histories
  test('retrieves all evaluation histories of a flashcard group', () {
    final evaluationService = EvaluationService();

    final flashcardGroup = FlashcardGroup(name: 'Programming');

    evaluationService.startEvaluation(flashcardGroup);
    evaluationService.startEvaluation(flashcardGroup);

    final histories = evaluationService.getHistory(flashcardGroup);

    expect(histories.length, 2);
  });

  // Keep results separate across evaluation sessions
  test('keeps results separate across evaluation sessions', () {
    final evaluationService = EvaluationService();

    final card1 = Flashcard(question: 'Question 1', answer: 'Answer 1');
    final card2 = Flashcard(question: 'Question 2', answer: 'Answer 2');

    final flashcardGroup = FlashcardGroup(
      name: 'Programming',
      flashcards: [card1, card2],
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

    expect(evaluationService.calculateScore(firstHistory), 100.0);
    expect(evaluationService.calculateScore(secondHistory), 0.0);
  });
}
