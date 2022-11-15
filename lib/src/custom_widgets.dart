//lol

/*
void _openTaskMenu(BuildContext context, {required TaskMenu type}) {
if (widget.taskModel.popUpMenu == null) {
      OverlayState overlayState = Overlay.of(context)!;
      String header;
      String actionLabel;
      if (type == TaskMenu.add) {
        header = 'Create New Task';
        actionLabel = 'Create Task';
      } else {
        header = 'Edit Task';
        actionLabel = 'Save Changes';
      }
      widget.taskModel.popUpMenu = OverlayEntry(
        builder: (context) {
          return Positioned(
              bottom: MediaQuery.of(context).size.height / 10,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  color: Theme.of(context).colorScheme.secondary,
                  child: taskMenuBody(context, header, type)));
        },
      );
      overlayState.insert(widget.taskModel.popUpMenu!);
    }
  }

  Padding taskMenuBody(BuildContext context, String header, TaskMenu type) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1,
          vertical: MediaQuery.of(context).size.height * 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Material(
                color: Theme.of(context).colorScheme.secondary,
                child: IconButton(
                    onPressed: (() => widget.taskModel.removePopUp()),
                    icon: Icon(Icons.arrow_back_ios_new)),
              ),
              Text(
                header,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (type == TaskMenu.edit)
                Material(
                  color: Theme.of(context).colorScheme.secondary,
                  child: IconButton(
                      onPressed: (() => print(newTaskName)), //test
                      icon: Icon(Icons.highlight_remove_outlined)),
                ),
            ],
          ),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  Material(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Task Name',
                      ),
                      validator: (text) => text!.isEmpty
                          ? 'You must give the task a name.'
                          : null,
                      onSaved: (text) => newTaskName = text!,
                    ),
                  ),
                  Material(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Task Description',
                      ),
                      validator: (text) => text!.length > 50
                          ? 'Description can be at most 50 characters long.'
                          : null,
                      onSaved: (text) => newTaskDescription = text!,
                    ),
                  ),
                  Material(
                    child: DropdownButtonFormField<int>(
                      items: priorityLevels,
                      value: priorityLevels.first.value,
                      onChanged: (int? newValue) {
                        setState(() {
                          newPriorityLevel = newValue!;
                        });
                      },
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}*/
