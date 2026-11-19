import 'package:think_flash/model/flashcard.dart';
import 'package:think_flash/model/evaluation_history.dart';

class FlashcardGroup {
  static int _id = 0;

  int id;
  String name;
  List<Flashcard> flashcards = [];

  List<EvalHistory> evaluationHistories = [];

  FlashcardGroup({required this.name, this.flashcards = const []}) : id = _id++;

  int get totalFlashcard => flashcards.length;

  void addFlashcard({required String question, required String answer}){
    Flashcard newFlashcard = Flashcard(question: question, answer: answer);
    flashcards.add(newFlashcard);
  }
}
