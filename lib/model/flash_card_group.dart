
import 'package:think_flash/model/flash_card.dart';

class FlashCardGroup {

  static int _id = 0;

  int id;
  String name;
  Set<FlashCard> flashcards;

  FlashCardGroup({required this.name, required this.flashcards}) : id = _id++;

  int get totalFlashCard => flashcards.length;

}