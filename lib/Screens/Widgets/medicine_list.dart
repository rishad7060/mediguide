import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical/providers/medicine_provider_local.dart'; // Adjust the import path as necessary
import 'medicine_item.dart'; // Adjust the import path as necessary

class MedicineList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicineProvider = Provider.of<MedicineProviderLocal>(context);
    final medicines = medicineProvider.medicine;

    return ListView.builder(
      shrinkWrap: true, // This is important for nested ListView
      physics:
          NeverScrollableScrollPhysics(), // Disable scrolling inside ListView
      itemCount: medicines.length,
      itemBuilder: (ctx, i) => MedicineItem(
        medicine: medicines[i],
        onDelete: () async {
          await medicineProvider.deleteMedicine(medicines[i].id!.toString());
        },
      ),
    );
  }
}
