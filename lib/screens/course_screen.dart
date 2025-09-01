import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grade_calculator/model/assignment.dart';
import 'package:grade_calculator/widgets/assignment_item.dart';
import '../model/course.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/grade_converter.dart';

class CourseScreen extends StatefulWidget {
  final Course course;
  const CourseScreen({super.key, required this.course});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _markController = TextEditingController();
  final _maxMarkController = TextEditingController();
  late List<Assignment> assignmentList;

  @override
  void initState() {
    assignmentList = widget.course.assignments;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context, widget.course);
        }
        
      },
      child: Scaffold(
        appBar: buildAppBar(),
        body: buildAssignmentList(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: widget.course.color,
      centerTitle: true,
      title: Row(
        children: [
          Spacer(),
          Text(
            widget.course.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            )
          ),
          Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                addGrade();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(20,20),
                elevation: 5,
              ),
              child: Text('+', style: TextStyle(fontSize: 20))
            )
          )
        ]
      )
    );
  }

  Widget buildAverages() {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 2
                  ),
                  left: BorderSide(
                    color: Colors.grey,
                    width: 2
                  ),
                  right: BorderSide(
                    color: Colors.grey,
                    width: 2
                  )
                )
              ),
              child: Text(
                '${widget.course.grade}%',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )
              )
            ),
          ),
           Expanded(
             child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 2
                  ),
                  right: BorderSide(
                    color: Colors.grey,
                    width: 2
                  )
                )
              ),
              child: Text(
                '${convertFourPoint(widget.course.grade)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )
              )
                     ),
           ),
           Expanded(
             child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 2,
                  ),
                )
              ),
              child: Text(
                '${convertTwelvePoint(widget.course.grade)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )
              )
                     ),
           ),
        ]
      ),
    );
  }

  Widget buildAssignmentList() {
    return ListView(
      children: [
        buildAverages(),
        for (Assignment assignment in assignmentList) 
          AssignmentItem(assignment: assignment),
      ],
    );
  }

  Future addGrade() {
    return showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: const Text('Add New Mark')
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter the Assessment Name'
                ),
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  hintText: 'Enter the Percentage Weight'
                ),
                controller: _weightController,
              ),
              const SizedBox(height: 16),
              TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  hintText: 'Enter Your Mark'
                ),
                controller: _markController,
              ),
              const SizedBox(height: 16),
              TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  hintText: 'Enter the Max Marks'
                ),
                controller: _maxMarkController,
              ),
            ],
          ),
          actions: [
            TextButton(
                child: Text('Add Mark'),
                onPressed: () {
                  String name = _nameController.text;
                  String weight = _weightController.text;
                  String mark = _markController.text;
                  String maxMark = _maxMarkController.text;

                  if (name.isNotEmpty && weight.isNotEmpty && mark.isNotEmpty && maxMark.isNotEmpty) {
                    setState(() {
                      assignmentList.add(Assignment(id:DateTime.now().millisecondsSinceEpoch.toString(), 
                      name: name, 
                      weight: int.parse(weight),
                      mark: int.parse(mark), 
                      maxMark: int.parse(maxMark)));
                    });
                    widget.course.assignments = assignmentList;
                    _saveAssignments();
                    _nameController.clear();
                    _weightController.clear();
                    _markController.clear();
                    _maxMarkController.clear();
                  }
                },
              ),         
            ]
        );
      }
    );
  }

  void _saveAssignments() async{
    final sharedPreferences = await SharedPreferences.getInstance();
    List<String> courseStrings = sharedPreferences.getStringList('courses') ?? [];
    List<Course> courseList = courseStrings.map((courseString) => Course.fromMap(jsonDecode(courseString))).toList();
    int index = courseList.indexWhere((course) => course.id == widget.course.id);
    courseList[index] = widget.course;
    await sharedPreferences.setStringList(
      'courses', courseList.map((c) => jsonEncode(c.toMap())).toList()
    );
  }
}