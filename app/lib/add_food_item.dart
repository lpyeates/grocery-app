import 'package:flutter/material.dart';

class AddTodoDialog extends StatelessWidget {
  final todoController = TextEditingController();

  @override
  Widget build(context){
    return AlertDialog(
      title: Text('Add a new Todo'),
      content: TextField(
        controller: todoController,
        decoration: InputDecoration.collapsed(
          hintText: "What do you need to do?",
          border: UnderlineInputBorder(),
        ),
      ),
      actions: [
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
        ),
        RaisedButton(
          child: Text('Add'),
          onPressed: () {
            Navigator.of(context).pop(todoController.text);
          },
          color: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}