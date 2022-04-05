import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do/shared/constants.dart';
import 'package:to_do/shared/cubit/AppCubit.dart';
import 'package:to_do/shared/cubit/AppCubitStates.dart';

class Tasks extends StatelessWidget {
  const Tasks({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    late String timeOfNotification;

    return BlocConsumer<AppCubit, AppCubitStates>(
      listener: (context, state) {},
      builder: (context, state) => ListView.separated(
        itemBuilder: (context, index) {
          //time in the task
          if (cubit.taskList[index]['time'].toString().contains('PM') ||
              cubit.taskList[index]['time'].toString().contains('AM')) {
            //to remove AM or PM from time and get hours and minutes
            DateTime convertedDate =
                DateFormat.jm().parse(cubit.taskList[index]['time'].toString());
            //print(convertedDate);
            var removeAmPM = DateFormat('HH:mm').format(convertedDate);
            //print('after removng AMPM $removeAmPM');
            timeOfNotification = cubit.taskList[index]['date'] +
                " " +
                removeAmPM.toString() +
                ":00";
          } else {
            // to get hours in minutes
            timeOfNotification = cubit.taskList[index]['date'] +
                " " +
                cubit.taskList[index]['time'].toString() +
                ":00";
          }
          return task(
            context: context,
            cubit: cubit,
            index: index,
            doneSign: true,
            archivedSign: true,
            listData: cubit.taskList,
            taskTitle: cubit.taskList[index]['title'],
            taskTime: cubit.taskList[index]['time'],
            taskDate: DateFormat.yMMMMEEEEd()
                .format(DateTime.parse(cubit.taskList[index]['date']))
                .toString(),
            timeOfNotification: timeOfNotification,
          );
        },
        separatorBuilder: (context, index) => Container(
          height: 1,
          color: Colors.orange,
        ),
        itemCount: cubit.taskList.length,
      ),
    );
  }
}
