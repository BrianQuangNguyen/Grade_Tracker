import 'package:flutter/material.dart';
import '../model/assignment.dart';

class AssignmentItem extends StatelessWidget {
  final Assignment assignment;
  const AssignmentItem({
    super.key,
    required this.assignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom : BorderSide(
            color: Colors.grey,
            width: 2,
          )
        )
      ),
      child: ListTile(
          title: Text(
            assignment.name,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            "${assignment.grade}%",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )
          ),
          trailing: Text(
            "${assignment.mark} / ${assignment.maxMark}",
            style: TextStyle(
              fontSize: 24            
            )
          ),
      ),
    );
  }
}
