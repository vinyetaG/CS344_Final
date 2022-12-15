import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'task_item.dart';
import 'package:final_project/src/custom.dart';
import 'package:intl/intl.dart';

///Name: Gerald Vinyeta, Joe Kehoe
///Date: 12/14/2022
///Description: Methods and data accessed by task items and the task list
///Bugs: N/A
///Reflection: The task add/edit menu comprised the majority of the work, getting date
///            time to work just right was a bit tricky as well.
class TaskModel extends ChangeNotifier {
  final _taskList = [];
  List<DropdownMenuItem<int>> priorityLevels = [
    const DropdownMenuItem(value: 0, child: Text("Low")),
    const DropdownMenuItem(value: 1, child: Text("Medium")),
    const DropdownMenuItem(value: 2, child: Text("High")),
  ];
  final taskDb = FirebaseFirestore.instance;
  int _tasksCompleted = 0;
  int _tasksOnTime = 0;

  ///Returns the task at the given index of the task list
  TaskItem getTask(int index) {
    return _taskList[index];
  }

  ///Returns the number of tasks in the task list
  int numTasks() {
    return _taskList.length;
  }

  ///Returns the number of tasks completed for user or session.
  int completedTasks() {
    return _tasksCompleted;
  }

  ///Returns the number of tasks that are currently overdue
  int tasksCurrOverdue() {
    int overdue = 0;
    for (var taskItem in _taskList) {
      if (DateTime.now().compareTo(taskItem.dueDate) > 0) {
        overdue++;
      }
    }
    return overdue;
  }

  ///Initialize user fields when they sign in
  Future<void> initializeFields(TaskModel taskModel) async {
    String email = FirebaseAuth.instance.currentUser!.email!;
    var userDocs = await taskDb.collection(email).get();
    if (userDocs.docs.isNotEmpty) {
      var userData = userDocs.docs[0];

      _tasksCompleted = userData['tasksCompleted'] ?? 0;
      _tasksOnTime = userData['tasksOnTime'] ?? 0;
      var tasks = userData['tasks'];

      for (var task in tasks) {
        String name = task['name'];
        String description = task['description'];
        int priority = task['priority'];
        int dueDateMillis = task['dueDate'];
        int secondsElapsed = task['secondsElapsed'];
        bool timerRunning = task['timerRunning'];
        int? timerStarted = task['timerStarted'];
        _taskList.add(TaskItem(taskModel,
            name: name,
            description: description,
            priority: priority,
            dueDate: DateTime.fromMillisecondsSinceEpoch(dueDateMillis),
            secondsElapsed: secondsElapsed,
            timerRunning: timerRunning,
            timerStarted: timerStarted));
      }
    }
  }

  ///Removes the given task
  void _removeTask(TaskItem taskItem) {
    _taskList.remove(taskItem);
    notifyListeners();
  }

  ///Clears fields when user logs out
  void clearFields() {
    _taskList.clear();
    _tasksCompleted = 0;
    _tasksOnTime = 0;
  }

  ///Sort the task items by the given parameter
  void sortByType(BuildContext context, TaskModel taskModel,
      {required SortOption type}) {
    switch (type) {
      case (SortOption.priority):
        _taskList.sort((a, b) => b.priority.compareTo(a.priority));
        break;
      case (SortOption.name):
        _taskList.sort((a, b) => a.name.compareTo(b.name));
        break;
      case (SortOption.date):
        _taskList.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
    }
    //Workaround for rebuilding each task item without making each a consumer
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              TasksApp(routeIndex: 0, taskModel: taskModel),
          transitionDuration: Duration.zero,
        ));
  }

  ///Return a string representing the percentage of tasks completed on time, or
  ///null if no tasks have been completed yet
  String? tasksOnTimePct() {
    if (_tasksCompleted == 0) {
      return null;
    }
    return (_tasksOnTime / _tasksCompleted * 100).toStringAsFixed(1);
  }

  //Returns the number of tasks due within the next week
  int tasksDueThisWeek() {
    int taskCount = 0;
    for (var taskItem in _taskList) {
      DateTime weekFromNow = DateTime.now().add(const Duration(days: 7));
      if (taskItem.dueDate.compareTo(weekFromNow) <= 0) {
        taskCount++;
      }
    }
    return taskCount;
  }

  ///Syncs data to user's account if they are signed in
  void syncChanges() {
    if (FirebaseAuth.instance.currentUser != null) {
      String email = FirebaseAuth.instance.currentUser!.email!;
      var tasks = <Map<String, dynamic>>[];

      for (var taskItem in _taskList) {
        var currTaskFields = {
          'name': taskItem.name,
          'description': taskItem.description,
          'priority': taskItem.priority,
          'dueDate': taskItem.dueDate.millisecondsSinceEpoch,
          'timerStarted': taskItem.timerStarted,
          'timerRunning': taskItem.timerRunning,
          'secondsElapsed': taskItem.secondsElapsed
        };
        tasks.add(currTaskFields);
      }
      taskDb.collection(email).doc('data').set({'tasks': tasks});
      taskDb
          .collection(email)
          .doc('data')
          .update({'tasksCompleted': _tasksCompleted});
      taskDb
          .collection(email)
          .doc('data')
          .update({'tasksOnTime': _tasksOnTime});
    }
  }

  ///Adds a task
  void addTask(TaskModel taskModel,
      {required String name,
      String? description,
      required int priority,
      required DateTime dueDate}) {
    _taskList.add(TaskItem(taskModel,
        name: name,
        description: description,
        priority: priority,
        dueDate: dueDate));
  }

  ///Displays information about the given task including the full description and due date
  ///Also allows the user to edit the task, in which case return edited = true
  Future<bool> openInfoPanel(context, {required TaskItem taskItem}) async {
    bool edited = false;
    String dateString = DateFormat('MM/dd/yyyy ').format(taskItem.dueDate);
    dateString += _formatTime(taskItem.dueDate);
    String priorityStr;
    switch (taskItem.priority) {
      case (0):
        priorityStr = 'Low';
        break;
      case (1):
        priorityStr = "Medium";
        break;
      default:
        priorityStr = 'High';
    }
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              insetPadding: const EdgeInsets.all(0),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 24.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Name and description
                        Text(taskItem.name,
                            style: Theme.of(context).textTheme.titleLarge),
                        Text(
                          taskItem.description ?? "",
                          style: const TextStyle(color: Colors.black),
                        ),
                        const SizedBox(height: 35), //whitespace
                        //Priority and due date
                        Text('$priorityStr priority',
                            style: TextStyle(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor)),
                        Text('Due by: $dateString',
                            style: TextStyle(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor)),
                        const SizedBox(height: 20), //whitespace
                        //Edit menu
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                onPressed: (() async {
                                  //Open edit menu and return that task was edited
                                  final navigator = Navigator.of(context);
                                  await openTaskMenu(context,
                                      taskModel: taskItem.taskModel,
                                      type: TaskMenu.edit,
                                      taskItem: taskItem);
                                  edited = true;
                                  navigator.pop();
                                }),
                                child: const Text('Edit Task')),
                            const SizedBox(width: 20), //whitespace
                            ElevatedButton(
                                onPressed: (() {
                                  taskItem.resetTimer();
                                  edited = true;
                                  Navigator.of(context).pop();
                                }),
                                child: const Text('Reset Timer'))
                          ],
                        )
                      ]),
                ),
              ]);
        });
    return edited;
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
              _removeTask(taskItem);
              notifyListeners();
              for (int i = 0; i < 2; i++) {
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
  Future<void> confirmCompletion(BuildContext context,
      {required TaskItem taskItem}) async {
    String taskName = taskItem.name;
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Complete Task'),
        content: Text('Mark "$taskName" as completed?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              String taskName = taskItem.name;
              String completionString;
              //Update message shown depending on if task is late or not
              if (DateTime.now().compareTo(taskItem.dueDate) < 0) {
                completionString = '"$taskName" completed!';
                _tasksOnTime++;
              } else {
                completionString = '"$taskName" completed late.';
              }
              _tasksCompleted++;
              _removeTask(taskItem);
              notifyListeners();
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(completionString)));
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  ///Opens a date picker and return user's selection (or null if canceled)
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

    //Ensure hour and minute are inputted correctly
    if (hour == null || minute == null) {
      return null;
    }

    if (hour < 1 || hour > 12 || minute > 59) {
      return null;
    }

    //Convert to military time
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
    //Change hour to non-military time
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

    String formattedMin = currMin.toString().padLeft(2, '0');

    formattedTime = '$currHour:$formattedMin $currAmOrPm';
    return formattedTime;
  }

  ///Opens pop up menu to either add or edit a task. If called to edit a task,
  ///taskItem must not be null
  Future<void> openTaskMenu(BuildContext context,
      {required TaskMenu type,
      required TaskModel taskModel,
      TaskItem? taskItem}) async {
    if (type == TaskMenu.edit && taskItem == null) {
      throw ArgumentError(
          "Edit menu was called without providing the task item to be edited.");
    }
    final formKey = GlobalKey<FormState>();
    String header, actionLabel;
    String? currTaskName, currTaskDescription, timeShown;
    int? currPriorityLevel;
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
      //Initialize fields to display on form
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
                                validator: (text) {
                                  if (text!.isEmpty) {
                                    return 'The task must be given a name.';
                                  } else if (text.length > 60) {
                                    return 'Task name can be at most 60 characters long.';
                                  }
                                  return null;
                                },
                                onSaved: (text) => currTaskName = text,
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
                                onSaved: (text) => currTaskDescription = text,
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
                                        //If editing, show current priority or
                                        //"high" priority if task is overdue.
                                        //Else, null
                                        value: currPriorityLevel != null
                                            ? (currPriorityLevel! < 3
                                                ? currPriorityLevel
                                                : 2)
                                            : null,
                                        onChanged: (int? newValue) {
                                          currPriorityLevel = newValue!;
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
                                          hintText: 'Hour:Minutes AM/PM'),
                                      initialValue: timeShown,
                                      validator: (text) {
                                        TimeOfDay? timeInput =
                                            _stringToTime(text!);
                                        if (timeInput == null) {
                                          return 'Please enter time in the\nform Hours:Minutes am/pm';
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
                                    addTask(taskModel,
                                        name: currTaskName!,
                                        description: currTaskDescription,
                                        priority: currPriorityLevel!,
                                        dueDate: currDueDate!);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Task added.')));
                                    syncChanges();
                                  } else {
                                    taskItem!.name = currTaskName!;
                                    taskItem.description = currTaskDescription!;
                                    //If user did not modify priority level when overdue
                                    //but changed due date, set to regular high priority
                                    if (DateTime.now().compareTo(currDueDate!) <
                                            0 &&
                                        currPriorityLevel == 3) {
                                      currPriorityLevel = 2;
                                    }
                                    taskItem.priority = currPriorityLevel!;
                                    taskItem.dueDate = currDueDate!;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('Task edited.')));
                                  }
                                  notifyListeners();
                                  Navigator.pop(context);
                                  syncChanges();
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

  ///Opens a menu providing instructions regarding app usage
  Future<void> openHelpMenu(BuildContext context,
      {required TaskModel taskModel, TaskItem? taskItem}) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            insetPadding: const EdgeInsets.fromLTRB(16, 50, 16, 60),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new)),
                      Text(
                        "Help",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text('Creating a task'),
                    children: [
                      ListTile(
                          visualDensity: const VisualDensity(vertical: 4),
                          title: const Text(
                              "Use the '+' icon in the bottom right corner to add a new task"),
                          trailing: Image.asset(
                              'lib/src/assets/images/addButton.png')),
                      const Padding(padding: EdgeInsets.all(5)),
                      ListTile(
                          visualDensity: const VisualDensity(vertical: 4),
                          title: const Text(
                              "Give your task a name and optional description"),
                          leading: Image.asset(
                              'lib/src/assets/images/taskName.png')),
                      const Padding(padding: EdgeInsets.all(5)),
                      ListTile(
                          visualDensity: const VisualDensity(vertical: 4),
                          title: const Text(
                              "Use the drop-down menu to assign a priority level"),
                          trailing: Image.asset(
                              'lib/src/assets/images/priority.png')),
                      const Padding(padding: EdgeInsets.all(5)),
                      ListTile(
                          visualDensity: const VisualDensity(vertical: 4),
                          title: const Text(
                              "Tap on the due date box to select a date, then input the time of day you want it due, or manually input the date and time"),
                          leading: Image.asset(
                              'lib/src/assets/images/calendar.png')),
                      ListTile(
                          visualDensity: const VisualDensity(vertical: 4),
                          title: const Text(
                              "Tap 'Create Task' and your task will now be displayed on the main page"),
                          trailing:
                              Image.asset('lib/src/assets/images/tasks.png')),
                      const ListTile(
                        visualDensity: VisualDensity(vertical: 4),
                        title: Text(
                            "Darker color indicates higher priority level. Overdue tasks will appear red"),
                      )
                    ],
                  ),
                  ExpansionTile(
                    title: const Text('Editing and deleting tasks'),
                    children: [
                      ListTile(
                          visualDensity: const VisualDensity(vertical: 4),
                          title: const Text("Tap on the task you want to edit"),
                          trailing: Image.asset(
                              'lib/src/assets/images/taskToEdit.png')),
                      ListTile(
                          visualDensity: const VisualDensity(vertical: 4),
                          title: const Text("Tap the 'Edit Task' button"),
                          leading: Image.asset(
                              'lib/src/assets/images/editButton.png')),
                      ListTile(
                          visualDensity: const VisualDensity(vertical: 4),
                          title: const Text(
                              "If you wish to delete the task, tap on the trash can icon"),
                          trailing:
                              Image.asset('lib/src/assets/images/delete.png')),
                      ListTile(
                          visualDensity: const VisualDensity(vertical: 4),
                          title: const Text(
                              "Once you've made your desired changes, tap on 'Save Changes'"),
                          leading: Image.asset(
                              'lib/src/assets/images/saveButton.png')),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text('Completing a task'),
                    children: [
                      ListTile(
                          visualDensity: const VisualDensity(vertical: 4),
                          title: const Text(
                              "Select the checkbox of the task you are finished with"),
                          trailing: Image.asset(
                              'lib/src/assets/images/finishedTask.png')),
                      ListTile(
                          visualDensity: const VisualDensity(vertical: 4),
                          title: const Text(
                              "Once prompted, tap 'OK' to complete your task and it will be removed from the list"),
                          leading: Image.asset(
                              'lib/src/assets/images/completeTask.png')),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text('Using the timer'),
                    children: [
                      ListTile(
                          visualDensity: const VisualDensity(vertical: 4),
                          title: const Text(
                              "To begin timing your task, tap on the play/pause button next to the timer.\nTo pause the timer, tap the button again"),
                          trailing: Image.asset(
                              'lib/src/assets/images/playbutton.png')),
                      ListTile(
                          visualDensity: const VisualDensity(vertical: 4),
                          title: const Text(
                              "To reset the timer, open up the edit menu, then tap on 'Reset Timer'"),
                          leading:
                              Image.asset('lib/src/assets/images/reset.png')),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text('Sorting tasks'),
                    children: [
                      ListTile(
                          visualDensity: const VisualDensity(vertical: 4),
                          title: const Text(
                              "To change the way your tasks are sorted, tap on the menu icon on the top right, then select your preferred sorting method"),
                          trailing:
                              Image.asset('lib/src/assets/images/sort.png')),
                      const ListTile(
                          visualDensity: VisualDensity(vertical: 4),
                          title: Text(
                              "Tasks can be sorted alphabetically, by due date, or by priority level"))
                    ],
                  ),
                ],
              )
            ],
          );
        });
  }
}
