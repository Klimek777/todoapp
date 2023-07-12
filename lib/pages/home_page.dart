// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/datalocal/localdb.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//open box

  final _box = Hive.box('todo');
  ToDoDB db = new ToDoDB();

  double? _deviceHeight, _deviceWidth;

  void checkCheckbox(bool? value, int index) {
    setState(() {
      db.toDoList[index][2] = !db.toDoList[index][2];
    });
    db.updateList();
  }

  void deleteItem(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateList();
  }

  @override
  void initState() {
    db.loadList();
    print(db.toDoList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    int totalTasks = db.getTotalTasks();
    int completedTasks = db.getCompletedTasks();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          toolbarHeight: 0,
        ),
        body: Container(
          width: _deviceWidth,
          height: _deviceHeight,
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: _pageHeadWidget(totalTasks, completedTasks),
              ),
              Container(
                  width: _deviceWidth! * 0.9,
                  height: _deviceHeight! * 0.4718,
                  child: totalTasks == 0 ? _emptyListTile() : _toDoListTile())
            ],
          ),
        ));
  }

  Widget _pageHeadWidget(int totalTasks, int completedTasks) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: _deviceWidth,
          height: _deviceHeight! * 0.40,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(60),
              bottomRight: Radius.circular(60),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 50, 0, 0),
                      child: Text(
                        'Daily \nTasks ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 45,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                      child: _taskCountWidget(totalTasks, completedTasks),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: -40,
          child: Center(child: _addTaskWidget()),
        ),
      ],
    );
  }

  Widget _addTaskWidget() {
    return MaterialButton(
      onPressed: () {
        Navigator.pushNamed(context, 'create').then((_) => setState(() {}));
      },
      child: Container(
        height: _deviceHeight! * 0.1,
        width: _deviceHeight! * 0.1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          color: Colors.grey[200],
        ),
        child: Center(
            child: Icon(
          Icons.add,
          size: 35,
        )),
      ),
    );
  }

  Widget _taskCountWidget(int totalTasks, int completedTasks) {
    return Column(
      children: [
        Text(
          '$completedTasks / $totalTasks',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
          ),
        ),
        Text(
          'tasks',
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.w200),
        )
      ],
    );
  }

  Widget _todoWidget(
      String title, String? description, bool status, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SizedBox(
              width: 10,
            ),
            SlidableAction(
                icon: Icons.delete,
                label: 'delete',
                backgroundColor: status ? Colors.grey[400]! : Colors.black,
                borderRadius: BorderRadius.circular(30),
                onPressed: (context) => deleteItem(index)),
          ],
        ),
        child: Container(
          height: 70,
          width: _deviceWidth! * 0.9,
          decoration: BoxDecoration(
            color: status ? Colors.grey[400]! : Colors.black,
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Transform.scale(
                  scale: 1.9,
                  child: Checkbox(
                    shape: CircleBorder(),
                    hoverColor: Colors.white,
                    activeColor: Colors.white,
                    focusColor: Colors.white,
                    fillColor: MaterialStateProperty.all(Colors.white),
                    value: status,
                    onChanged: (value) => checkCheckbox(value, index),
                    checkColor: Colors.black,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  RichText(
                    maxLines: 4,
                    text: TextSpan(
                      text: description!,
                    ),
                    // Text(description!,
                    // style:
                    //     TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _toDoListTile() {
    return ListView.builder(
      itemCount: db.toDoList.length,
      itemBuilder: (context, index) {
        return _todoWidget(db.toDoList[index][0], db.toDoList[index][1],
            db.toDoList[index][2], index);
      },
    );
  }

  Widget _emptyListTile() {
    return Column(
      children: [
        Text(
          "All DONE!",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        Text(
          'Add some new tasks',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
        )
      ],
    );
  }
}
