class CardEvaluation {
  static int _id = 0;

  final int id;
  final int flashcardId;
  final bool isCorrect;

  CardEvaluation({required this.flashcardId, required this.isCorrect})
    : id = _id++;
}
