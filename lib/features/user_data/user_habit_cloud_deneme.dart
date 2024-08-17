import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:good_place/core/utils/models/habit_model.dart';
import 'package:good_place/features/user_data/habit_provider.dart';
import 'package:good_place/firebase_options.dart';
import 'package:provider/provider.dart';

// Bu dosya habit ve user: firebase - provider deneme içindir. İleride silinecektir.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    ChangeNotifierProvider(
      create: (_) => HabitProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HabitTestWidget(),
    );
  }
}

class HabitTestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Habit Tracker Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // =>>>   Get Habit List
            ElevatedButton(
              onPressed: () async {
                await habitProvider.getHabits();
              },
              child: Text('Get Habits'),
            ),

            //  =>>>  ADD Habit
            ElevatedButton(
              onPressed: () async {
                HabitModel newHabit = HabitModel(
                  title: 'Yeni Alışkanlık',
                  createDate: DateTime.now(),
                  streakCount: 0,
                  completionDates: [],
                );
                await habitProvider.addHabit(newHabit);
              },
              child: Text('Add Habit'),
            ),

            // =>>>  Update Habit Fields
            ElevatedButton(
              onPressed: () async {
                if (habitProvider.habits.isNotEmpty) {
                  String habitId = habitProvider.habits[0].id!;
                  Map<String, dynamic> updatedFields = {
                    'completionDates': [Timestamp.fromDate(DateTime.now())],
                    'title': '""""""Updated Habit Title""""":)))',
                  };
                  await habitProvider.updateHabit(habitId, updatedFields);
                }
              },
              child: Text('Update First Habit'),
            ),

            //  =>>>  DELETE Habit
            ElevatedButton(
              onPressed: () async {
                if (habitProvider.habits.isNotEmpty) {
                  String habitId = habitProvider.habits[1].id!;
                  await habitProvider.deleteHabit(habitId);
                }
              },
              child: Text('Delete Habit'),
            ),

            //   =>>>  Provider ile güncellenen listeyi ekrana ver
            Expanded(
              child: ListView.builder(
                itemCount: habitProvider.habits.length,
                itemBuilder: (context, index) {
                  final habit = habitProvider.habits[index];
                  return ListTile(
                    title: Text(habit.title),
                    subtitle: Text(
                        'Streak: ${habit.streakCount},  Done: ${habit.done},  Completed on: ${habit.completionDates.join(', ')}, id: ${habit.id}, purpose: ${habit.purpose},createDate: ${habit.createDate},imageUrl: ${habit.imageUrl}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
