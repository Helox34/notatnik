import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/data_provider.dart';
import '../models/project.dart';
import '../models/list_model.dart';
import '../models/note.dart';
import '../models/diary_entry.dart';
import '../theme/app_colors.dart';

class SampleDataGenerator {
  static Future<void> generate(BuildContext context) async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    const uuid = Uuid();

    // 1. PROJECT: Remont Mieszkania
    final projectId1 = uuid.v4();
    final project1 = Project(
      id: projectId1,
      title: 'Remont mieszkania',
      description: 'Plany i kosztorys generalnego remontu salonu i kuchni.',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now(),
      // progress is a getter based on tasks, so we don't set it directly.
      // We set colorValue instead of color.
      colorValue: AppColors.projectsBg.value,
    );
    await dataProvider.addProject(project1);

    // Lists for Project 1
    final listId1 = uuid.v4();
    final list1 = ListModel(
      id: listId1,
      projectId: projectId1,
      title: 'Lista zakupów budowlanych',
      items: [
        ChecklistItem(id: uuid.v4(), text: 'Farba biała 10L', isCompleted: true),
        ChecklistItem(id: uuid.v4(), text: 'Wałki i pędzle', isCompleted: true),
        ChecklistItem(id: uuid.v4(), text: 'Folia malarska', isCompleted: false),
        ChecklistItem(id: uuid.v4(), text: 'Listwy przypodłogowe', isCompleted: false),
        ChecklistItem(id: uuid.v4(), text: 'Klej montażowy', isCompleted: false),
      ],
      createdAt: DateTime.now(),
      // ListModel doesn't have a color field in constructor based on file, 
      // it seems determined by UI or not stored. Verified: No color field.
    );
    await dataProvider.addList(list1);

    // Notes for Project 1
    final noteId1 = uuid.v4();
    final note1 = Note(
      id: noteId1,
      projectId: projectId1,
      title: 'Wymiary kuchni',
      content: 'Ściana okienna: 340 cm\nŚciana boczna (przy wejściu): 280 cm\nWysokość: 265 cm\n\nUwaga: Gniazdko przy podłodze jest 40cm od rogu.',
      createdAt: DateTime.now(),
      // Note doesn't have color field.
    );
    await dataProvider.addNote(note1);

    // 2. INDEPENDENT LIST: Zakupy spożywcze
    final listId2 = uuid.v4();
    final list2 = ListModel(
      id: listId2,
      projectId: null,
      title: 'Zakupy na weekend',
      items: [
        ChecklistItem(id: uuid.v4(), text: 'Mleko (2L)', isCompleted: false),
        ChecklistItem(id: uuid.v4(), text: 'Jajka (10szt)', isCompleted: true),
        ChecklistItem(id: uuid.v4(), text: 'Chleb pełnoziarnisty', isCompleted: false),
        ChecklistItem(id: uuid.v4(), text: 'Awokado', isCompleted: false),
        ChecklistItem(id: uuid.v4(), text: 'Pomidory', isCompleted: false),
      ],
      createdAt: DateTime.now(),
    );
    await dataProvider.addList(list2);

     // 3. INDEPENDENT NOTE: Pomysły
    final noteId2 = uuid.v4();
    final note2 = Note(
      id: noteId2,
      projectId: null,
      title: 'Pomysły na prezent',
      content: '- Zestaw LEGO dla Tomka\n- Voucher do SPA dla Anny\n- Nowa książka Mroza\n- Słuchawki bezprzewodowe',
      createdAt: DateTime.now(),
    );
    await dataProvider.addNote(note2);

    // 4. DIARY ENTRIES
    final entry1 = DiaryEntry(
      id: uuid.v4(),
      date: DateTime.now(),
      title: 'Produktywny dzień', // Added title
      // Mood is likely part of content or implemented differently, not in Constructor.
      // Based on file: DiaryEntry has title and content, no mood field.
      content: 'Nastrój: Szczęśliwy\n\nTo był naprawdę produktywny dzień! Udało się załatwić większość spraw z listy. Wieczorem relaks przy dobrym filmie.',
    );
    await dataProvider.addDiaryEntry(entry1);

    final entry2 = DiaryEntry(
      id: uuid.v4(),
      date: DateTime.now().subtract(const Duration(days: 1)),
      title: 'Spokojny wtorek', // Added title
      content: 'Nastrój: Neutralny\n\nSpokojny wtorek. Niewiele się działo, ale przynajmniej odpocząłem po weekendzie.',
    );
    await dataProvider.addDiaryEntry(entry2);
  }
}
