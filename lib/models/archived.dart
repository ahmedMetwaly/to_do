import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/shared/constants.dart';
import 'package:to_do/shared/cubit/AppCubit.dart';
import 'package:to_do/shared/cubit/AppCubitStates.dart';

class ArchivedTasks extends StatelessWidget {
  const ArchivedTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppCubitStates>(
      listener: (context, state) {},
      builder: (context, state) => ListView.separated(
        itemBuilder: (context, index) => task(
          context: context,
          listData: cubit.archivedList,
          cubit: cubit,
          index: index,
          doneSign: true,
          taskTitle: cubit.archivedList[index]['title'],
          taskTime: cubit.archivedList[index]['time'],
          taskDate: cubit.archivedList[index]['date'],
        ),
        separatorBuilder: (context, index) => Container(
          height: 1,
          color: Colors.orange,
        ),
        itemCount: cubit.archivedList.length,
      ),
    );
  }
}
