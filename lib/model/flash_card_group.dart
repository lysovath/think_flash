import 'package:think_flash/model/flash_card.dart';
import 'package:think_flash/model/evaluation_history.dart';

class FlashCardGroup {
  static int _id = 0;

  int id;
  String name;
  Set<FlashCard> flashcards;

  List<EvalHistory> evaluationHistories = [];

  FlashCardGroup({required this.name, required this.flashcards}) : id = _id++;

  int get totalFlashCard => flashcards.length;
}
