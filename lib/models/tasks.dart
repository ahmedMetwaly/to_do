import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/shared/constants.dart';
import 'package:to_do/shared/cubit/AppCubit.dart';
import 'package:to_do/shared/cubit/AppCubitStates.dart';

class Tasks extends StatelessWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppCubitStates>(
      listener: (context, state) {},
      builder: (context, state) => ListView.separated(
        itemBuilder: (context, index) => task(
          context: context,
          cubit: cubit,
          index: index,
          doneSign: true,
          archivedSign: true,
          listData: cubit.taskList,
          taskTitle: cubit.taskList[index]['title'],
          taskTime: cubit.taskList[index]['time'],
          taskDate: cubit.taskList[index]['date'],
        ),
        separatorBuilder: (context, index) => Container(
          height: 1,
          color: Colors.orange,
        ),
        itemCount: cubit.taskList.length,
      ),
    );
  }
}
