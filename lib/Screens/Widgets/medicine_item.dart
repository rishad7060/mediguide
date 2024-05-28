import 'package:flutter/material.dart';
import 'package:medical/model/Medicine.dart';

class MedicineItem extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback onDelete;

  const MedicineItem({required this.medicine, required this.onDelete, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(medicine.name ?? ''),
        subtitle: Text('Time: ${medicine.time ?? ''}'),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
