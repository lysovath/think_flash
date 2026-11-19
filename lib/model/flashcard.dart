

class Flashcard {

  static int _id = 0;
  
  int id;
  String question;
  String answer;

  Flashcard({required this.question, required this.answer}) : id = _id++;

}