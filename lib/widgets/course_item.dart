import 'package:flutter/material.dart';
import 'package:grade_calculator/screens/course_screen.dart';
import '../model/course.dart';

class CourseItem extends StatefulWidget {
  final Course course;
  final Function(Course)? onCourseUpdated;
  final bool isEditing;
  final bool isSelected;
  final Function(bool)? onSelected;

  const CourseItem({
    super.key,
    required this.course,
    this.onCourseUpdated,
    this.isEditing = false,
    this.isSelected = false,
    this.onSelected,
  });

  @override
  State<CourseItem> createState() => _CourseItemState();
}

class _CourseItemState extends State<CourseItem> {
  late Course currentCourse;

  @override
  void initState() {
    currentCourse = widget.course;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () async{
          if (widget.isEditing) {
            widget.onSelected?.call(!widget.isSelected);
          } else {
            final updatedCourse = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CourseScreen(course: currentCourse))
            );
           if (updatedCourse != null) {
            setState(() {
              currentCourse = updatedCourse;
            });
            widget.onCourseUpdated?.call(updatedCourse);
          }
          }
          
        },
        tileColor: currentCourse.color,
        title: Text(
          currentCourse.name,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "${currentCourse.grade}%",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )
        ),
        trailing: widget.isEditing 
          ? Checkbox(
            value: (widget.isSelected),
            onChanged: (selected) {
              widget.onSelected?.call(selected ?? false);
            },
        )
        : null
    );
  }
}
