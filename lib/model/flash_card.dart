

class FlashCard {

  static int _id = 0;
  
  int id;
  String question;
  String answer;

  FlashCard({required this.question, required this.answer}) : id = _id++;
}