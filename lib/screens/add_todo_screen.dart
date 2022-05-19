import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_one/boxes.dart';
import '../model/todo.dart';
import 'package:intl/intl.dart';

class AddTodoScreen extends StatefulWidget {
  AddTodoScreen({Key? key}) : super(key: key);

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _date = DateTime.now();
  late String title;
  late String description;
  TextEditingController _dateController = TextEditingController();
  DateFormat _dateFormatter = DateFormat("dd MMM,yyyy hh:mm a");
  TextEditingController _timeController = TextEditingController();
  validated() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _onFormSubmit();
      print("Form Validated");
    } else {
      print("Form Not Validated");
      return;
    }
  }

  _pickTime() => showTimePicker(context: context, initialTime: _selectedTime);
  _pickDate() => showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );

  _pickDateTime() async {
    DateTime? date = await _pickDate();
    if (date == null) {
      return;
    }
    TimeOfDay? time = await _pickTime();
    if (time == null) {
      return;
    }
    final DateTime dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    if (dateTime != null && dateTime != _date) {
      setState(() {
        _date = dateTime;
      });
    }
    _dateController.text = _dateFormatter.format(_date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autofocus: true,
                    initialValue: '',
                    decoration: const InputDecoration(labelText: 'Task'),
                    onChanged: (value) {
                      setState(() {
                        title = value;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "required";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: '',
                    decoration: const InputDecoration(
                      labelText: 'Note',
                    ),
                    onChanged: (value) {
                      setState(() {
                        description = value;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return "required";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 18.0),
                    controller: _dateController,
                    autofocus: false,
                    decoration: InputDecoration(
                        labelText: 'Date and Time',
                        labelStyle: const TextStyle(fontSize: 18.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                    onTap: () => _pickDateTime(),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: TextFormField(
                //     style: const TextStyle(fontSize: 18.0),
                //     controller: _timeController,
                //     autofocus: false,
                //     decoration: InputDecoration(
                //         labelText: 'Time',
                //         labelStyle: TextStyle(fontSize: 18.0),
                //         border: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(10.0))),
                //     onTap: () => _selectTime(context),
                //   ),
                // ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.purple,
                      minimumSize: Size(150, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: Colors.deepPurple)),
                    ),
                    onPressed: () {
                      validated();
                    },
                    child: Text("Add  Todo",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onFormSubmit() {
    Box<Todo> todoBox = Hive.box<Todo>(HiveBoxes.todo);
    todoBox.add(Todo(
      title: title,
      description: description,
      date: _date,
    ));
    Navigator.of(context).pop();
    print(todoBox.values);
  }
}
