import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:to_do/shared/cubit/AppCubit.dart';

import 'notification_services.dart';

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

void makeNotification(AppCubit cubit, int index, String timeOfNotification) {
  NotificationServices().scheduleNotifications(
    id: cubit.taskList[index]['id'],
    title: cubit.taskList[index]['title'],
    body: 'Hey it\'s time to do your task',
    timeOfNotification: timeOfNotification,
  );
}

TextFormField inputTask({
  required TextEditingController controller,
  required String valdatorText,
  required IconData prefixIcon,
  required String labelTitle,
  required String hintTitle,
  required TextInputType kyeboradType,
  var context,
  var onClicked,
}) {
  return TextFormField(
    controller: controller,
    validator: (value) {
      if (value!.isEmpty) {
        return valdatorText;
      }
    },
    keyboardType: kyeboradType,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontFamily: 'Lobster',
      wordSpacing: 5,
    ),
    decoration: InputDecoration(
      prefixIcon: Icon(
        prefixIcon,
        size: 30,
        color: Colors.white,
      ),
      prefixIconColor: Colors.white,
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: mainTextColor,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      label: Text(
        labelTitle,
      ),
      labelStyle: const TextStyle(
        fontSize: 25,
        color: mainTextColor,
        fontFamily: 'PermanentMarker',
      ),
      hintText: hintTitle,
      hintStyle: const TextStyle(
        color: mainTextColor,
        fontSize: 15,
        fontFamily: 'Lobster',
      ),
    ),
    onTap: onClicked,
  );
}

Widget task({
  required String taskTitle,
  required String taskTime,
  required String taskDate,
  required AppCubit cubit,
  required int index,
  required List<Map> listData,
  var timeOfNotification,
  required context,
  var doneSign,
  var archivedSign,
}) {
  if (listData == cubit.taskList) {
    makeNotification(cubit, index, timeOfNotification);
  }

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
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Conditional.single(
                  context: context,
                  conditionBuilder: (context) => taskTime.contains(' '),
                  widgetBuilder: (context) => displyTime(
                    "${taskTime.split(" ")[0]}\n${taskTime.split(" ")[1]}",
                  ),
                  fallbackBuilder: (context) => displyTime(taskTime),
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
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
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
            fallbackBuilder: (context) => const SizedBox(
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
                      icon: const Icon(Icons.archive_outlined),
                      color: Colors.blueGrey[900],
                      iconSize: 35,
                      splashRadius: 22,
                      splashColor: Colors.blueGrey[200],
                    ),
                  ),
              fallbackBuilder: (context) => const SizedBox(
                    width: 1,
                  )),
          const SizedBox(
            width: 7,
          )
        ],
      ),
    ),
  );
}

Text displyTime(String taskTime) {
  return Text(
    taskTime,
    textAlign: TextAlign.center,
    style: const TextStyle(
      color: Colors.black,
      fontFamily: 'Lobster',
      fontSize: 22,
    ),
  );
}
