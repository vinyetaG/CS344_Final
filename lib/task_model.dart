import 'package:flutter/material.dart';
import 'task_item.dart';
import 'package:final_project/src/custom_widgets.dart';
import 'package:intl/intl.dart';

class TaskModel extends ChangeNotifier {
  final _taskList = <TaskItem>[
    TaskItem(
        name: 'Task 1',
        description: 'Task description',
        priority: 0,
        dueDate: DateTime.now().add(const Duration(days: 5))),
    TaskItem(
        name: 'Task 2',
        description: 'Task description',
        priority: 1,
        dueDate: DateTime.now().add(const Duration(days: 10))),
    TaskItem(
        name: 'Zebra Task',
        description: 'Task description',
        priority: 2,
        dueDate: DateTime.now().add(const Duration(days: 8))),
    TaskItem(
        name: 'Task 4',
        description: 'Task description',
        priority: 1,
        dueDate: DateTime.now().add(const Duration(days: 7))),
    TaskItem(
        name: 'Alpha Task',
        description: 'Task description',
        priority: 0,
        dueDate: DateTime.now().add(const Duration(days: 6))),
    TaskItem(
        name: 'Task 6',
        description: 'Task description',
        priority: 1,
        dueDate: DateTime.now().add(const Duration(days: 5))),
    TaskItem(
        name: 'Task 7',
        description: 'Task description',
        priority: 2,
        dueDate: DateTime.now().add(const Duration(days: 1))),
    TaskItem(
        name: 'Beta Task',
        description: 'Task description',
        priority: 1,
        dueDate: DateTime.now().add(const Duration(days: 12))),
    TaskItem(
        name: 'Task 9',
        description: 'Task description',
        priority: 0,
        dueDate: DateTime.now().add(const Duration(days: 12))),
    TaskItem(
        name: 'Task 10',
        description: 'Task description',
        priority: 1,
        dueDate: DateTime.now().add(const Duration(days: 11)))
  ];
  List<DropdownMenuItem<int>> priorityLevels = [
    const DropdownMenuItem(value: 0, child: Text("Low")),
    const DropdownMenuItem(value: 1, child: Text("Medium")),
    const DropdownMenuItem(value: 2, child: Text("High")),
  ];
  
  // Lists of tasks completed on time and late
  final _completedTasks = <TaskItem>[];
  final _lateTasks = <TaskItem>[];

  ///Returns the task at the given index of the task list
  TaskItem getTask(int index) {
    return _taskList[index];
  }

  ///Returns the number of tasks in the task list
  int numTasks() {
    return _taskList.length;
  }

  ///Removes the given task
  void removeTask(int index) {
    _taskList.removeAt(index);
    notifyListeners();
  }
  
  // Calculates the % of tasks completed on time
  double tasksOnTime() {
    if (_lateTasks.isEmpty) {
      return 100;
    } else {
      return (_completedTasks.length /
              (_completedTasks.length + _lateTasks.length)) *
          100;
    }
  }

  ///Sorts by priority
  void sortByPriority() {
    _taskList.sort((a, b) => b.priority.compareTo(a.priority));
    notifyListeners();
  }

  ///Sorts by due date (TODO)
  void sortByDue() {
    _taskList.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    notifyListeners();
  }

  ///Sorts by name
  void sortByName() {
    _taskList.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  ///Adds a task
  void _addTask(BuildContext context,
      {required String name,
      String? description,
      required int priority,
      required DateTime dueDate}) {
    _taskList.add(TaskItem(
        name: name,
        description: description,
        priority: priority,
        dueDate: dueDate));
  }

  ///Displays information about the given task including the full description and due date (TODO)
  ///Also allows the user to edit the task
  Future<void> openInfoPanel(context, {required TaskItem taskItem}) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              insetPadding: const EdgeInsets.all(0),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 24.0),
                    child: Column(children: [
                      //Name and description
                      Text(taskItem.name,
                          style: Theme.of(context).textTheme.titleLarge),
                      Text(
                        taskItem.description ?? "",
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 35),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Due date and timer
                          Expanded(
                            child: Text('Do by: ${taskItem.dueDate}',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor)),
                          ),
                          taskItem.timer
                        ],
                      ),
                      const SizedBox(height: 20), //whitespace
                      //Edit menu
                      ElevatedButton(
                          onPressed: (() => openTaskMenu(context,
                              type: TaskMenu.edit, taskItem: taskItem)),
                          child: const Text('Edit Task'))
                    ]),
                  ),
                )
              ]);
        });
  }

  ///Confirms that the user wants to remove a task from the list
  void _confirmRemoval(BuildContext context, {required TaskItem taskItem}) {
    String taskName = taskItem.name;
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Remove Task'),
        content: Text(
            'Remove $taskName from your list? It will not be marked as completed.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _taskList.remove(taskItem);
              notifyListeners();
              for (int i = 0; i < 3; i++) {
                Navigator.pop(context);
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  ///Confirms that the user wants to complete the specified task
  void confirmCompletion(BuildContext context, {required TaskItem taskItem}) {
    String taskName = taskItem.name;
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Complete Task'),
        content: Text('Mark "$taskName" as completed?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              taskItem.selected = false;
              notifyListeners();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _taskList.remove(taskItem);
              // If date > due date, add to late tasks
              if (DateTime.now().compareTo(taskItem.dueDate) > 0) {
                _lateTasks.add(taskItem);
              } else {
                _completedTasks.add(taskItem);
              }
              notifyListeners();
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));

    return selectedDate;
  }

  ///Returns the time of day from a string formatted in the form 'H:MM AM/PM', or
  ///null if formatted incorrectly
  TimeOfDay? _stringToTime(String text) {
    int colonIndex = text.indexOf(':');
    int spaceIndex = text.indexOf(' ');
    //Ensure colon and space are in correct location depending on 1 or 2 digit
    //hour number
    if ((colonIndex != 1 && colonIndex != 2) ||
        (spaceIndex != 4 && spaceIndex != 5)) {
      return null;
    }

    String hourStr = text.substring(0, colonIndex);
    String minuteStr = text.substring(colonIndex + 1, spaceIndex);
    String amOrPm = text.substring(spaceIndex + 1, text.length).toLowerCase();
    //Ensure hour and minutes have the correct number of digits
    if (hourStr.length != 1 && hourStr.length != 2 || minuteStr.length != 2) {
      return null;
    }

    //Ensure string includes whether the time is in AM or PM correctly
    if (amOrPm != 'am' && amOrPm != 'pm') {
      return null;
    }

    int? hour = int.tryParse(hourStr);
    int? minute = int.tryParse(minuteStr);

    if (hour == null || minute == null) {
      return null;
    }

    if (hour < 1 || hour > 12 || minute > 59) {
      return null;
    }

    if (amOrPm == 'am') {
      if (hour == 12) {
        hour = 0;
      }
    } else {
      if (hour != 12) {
        hour += 12;
      }
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  ///Formats the hours and minutes of a DateTime to be shown in H:MM AM/PM format
  String _formatTime(DateTime time) {
    String formattedTime;
    int currHour = time.hour;
    int currMin = time.minute;
    String currAmOrPm;
    //Change hour and minutes to non-military time
    if (currHour < 12) {
      currAmOrPm = 'AM';
      if (currHour == 0) {
        currHour = 12;
      }
    } else {
      currAmOrPm = 'PM';
      if (currHour != 12) {
        currHour -= 12;
      }
    }

    String formattedMin = currMin.toString();
    if (currMin < 10) {
      formattedMin = '0$formattedMin';
    }
    formattedTime = '$currHour:$formattedMin $currAmOrPm';
    return formattedTime;
  }

  ///Opens pop up menu to either add or edit a task. If called to edit a task,
  ///taskItem must not be null
  Future<void> openTaskMenu(BuildContext context,
      {required TaskMenu type, TaskItem? taskItem}) async {
    if (type == TaskMenu.edit && taskItem == null) {
      throw ArgumentError(
          "Edit menu was called without providing the task item to be edited.");
    }
    final formKey = GlobalKey<FormState>();
    String header, actionLabel;
    String? newTaskName,
        newTaskDescription,
        currTaskName,
        currTaskDescription,
        timeShown;
    int? newPriorityLevel, currPriorityLevel;
    DateTime? currDueDate;
    final dateController = TextEditingController();
    TimeOfDay? currTimeDue;

    ///Determines fields that are shown depending on if user is in add or edit
    ///task menu
    if (type == TaskMenu.add) {
      header = 'Create New Task';
      actionLabel = 'Create Task';
    } else {
      header = 'Edit Task';
      actionLabel = 'Save Changes';
      currTaskName = taskItem!.name;
      currTaskDescription = taskItem.description;
      currPriorityLevel = taskItem.priority;
      int currHour = taskItem.dueDate.hour;
      int currMin = taskItem.dueDate.minute;
      //Format initial time to display in edit menu
      timeShown = _formatTime(taskItem.dueDate);
      currTimeDue = TimeOfDay(hour: currHour, minute: currMin);
      //Subtract time due for now, time inputted is readded later
      currDueDate = taskItem.dueDate
          .subtract(Duration(hours: currHour, minutes: currMin));
    }
    if (currDueDate != null) {
      dateController.text = DateFormat('MM/dd/yyyy').format(currDueDate);
    }

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            insetPadding: const EdgeInsets.all(0),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 24, 24, 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          //Back arrow
                          IconButton(
                              onPressed: (() => Navigator.of(context).pop()),
                              icon: const Icon(Icons.arrow_back_ios_new)),
                          //Title
                          Text(
                            header,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          //Delete task button is shown if in the edit menu
                          if (type == TaskMenu.edit) const Spacer(),
                          if (type == TaskMenu.edit)
                            IconButton(
                                onPressed: (() => _confirmRemoval(context,
                                    taskItem: taskItem!)),
                                icon: const Icon(Icons.delete)),
                        ],
                      ),
                      //Gets task data from form
                      Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Task name',
                                ),
                                //If editing, show current name (else empty)
                                initialValue: currTaskName,
                                validator: (text) => text!.isEmpty
                                    ? 'The task must be given a name.'
                                    : null,
                                onSaved: (text) => newTaskName = text,
                              ),
                              const SizedBox(height: 15), //whitespace
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Task description (optional)',
                                ),
                                //If editing, show current description (else empty)
                                initialValue: currTaskDescription,
                                validator: (text) => text!.length > 150
                                    ? 'Description can be at most 150 characters long.'
                                    : null,
                                onSaved: (text) => newTaskDescription = text,
                              ),
                              const SizedBox(height: 15), //whitespace
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: DropdownButtonFormField<int>(
                                        hint: const Text('Priority level'),
                                        items: priorityLevels,
                                        validator: (value) => value == null
                                            ? 'Please set a valid priority level\nfor this task.'
                                            : null,
                                        //If editing...else empty
                                        value: currPriorityLevel,
                                        onChanged: (int? newValue) {
                                          newPriorityLevel = newValue!;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Due date',
                                          ),
                                          controller: dateController,
                                          onTap: () async {
                                            //Stop keyboard from appearing
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            //Assign due date to selection in date
                                            //picker. If canceled, don't change.
                                            currDueDate =
                                                await _selectDate(context) ??
                                                    currDueDate;
                                            if (currDueDate != null) {
                                              dateController.text =
                                                  DateFormat('MM/dd/yyyy')
                                                      .format(currDueDate!);
                                            }
                                          },
                                          validator: ((value) {
                                            if (currDueDate == null ||
                                                dateController.text.isEmpty) {
                                              return 'Please select a valid date.';
                                            }
                                            return null;
                                          }),
                                        )),
                                  ]),
                              Row(children: [
                                const Spacer(),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Time due',
                                      ),
                                      initialValue: timeShown,
                                      validator: (text) {
                                        TimeOfDay? timeInput =
                                            _stringToTime(text!);
                                        if (timeInput == null) {
                                          return 'Please enter time in the\nform H:MM am/pm';
                                        }
                                        return null;
                                      },
                                      onSaved: (text) =>
                                          currTimeDue = _stringToTime(text!),
                                    ))
                              ]),
                              const SizedBox(height: 30), //whitespace
                            ],
                          )),
                      Container(
                          //Add/update task button
                          color: Theme.of(context).colorScheme.primary,
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.width * 0.10,
                          child: ElevatedButton(
                              onPressed: ((() {
                                //If fields are valid, add task or edit fields accordingly.
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  //Readd the time due to the due date
                                  currDueDate = currDueDate!.add(Duration(
                                      hours: currTimeDue!.hour,
                                      minutes: currTimeDue!.minute));
                                  if (type == TaskMenu.add) {
                                    _addTask(context,
                                        name: newTaskName!,
                                        description: newTaskDescription,
                                        priority: newPriorityLevel!,
                                        dueDate: currDueDate!);
                                    Navigator.pop(context);
                                    notifyListeners();
                                  } else {
                                    taskItem!.name =
                                        newTaskName ?? currTaskName!;
                                    taskItem.description = newTaskDescription ??
                                        currTaskDescription!;
                                    taskItem.priority =
                                        newPriorityLevel ?? currPriorityLevel!;
                                    taskItem.dueDate = currDueDate!;
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    notifyListeners();
                                  }
                                }
                              })),
                              child: Text(actionLabel)))
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}
