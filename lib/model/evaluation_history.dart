class EvaluationHistory {
  final int id;
  final int flashcardGroupId;
  final int flashcardId;
  final bool isCorrect; 

  EvaluationHistory({
    required this.id,
    required this.flashcardGroupId,
    required this.flashcardId,
    required this.isCorrect,
  });
}