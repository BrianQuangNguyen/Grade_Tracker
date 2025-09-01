import 'package:flutter/material.dart';
import 'package:grade_calculator/utils/colors.dart';
import 'package:grade_calculator/widgets/course_item.dart';
import '../model/course.dart';
import '../widgets/color_drop_down.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _nameController = TextEditingController();
  String? selectedColorName;
  List<Course> courseList = [];
  List<String> selectedCoursesId = [];
  bool _isEditing = false;


  @override
  void initState() {
    _loadCourses();
    super.initState();
  }
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildCourseList(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
    backgroundColor: Colors.deepOrangeAccent,
    leading: IconButton(
      icon: Icon(_isEditing ? Icons.close : Icons.delete, color: Colors.white),
      onPressed: () {
        setState(() {
          _isEditing = !_isEditing;
          selectedCoursesId.clear();
        });
      },
    ),
    title: const Text(
      'Courses',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
    ),
    centerTitle: true, 
    actions: [
      if (!_isEditing) 
        TextButton(
        onPressed: () {
          addCourse();
        },
        child: const Text(
          '+',
          style: TextStyle(
            fontSize: 32,
            color: Colors.white, 
            fontWeight: FontWeight.bold,
          ),
        ),
      )
      else if (_isEditing)
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            setState(() {
              courseList.removeWhere((course) => selectedCoursesId.contains(course.id));
              selectedCoursesId.clear();
              _saveCourses();
              _isEditing = false;
            });
          }    
        )
    ],
  );
}

  Widget buildCourseList() {
    return ListView(
      children: [
        for (Course course in courseList) 
          CourseItem(
            course: course,
            onCourseUpdated: (updatedCourse) {
              int index = courseList.indexWhere((c) => c.id == updatedCourse.id);
              courseList[index] = updatedCourse;
            },
            isEditing: _isEditing,
            isSelected: selectedCoursesId.contains(course.id),
            onSelected: (selected) {

              setState(() {
                if (selected) {
                selectedCoursesId.add(course.id);
              } else {
                selectedCoursesId.remove(course.id);
              }
              });
            }
          ),
      ],
    );
  }

  
  Future addCourse() {
    return showDialog(
      context:context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: const Text('Add New Course')
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter The Course Name'
                ),
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              ColorDropDown(
                onColorSelected: (colorName) {
                  selectedColorName = colorName;
                  }
              ),
            ],
          ),
          actions: [
              TextButton(
                child: const Text('Add Course'),
                onPressed: () {
                  String courseName = _nameController.text;
                  if (courseName.isNotEmpty) {
                    setState(() {
                      courseList.add(Course(id:DateTime.now().millisecondsSinceEpoch.toString(), 
                      name: courseName, 
                      color: colorOptions[selectedColorName] ?? Colors.red));
                      _saveCourses();
                    });
                    selectedColorName = "Red";
                    _nameController.clear();
                  }
                },
              ),           
            ]
        );
      }
    );
  }

  void _saveCourses() async{
    final sharedPreferences = await SharedPreferences.getInstance();
    List<String> courseStrings = courseList.map((course) => jsonEncode(course.toMap())).toList();
    await sharedPreferences.setStringList('courses', courseStrings);
  }

  void _loadCourses() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    List<String>? courseStrings = sharedPreferences.getStringList('courses');
    if (courseStrings != null) {
      setState(() {
        courseList = courseStrings.map((courseString) => Course.fromMap(jsonDecode(courseString))).toList();
      });
    }
  }
}

