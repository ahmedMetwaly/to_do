import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/models/archived.dart';
import 'package:to_do/models/done.dart';
import 'package:to_do/models/tasks.dart';
import 'package:to_do/shared/cubit/AppCubitStates.dart';

late Database database;

class AppCubit extends Cubit<AppCubitStates> {
  AppCubit() : super(InitialAppCubitState());

  static AppCubit get(context) => BlocProvider.of(context);

  //for change nav bar items
  int selectedIndex = 0;

  List<Widget> screens = [
    const Tasks(),
    const DoneTasks(),
    const ArchivedTasks(),
  ];
  List<String> appBarTitles = [
    'Tasks',
    'Done',
    'Archived',
  ];
  void onIndexChanged(int index) {
    selectedIndex = index;
    emit(OnButtonNavBarItemChanged());
  }

//change FAT icon
  IconData icon = Icons.edit;
  bool isOpened = true;

  List<Map> taskList = [];
  List<Map> doneList = [];
  List<Map> archivedList = [];

  void closedBottomSheet() {
    isOpened = true;
    icon = Icons.edit;
    emit(CloseBottomSheet());
  }

  void openedBottmSheet() {
    isOpened = false;
    icon = Icons.add;
    emit(OpenBottomSheet());
  }

//dataBase
  void createDataBase() {
    openDatabase(
      'toDo.db',
      version: 1,
      onCreate: (database, version) {
        print('database is created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, state Text)')
            .then(
          (value) {
            print('Table is created');
          },
        ).catchError(
          (error) {
            print('while creating Table this error happened ${error}');
          },
        );
      },
      onOpen: (database) {
        print('data base is opened');
        getData(database);
      },
    ).then((value) {
      database = value;

      emit(DataBaseIsCreated());
    });
  }

  insertToDataBase({
    required String taskTitle,
    required String taskTime,
    required String taskDate,
  }) async {
    await database.transaction(
      (txn) => txn
          .rawInsert(
        'INSERT INTO tasks(title, date, time, state) VALUES("$taskTitle", "$taskDate", "$taskTime", "taskList")',
      )
          .then(
        (value) {
          print('$value is inserted sucssefully ');
          emit(InsertedToDataBase());
          getData(database).then((value) {
            emit(DataIsgitten());
          });
        },
      ).catchError(
        (error) {
          print('$error created when inserrting a row in');
        },
      ),
    );
  }

  getData(Database db) async {
    await db.rawQuery('SELECT * FROM tasks').then((value) {
      taskList = [];
      doneList = [];
      archivedList = [];
      print('dataBase is gitten');
      for (var task in value) {
        if (task['state'] == 'taskList') {
          taskList.add(task);
        } else if (task['state'] == 'doneList') {
          doneList.add(task);
        } else {
          archivedList.add(task);
        }
      }
      print('taskList = $taskList');
      print('doneList = $doneList');
      print('archivedList = $archivedList');

      emit(DataIsgitten());
    });
  }

  void updateData({required String state, required int id}) {
    database.rawUpdate('UPDATE tasks SET state = ? WHERE id = ?',
        ['$state', id]).then((value) {
      print('data is updated');
      emit(UpdatedData());
      getData(database);
    });
  }

  void deleteData({required int id}) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      print('$value is deleted');
      emit(Delted());
      getData(database);
    });
  }
}
