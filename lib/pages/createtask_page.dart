// ignore_for_file: unused_field, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../datalocal/localdb.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  double? _deviceHeight, _deviceWidth;
  String? _title;
  String? _description;
  final GlobalKey<FormState> _newtaskFormKey = GlobalKey<FormState>();
  final _box = Hive.box('todo');

  ToDoDB db = ToDoDB();

  @override
  void initState() {
    db.loadList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 0,
        ),
        body: SafeArea(
          child: Container(
            width: _deviceWidth,
            height: _deviceHeight,
            color: Colors.white,
            child: Column(
              children: [
                _headWidget(),
                SizedBox(
                  height: _deviceHeight! * 0.08,
                ),
                _newtaskForm(),
              ],
            ),
          ),
        ));
  }

  Widget _headWidget() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    size: 40,
                  )),
            ],
          ),
          Row(
            children: [
              Text('New Task',
                  style: GoogleFonts.kanit(
                      fontSize: 40, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _newtaskForm() {
    return SizedBox(
      width: _deviceWidth! * 0.8,
      child: Form(
        key: _newtaskFormKey,
        child: Column(
          children: [
            _titleTextField(),
            _descriptionTextField(),
            _createButton(),
          ],
        ),
      ),
    );
  }

  Widget _titleTextField() {
    return Padding(
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: TextFormField(
        maxLength: 25,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          hintStyle: GoogleFonts.kanit(),
          counterText: "",
          hintText: "Title...",
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.grey),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
        onSaved: (_value) {
          setState(() {
            _title = _value;
          });
        },
        validator: (_value) {
          bool _result = _value!.isEmpty;
          return _result ? 'Please enter a task name' : null;
        },
      ),
    );
  }

  Widget _descriptionTextField() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10),
      child: TextFormField(
        maxLength: 30,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          hintStyle: GoogleFonts.kanit(),
          hintText: "Short description (optional)...",
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.grey),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
        onSaved: (_value) {
          setState(() {
            _description = _value;
          });
        },
      ),
    );
  }

  Widget _createButton() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onPressed: () => _createTask(),
        minWidth: _deviceWidth! * 0.70,
        height: _deviceHeight! * 0.06,
        color: Colors.black,
        child: Text(
          'Create Task',
          style: GoogleFonts.kanit(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _createTask() {
    if (_newtaskFormKey.currentState!.validate()) {
      _newtaskFormKey.currentState!.save();

      setState(() {
        db.toDoList.add([_title, _description, false]);
      });
      db.updateList();

      Navigator.pop(context);
    }
  }
}
