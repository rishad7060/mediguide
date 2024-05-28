import 'package:flutter/material.dart';
import 'package:medical/helpers/db_helper.dart';
import 'package:medical/model/Medicine.dart';

class MedicineProviderLocal extends ChangeNotifier {
  List<Medicine> _medicine = [];
  List<Medicine> _allMedicine = [];

  List<Medicine> get medicine {
    return [..._medicine];
  }

  Future<void> getMedicineFromLocal() async {
    var result = await DBHelper.getAll('Medicines');
    _medicine = Medicine.fromSnapshot(result);
    _allMedicine = _medicine;
    print('===========');
    print(_allMedicine);
    notifyListeners();
  }

  void searchProduct(String q) {
    _medicine = _allMedicine.where((element) {
      return element.name!.toLowerCase().contains(q.toLowerCase());
    }).toList();
    notifyListeners();
  }

  Future<void> insertMedicine(Medicine medicine) async {
    Map<String, dynamic> data = {
      'name': medicine.name,
      'form': medicine.form,
      'frequency': medicine.frequency,
      'date': medicine.days,
      'time': medicine.time,
    };

    await DBHelper.insert('Medicines', data);
    await getMedicineFromLocal(); // Refresh the list
  }

  Future<void> deleteMedicine(String id) async {
    await DBHelper.delete('Medicines', 'id_local=?', [id]);
    await getMedicineFromLocal(); // Refresh the list
  }

  Future<void> updateMedicine(Medicine medicine) async {
    Map<String, dynamic> data = {
      'name': medicine.name,
      'form': medicine.form,
      'frequency': medicine.frequency,
      'time': medicine.time,
    };

    if (medicine.frequency != 'Everyday') {
      data['date'] = medicine.days;
    } else {
      data['date'] = 'Mon, Tue, Wed, Thu, Fri, Sat, Sun,';
    }

    if (data['date'] == 'Mon, Tue, Wed, Thu, Fri, Sat, Sun,' ||
        data['date'] == 'Mon, Tue, Wed, Thu, Fri, Sat, Sun') {
      medicine.frequency == 'Everyday';
    }

    await DBHelper.update('Medicines', 'id_local=?', [medicine.id], data);
    await getMedicineFromLocal(); // Refresh the list
  }
}
