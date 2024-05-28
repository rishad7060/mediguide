import 'dart:convert';
import 'dart:io';

import 'package:medical/model/Medicine.dart';
import 'package:path_provider/path_provider.dart';

class MedicineStorage {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/medicines.json');
  }

  static Future<void> writeMedicines(List<Medicine> medicines) async {
    final file = await _localFile;
    final jsonData = jsonEncode(medicines.map((medicine) => medicine).toList());
    await file.writeAsString(jsonData);
  }

  static Future<List<Medicine>> readMedicines() async {
    try {
      final file = await _localFile;
      final jsonData = await file.readAsString();
      final List<dynamic> decodedData = jsonDecode(jsonData);
      return decodedData.map((item) => Medicine.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }
}
