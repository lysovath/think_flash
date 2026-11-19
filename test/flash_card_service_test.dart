


import 'package:flutter_test/flutter_test.dart';
import 'package:think_flash/service/flashcard_service.dart';

void main(){
  test("SuccessFully Create a Group",() {
    final flashcardService = FlashcardService();

    flashcardService.createFlashcardGroup("Test");

    expect(flashcardService.flashcardGroups.length, 1);

    expect(flashcardService.flashcardGroups.first.name, "Test");
  });

  test("Successfully create flashcard", () {
    final flashcardService = FlashcardService();

    flashcardService.createFlashcardGroup("Test");
    int groupId = flashcardService.flashcardGroups.first.id;
    flashcardService.addFlashcardToGroup(groupId, question: "Who there?", answer: "Knock Knock"); 
      
    expect(flashcardService.flashcardGroups.first.flashcards.first.question, "Who there?");
    expect(flashcardService.flashcardGroups.first.flashcards.first.answer, "Knock Knock");
  });

  test("Successfully remove flashcard from group", (){
    final flashcardService = FlashcardService();

    flashcardService.createFlashcardGroup("Test");
    int groupId = flashcardService.flashcardGroups.first.id;
    flashcardService.addFlashcardToGroup(groupId, question: "Who there?", answer: "Knock Knock"); 
      
    expect(flashcardService.flashcardGroups.first.flashcards.first.question, "Who there?");
    expect(flashcardService.flashcardGroups.first.flashcards.first.answer, "Knock Knock");

    int flashcardId = flashcardService.flashcardGroups.first.flashcards.first.id;

    flashcardService.removeFlashcardFromGroup(groupId, flashcardId);
    
    expect(flashcardService.flashcardGroups.first.flashcards.length, 0);
  });

  test("Successfully create a category", () {
    final flashcardService = FlashcardService();

    flashcardService.createCategory("Test");

    expect(flashcardService.categories.first.name, "Test");
  });

  test("Successfully assigned a category to a group", () {
    final flashcardService = FlashcardService();

    flashcardService.createFlashcardGroup("Group1");
    flashcardService.createCategory("Category1");

    int groupId = flashcardService.flashcardGroups.first.id;
    int categoryId = flashcardService.categories.first.id;

    flashcardService.assignedCategoryToGroup(groupId: groupId, categoryId: categoryId);

    expect(flashcardService.groupCategorys.first.groupId, groupId);
    expect(flashcardService.groupCategorys.first.categoryId, categoryId);
  });
}