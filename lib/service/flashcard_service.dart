

import 'package:think_flash/model/flashcard.dart';
import 'package:think_flash/model/flashcard_category.dart';
import 'package:think_flash/model/flashcard_group.dart';
import 'package:think_flash/model/flashcard_group_category.dart';

class FlashcardService {

  final List<FlashcardGroup> flashcardGroups = [];
  final List<FlashcardCategory> categories = [];
  final List<FlashcardGroupCategory> groupCategorys = [];


  void createFlashcardGroup(String groupName){

    if(groupName.trim().isEmpty) {
      throw Exception("Groupname can't be empty");
    }

    FlashcardGroup newFlashcardGroup = FlashcardGroup(name: groupName);
    flashcardGroups.add(newFlashcardGroup);
  }

  void addFlashcardToGroup(int groupId, {required String question, required String answer}){
    FlashcardGroup? flashcardGroup = flashcardGroups.where((group) => group.id == groupId).firstOrNull;

    if(flashcardGroup == null){
      throw Exception("Flashcard Group doesn't exist");
    }

    if(question.trim().isEmpty){
      throw Exception("Question must not be empty");
    }

    if(answer.trim().isEmpty){
      throw Exception("Answer must not be empty");
    }

    flashcardGroup.addFlashcard(question: question, answer: answer);
  }

  void removeFlashcardFromGroup(int groupId, int flashcardId){
    FlashcardGroup? flashcardGroup = flashcardGroups.where((group) => group.id == groupId).firstOrNull;

    if(flashcardGroup == null){
      throw Exception("Flashcard Group doesn't exist");
    }

    Flashcard? flashCard = flashcardGroup.flashcards.where((flashcard) => flashcard.id == flashcardId).firstOrNull;

    if(flashCard == null){
      throw Exception("Flashcard doesn't exist");
    }

    flashcardGroup.flashcards.removeWhere((flashcard) => flashcard.id == flashcardId);
  }

  void createCategory(String name){

    if(name.trim().isEmpty){
      throw Exception("Category name can't be empty");
    }

    FlashcardCategory newCategory = FlashcardCategory(name: name);
    categories.add(newCategory);
  }

  void removeCategory(int categoryId){

    FlashcardCategory? flashcardCategory = categories.where((category) => category.id == categoryId).firstOrNull;

    if(flashcardCategory == null) {
      throw Exception("This Category doesn't exist");
    }

    categories.removeWhere((category) => category.id == categoryId);
  }

  void updateCategory(int categoryId, String newName){

    if(newName.trim().isEmpty){
      throw Exception("Name can't be empty");
    }

    int categoryIdx = categories.indexWhere((category) => category.id == categoryId);
    if(categoryIdx == -1){
      throw Exception("Category doesn't exist");
    }

    categories[categoryIdx].name = newName;
  }

  void assignedCategoryToGroup({required int groupId, required int categoryId}){
    FlashcardGroup? flashcardGroup = flashcardGroups.where((group) => group.id == groupId).firstOrNull;
    if(flashcardGroup == null){
      throw Exception("Flashcard Group doesn't exist");
    }

    FlashcardCategory? flashcardCategory = categories.where((category) => category.id == categoryId).firstOrNull;
    if(flashcardCategory == null){
      throw Exception("Category doesn't exist");
    }
    
    FlashcardGroupCategory? groupCategory = groupCategorys.where((ele) => ele.groupId == groupId && ele.categoryId == categoryId).firstOrNull;
    if(groupCategory != null){
      throw Exception("Category already assigned for this group.");
    }

    FlashcardGroupCategory newGroupCategory = FlashcardGroupCategory(groupId: groupId, categoryId: categoryId);
    groupCategorys.add(newGroupCategory);
  }

  void removeCategoryFromGroup({required int groupId, required int categoryId}){
    FlashcardGroupCategory? groupCategory = groupCategorys.where((ele) => ele.groupId == groupId && ele.categoryId == categoryId).firstOrNull;
    if(groupCategory == null){
      throw Exception("Category has not assigned to this group!");
    }

    groupCategorys.removeWhere((ele) => ele.groupId == groupId && ele.categoryId == categoryId);
  }
}