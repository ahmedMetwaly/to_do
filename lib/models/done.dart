import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/shared/constants.dart';
import 'package:to_do/shared/cubit/AppCubit.dart';
import 'package:to_do/shared/cubit/AppCubitStates.dart';

class DoneTasks extends StatelessWidget {
  const DoneTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppCubitStates>(
      listener: (context, state) {},
      builder: (context, state) => ListView.separated(
        itemBuilder: (context, index) => task(
          context: context,
          listData: cubit.doneList,
          cubit: cubit,
          index: index,
          taskTitle: cubit.doneList[index]['title'],
          taskTime: cubit.doneList[index]['time'],
          taskDate: cubit.doneList[index]['date'],
        ),
        separatorBuilder: (context, index) => Container(
          height: 1,
          color: Colors.orange,
        ),
        itemCount: cubit.doneList.length,
      ),
    );
  }
}
