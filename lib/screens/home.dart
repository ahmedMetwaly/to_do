import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/shared/constants.dart';
import 'package:to_do/shared/cubit/AppCubit.dart';
import 'package:to_do/shared/cubit/AppCubitStates.dart';
import 'package:intl/intl.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  TextEditingController taskTitle = TextEditingController();
  TextEditingController taskDate = TextEditingController();
  TextEditingController taskTime = TextEditingController();
  var date;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppCubitStates>(
        listener: (context, state) => {},
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: appBar(cubit),
            bottomNavigationBar: bottomNavBar(cubit),
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xFF232323),
              child: Icon(
                cubit.icon,
                color: mainTextColor,
                size: 30,
              ),
              onPressed: () {
                if (cubit.isOpened) {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) {
                          return Container(
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    inputTask(
                                      kyeboradType: TextInputType.name,
                                      controller: taskTitle,
                                      valdatorText: 'Task title is Empty',
                                      prefixIcon: Icons.text_fields_outlined,
                                      labelTitle: 'Task Title',
                                      hintTitle: 'ex: Start coding',
                                    ),
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    datePicker(context),
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    timePicker(context),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                      .closed
                      .then(
                        (value) {
                          cubit.closedBottomSheet();
                          clearText();
                        },
                      );
                  cubit.openedBottmSheet();
                } else {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDataBase(
                      taskTitle: taskTitle.text,
                      taskDate: date,
                      taskTime: taskTime.text,
                    );
                    cubit.closedBottomSheet();
                    clearText();
                    Navigator.pop(context);
                  }
                }
              },
            ),
            body: cubit.screens[cubit.selectedIndex],
          );
        },
      ),
    );
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  Theme timePicker(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: mainTextColor,
        colorScheme: colorScheme,
        textButtonTheme: textButtonScheme,
      ),
      child: Builder(
        builder: (context) => inputTask(
          kyeboradType: TextInputType.none,
          controller: taskTime,
          valdatorText: 'Task time is Empty',
          prefixIcon: Icons.timer_outlined,
          labelTitle: 'Time',
          hintTitle: 'ex: 12:59',
          onClicked: () {
            showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            ).then(
              (value) {
                taskTime.text = value!.format(context).toString();
              },
            );
          },
        ),
      ),
    );
  }

  Theme datePicker(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: mainTextColor,
        colorScheme: colorScheme,
        textButtonTheme: textButtonScheme,
      ),
      child: Builder(
        builder: (context) {
          return inputTask(
              context: context,
              kyeboradType: TextInputType.none,
              controller: taskDate,
              valdatorText: 'Date is Empty',
              prefixIcon: Icons.watch_later_outlined,
              labelTitle: 'Date',
              hintTitle: 'ex: Tuesday, March 29, 2022',
              onClicked: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                ).then(
                  (value) {
                    date = convertDateTimeDisplay(value.toString());
                    //print(date);
                    return taskDate.text =
                        DateFormat.yMMMMEEEEd().format(value!);
                  },
                );
              });
        },
      ),
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

  BottomNavigationBar bottomNavBar(AppCubit cubit) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.menu,
          ),
          label: 'Tasks',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.check_circle_outlined,
          ),
          label: 'Done',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.archive_outlined,
          ),
          label: 'Archived',
        ),
      ],
      elevation: 0,
      iconSize: 30,
      selectedFontSize: 17,
      selectedLabelStyle: const TextStyle(
        fontFamily: 'permanentMarker',
      ),
      backgroundColor: const Color(0xFF232323),
      selectedItemColor: mainTextColor,
      unselectedItemColor: Colors.white,
      currentIndex: cubit.selectedIndex,
      onTap: cubit.onIndexChanged,
    );
  }

  AppBar appBar(AppCubit cubit) {
    return AppBar(
      title: Text(
        cubit.appBarTitles[cubit.selectedIndex],
        style: const TextStyle(
          color: mainTextColor,
          fontFamily: 'Lobster',
          fontSize: 28,
        ),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFF232323),
    );
  }

  void clearText() {
    taskTitle.text = '';
    taskDate.text = '';
    taskTime.text = '';
  }
}
