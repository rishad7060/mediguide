class Medicine {
  final String? id;
  final String? name;
  final String? form;
  final String? frequency;
  final String? days;
  final String? time;

  Medicine({
    this.id,
    this.name,
    this.form,
    this.frequency,
    this.days,
    this.time,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id_local'].toString(), // Ensure id is always a String
      name: json['name']?.toString(),
      form: json['form']?.toString(),
      frequency: json['frequency']?.toString(),
      days: json['date']?.toString(),
      time: json['time']?.toString(),
    );
  }

  static List<Medicine> fromSnapshot(List<Map<String, dynamic>> snapshot) {
    return snapshot.map((data) => Medicine.fromJson(data)).toList();
  }

  @override
  String toString() {
    return '{id_local: $id, name: $name, form: $form, frequency: $frequency, days: $days, time: $time}';
  }
}
