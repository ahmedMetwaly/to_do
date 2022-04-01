import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:to_do/shared/cubit/AppCubit.dart';

const Color mainTextColor = Color(0xFFFFC112);
const ColorScheme colorScheme = ColorScheme.light(
  primary: mainTextColor, // header background color
  onPrimary: Colors.black, // header text color
  onSurface: Colors.black,
  // body text color
);

TextButtonThemeData textButtonScheme = TextButtonThemeData(
  style: TextButton.styleFrom(
    primary: Colors.red, // button text color
  ),
);

Dismissible task({
  required String taskTitle,
  required String taskTime,
  required String taskDate,
  required AppCubit cubit,
  required int index,
  required List<Map> listData,
  required context,
  var doneSign,
  var archivedSign,
}) {
  return Dismissible(
    key: Key(listData[index]['id'].toString()),
    onDismissed: (direction) {
      cubit.deleteData(id: listData[index]['id']);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: CircleAvatar(
              backgroundColor: mainTextColor,
              radius: 35,
              child: Text(
                taskTime,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Lobster',
                  fontSize: 22,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  taskTitle,
                  style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Lobster',
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  taskDate,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Lobster',
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Conditional.single(
            context: context,
            conditionBuilder: (context) => doneSign == true,
            widgetBuilder: (context) => Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  cubit.updateData(
                      state: 'doneList', id: listData[index]['id']);
                },
                icon: const Icon(Icons.done),
                color: Colors.green,
                iconSize: 35,
                splashRadius: 22,
                splashColor: Colors.green[200],
              ),
            ),
            fallbackBuilder: (context) => SizedBox(
              width: 1,
            ),
          ),
          Conditional.single(
              context: context,
              conditionBuilder: (context) => archivedSign == true,
              widgetBuilder: (context) => Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {
                        cubit.updateData(
                            state: 'archivedList', id: listData[index]['id']);
                      },
                      icon: Icon(Icons.archive_outlined),
                      color: Colors.blueGrey[900],
                      iconSize: 35,
                      splashRadius: 22,
                      splashColor: Colors.blueGrey[200],
                    ),
                  ),
              fallbackBuilder: (context) => SizedBox(
                    width: 1,
                  )),
          SizedBox(
            width: 7,
          )
        ],
      ),
    ),
  );
}
