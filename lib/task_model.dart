import 'package:flutter/material.dart';
import 'task_item.dart';
import 'package:final_project/src/custom_widgets.dart';

class TaskModel extends ChangeNotifier {
  final _taskList = <TaskItem>[
    TaskItem(name: 'Task 1', description: 'Task description', priority: 0),
    TaskItem(name: 'Task 2', description: 'Task description', priority: 1),
    TaskItem(name: 'Zebra Task', description: 'Task description', priority: 2),
    TaskItem(name: 'Task 4', description: 'Task description', priority: 1),
    TaskItem(name: 'Alpha Task', description: 'Task description', priority: 0),
    TaskItem(name: 'Task 6', description: 'Task description', priority: 1),
    TaskItem(name: 'Task 7', description: 'Task description', priority: 2),
    TaskItem(name: 'Beta Task', description: 'Task description', priority: 1),
    TaskItem(name: 'Task 9', description: 'Task description', priority: 0),
    TaskItem(name: 'Task 10', description: 'Task description', priority: 1)
  ];
  List<DropdownMenuItem<int>> priorityLevels = [
    const DropdownMenuItem(value: 0, child: Text("Low")),
    const DropdownMenuItem(value: 1, child: Text("Medium")),
    const DropdownMenuItem(value: 2, child: Text("High")),
  ];
  final _formKey = GlobalKey<FormState>();

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

  ///Sorts by priority
  void sortByPriority() {
    _taskList.sort((a, b) => b.priority.compareTo(a.priority));
    notifyListeners();
  }

  ///Sorts by due date (TODO)
  void sortByDue() {
    //_taskList.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
    notifyListeners();
  }

  ///Sorts by name
  void sortByName() {
    _taskList.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  ///Adds a task and removes popup menu
  void _addTask(BuildContext context,
      {required String name, String? description, required int priority}) {
    _taskList.add(TaskItem(
      name: name,
      description: description,
      priority: priority,
    ));
    Navigator.of(context).pop();
    notifyListeners();
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
                          Text('Do by: <date>',
                              style: Theme.of(context).textTheme.titleLarge),
                          const Text('(timer)', style: TextStyle(fontSize: 36))
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
              notifyListeners();
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  ///Opens pop up menu to either add or edit a task. If called to edit a task,
  ///taskItem must not be null
  Future<void> openTaskMenu(BuildContext context,
      {required TaskMenu type, TaskItem? taskItem}) async {
    if (type == TaskMenu.edit && taskItem == null) {
      throw ArgumentError(
          "Edit menu was called without providing the task item to be edited.");
    }

    String header, actionLabel;
    String? newTaskName, newTaskDescription, currTaskName, currTaskDescription;
    int? newPriorityLevel, currPriorityLevel;

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
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Task name',
                                ),
                                //If editing, show current name (else empty)
                                initialValue: currTaskName,
                                validator: (text) => text!.isEmpty
                                    ? 'You must give the task a name.'
                                    : null,
                                onChanged: (text) => newTaskName = text,
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
                                onChanged: (text) => newTaskDescription = text,
                              ),
                              const SizedBox(height: 15), //whitespace
                              DropdownButtonFormField<int>(
                                hint: const Text('Priority level'),
                                items: priorityLevels,
                                validator: (value) => value == null
                                    ? 'Please set a valid priority level for this task.'
                                    : null,
                                //If editing...else empty
                                value: currPriorityLevel,
                                onChanged: (int? newValue) {
                                  newPriorityLevel = newValue!;
                                },
                              ),
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
                                if (_formKey.currentState!.validate()) {
                                  if (type == TaskMenu.add) {
                                    _addTask(context,
                                        name: newTaskName!,
                                        description: newTaskDescription,
                                        priority: newPriorityLevel!);
                                  } else {
                                    taskItem!.name =
                                        newTaskName ?? currTaskName!;
                                    taskItem.description = newTaskDescription ??
                                        currTaskDescription!;
                                    taskItem.priority =
                                        newPriorityLevel ?? currPriorityLevel!;
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
