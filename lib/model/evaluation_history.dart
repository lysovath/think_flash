import 'package:think_flash/model/card_evaluation.dart';

class EvalHistory {
  static int _id = 0;

  final int id;
  final DateTime evaluatedAt;
  final List<CardEvaluation> cardEvaluations;

  EvalHistory({required this.cardEvaluations, required this.evaluatedAt})
    : id = _id++;

  int get totalEvaluated => cardEvaluations.length;

  int get correctCount => cardEvaluations.where((e) => e.isCorrect).length;

  int get incorrectCount => cardEvaluations.where((e) => !e.isCorrect).length;

  double get averageScore {
    if (cardEvaluations.isEmpty) return 0;
    return (correctCount / totalEvaluated) * 100;
  }
}
