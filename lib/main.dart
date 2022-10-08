import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';

void main() {
  runApp(const MyApp1());
}

class MyApp1 extends StatelessWidget {
  const MyApp1({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "To do List",
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Activity> activities = [
    Activity("Take a shit", DateTime.now(), true),
    Activity("Lick Balls", DateTime.now(), false),
    Activity("68 your mom", DateTime(2022, 10, 24, 23, 58, 60), true),
    Activity("become finger", DateTime(2024, 4, 12, 1, 23, 45, 67), false)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text("To Do List"),
        ),
        body: activities.isEmpty
            ? const Center(child: Text('No tasks have been added'))
            : ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, bottom: 20.0, right: 16.0, left: 16.0),
                    child: Stack(children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 100),
                              child: Text(
                                activities[index].name,
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 100),
                              child: Text(
                                "To be completed by ${activities[index].date.hour}:${activities[index].date.minute} on ${activities[index].date.day}/${activities[index].date.month}/${activities[index].date.year}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ]),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  var tempIndex = index;
                                  var tempData = activities[index];
                                  var snackBar = SnackBar(
                                      backgroundColor: Colors.green,
                                      duration: const Duration(seconds: 1),
                                      content: Text(
                                          'Yay! You have successfuly completed the task : ${activities[index].name} 🎉🎉'),
                                      action: SnackBarAction(
                                        label: 'Undo',
                                        onPressed: () {
                                          setState(() {
                                            activities.insert(
                                                tempIndex, tempData);
                                          });
                                        },
                                      ));
                                  setState(() {
                                    activities.removeAt(index);
                                  });
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: const Text("Completed"),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  var tempIndex = index;
                                  var tempData = activities[index];
                                  var snackBar = SnackBar(
                                      backgroundColor: Colors.red,
                                      duration: const Duration(seconds: 1),
                                      content: Text(
                                          'You have successfuly deleted the task : ${activities[index].name}'),
                                      action: SnackBarAction(
                                        label: 'Undo',
                                        onPressed: () {
                                          setState(() {
                                            activities.insert(
                                                tempIndex, tempData);
                                          });
                                        },
                                      ));
                                  setState(() {
                                    activities.removeAt(index);
                                  });
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text("Delete"),
                              )
                            ],
                          ))
                    ]),
                  ));
                }),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              _navigateAndDisplaySelection(context);
            }));
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTask()),
    );
    if (result != null) {
      setState(() {
        activities.add(result);
      });
      var snackBar = const SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
        content: Text('Successfully added new task'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

class Activity {
  String name;
  DateTime date;
  bool notif;
  Activity(this.name, this.date, this.notif);
}

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTask();
}

class _AddTask extends State<AddTask> {
  final formKey = GlobalKey<FormState>();
  String taskname = "";
  late DateTime date;
  bool notif = false;
  bool datepick = false;
  late DateTime reminddate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Add a new task"),
      ),
      body: Form(
          key: formKey,
          child: ListView(padding: const EdgeInsets.all(16), children: [
            buildTaskName(),
            const SizedBox(height: 16),
            buildDate(),
            const SizedBox(height: 16),
            datepick
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildCheckbox(),
                      const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: (Text("Set Notification")))
                    ],
                  )
                : Container(),
            notif ? const SizedBox(height: 16) : Container(),
            notif ? buildDateforReminder() : Container(),
            const SizedBox(height: 16),
            buildSubmit(),
          ])),
    );
  }

  Widget buildTaskName() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Task Name',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Cannot be empty';
          } else {
            return null;
          }
        },
        maxLength: 30,
        onSaved: (value) => setState(() => taskname = value!),
      );

  Widget buildDate() => DateTimeFormField(
        decoration: const InputDecoration(
          hintStyle: TextStyle(color: Colors.black45),
          errorStyle: TextStyle(color: Colors.redAccent),
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.event_note),
          labelText: 'Pick date and time',
        ),
        firstDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        mode: DateTimeFieldPickerMode.dateAndTime,
        autovalidateMode: AutovalidateMode.disabled,
        validator: (e) {
          if (e == null) {
            return 'Cannot be empty';
          } else {
            return null;
          }
        },
        onDateSelected: (DateTime value) {
          setState(() {
            date = value;
            datepick = !datepick;
          });
        },
      );
  Widget buildDateforReminder() => DateTimeFormField(
        decoration: const InputDecoration(
          hintStyle: TextStyle(color: Colors.black45),
          errorStyle: TextStyle(color: Colors.redAccent),
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.event_note),
          labelText: 'Pick date and time to be reminded',
        ),
        firstDate: DateTime.now(),
        lastDate: date,
        mode: DateTimeFieldPickerMode.dateAndTime,
        autovalidateMode: AutovalidateMode.disabled,
        validator: (value) {
          if (value == null) return 'Cannot be empty';
          return null;
        },
      );

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  Widget buildCheckbox() => Checkbox(
        checkColor: Colors.white,
        fillColor: MaterialStateProperty.resolveWith(getColor),
        value: notif,
        onChanged: (bool? value) {
          setState(() {
            notif = value!;
          });
        },
      );
  Widget buildSubmit() => Builder(
        builder: (context) => ElevatedButton(
          child: (const Text('Submit')),
          onPressed: () {
            final isValid = formKey.currentState?.validate();
            if (isValid ?? false) {
              formKey.currentState?.save();
              Activity data = Activity(taskname, date, notif);
              Navigator.pop(context, data);
            }
          },
        ),
      );
}
