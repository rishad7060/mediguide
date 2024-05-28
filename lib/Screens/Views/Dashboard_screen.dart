import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horizontal_calendar/horizontal_calendar.dart';
import 'package:medical/Providers/medicine_provider_local.dart';
import 'package:medical/Screens/Views/find_ai.dart';
import 'package:medical/Screens/Widgets/banner.dart';
import 'package:medical/model/Medicine.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Locale _locale = const Locale('en', '');
  bool _isLoading = true;

  // State variables for edit popup
  String? _frequency;
  List<bool> _daysSelected = List.generate(7, (index) => false);
  List<String> _times = [];
  String? _medicineForm;

  @override
  void initState() {
    super.initState();
    getMedicine();
  }

  getMedicine() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<MedicineProviderLocal>(context, listen: false)
        .getMedicineFromLocal();
    setState(() {
      _isLoading = false;
    });
  }

  void setLocale(Locale value) {
    print(value);
    setState(() {
      _locale = value;
    });
  }

  void _editMedicine(Medicine medicine) {
    TextEditingController nameController =
        TextEditingController(text: medicine.name);
    TextEditingController formController =
        TextEditingController(text: medicine.form);

    _frequency = medicine.frequency;
    _times = medicine.time!.split(', ');

    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    _daysSelected = days.map((day) => medicine.days!.contains(day)).toList();

    _medicineForm = medicine.form; // Set the initial form value

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Medicine'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    _buildMedicineFormField(setState),
                    _buildFrequencyField(setState),
                    _buildDaysSelector(),
                    _buildTimesField(setState),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    String selectedDays = days
                        .asMap()
                        .entries
                        .where((entry) => _daysSelected[entry.key])
                        .map((entry) => entry.value)
                        .join(', ');

                    Medicine updatedMedicine = Medicine(
                      id: medicine.id,
                      name: nameController.text,
                      form: _medicineForm,
                      frequency: _frequency,
                      days: selectedDays,
                      time: _times.join(', '),
                    );

                    await Provider.of<MedicineProviderLocal>(context,
                            listen: false)
                        .updateMedicine(updatedMedicine);
                    Navigator.of(context).pop();
                    getMedicine();
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildMedicineFormField(Function setState) {
    return DropdownButtonFormField<String>(
      value: _medicineForm,
      decoration: InputDecoration(
        labelText: 'Form',
        labelStyle: GoogleFonts.poppins(color: Colors.red),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      items: ['Pill', 'Injection', 'Solution'].map((form) {
        return DropdownMenuItem<String>(
          value: form,
          child: Text(form),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _medicineForm = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select the form of medicine';
        }
        return null;
      },
      onSaved: (value) {
        _medicineForm = value;
      },
    );
  }

  Widget _buildFrequencyField(Function setState) {
    return DropdownButtonFormField<String>(
      value: _frequency,
      decoration: InputDecoration(
        labelText: 'Frequency',
        labelStyle: GoogleFonts.poppins(color: Colors.red),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      items: ['Everyday', 'Specific days'].map((frequency) {
        return DropdownMenuItem<String>(
          value: frequency,
          child: Text(frequency),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _frequency = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select the frequency';
        }
        return null;
      },
      onSaved: (value) {
        _frequency = value;
      },
    );
  }

  Widget _buildDaysSelector() {
    if (_frequency == 'Specific days') {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return Wrap(
        spacing: 8.sp,
        children: List<Widget>.generate(7, (int index) {
          return FilterChip(
            label: Text(days[index]),
            selected: _daysSelected[index],
            onSelected: (bool selected) {
              setState(() {
                _daysSelected[index] = selected;
              });
            },
            selectedColor: Colors.red,
          );
        }).toList(),
      );
    } else {
      return SizedBox(); // Return an empty SizedBox if frequency is 'Everyday'
    }
  }

  Widget _buildTimesField(Function setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Times',
          style: GoogleFonts.poppins(color: Colors.red, fontSize: 16.sp),
        ),
        Wrap(
          spacing: 8.0,
          children: List<Widget>.generate(_times.length + 1, (index) {
            if (index == _times.length) {
              return IconButton(
                icon: Container(
                    height: MediaQuery.of(context).size.height * 0.10,
                    width: MediaQuery.of(context).size.width * 0.10,
                    child: Image.asset("lib/icons/time.png")),
                onPressed: () async {
                  final timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (timeOfDay != null) {
                    setState(() {
                      _times.add(timeOfDay.format(context));
                    });
                  }
                },
              );
            }
            return Chip(
              label: Text(_times[index]),
              onDeleted: () {
                setState(() {
                  _times.removeAt(index);
                });
              },
              deleteIconColor: Colors.red,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTimesField2(Function setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Times',
          style: GoogleFonts.poppins(color: Colors.red, fontSize: 16.sp),
        ),
        Wrap(
          spacing: 8.0,
          children: List<Widget>.generate(_times.length + 1, (index) {
            if (index == _times.length) {
              return IconButton(
                icon: Container(
                  height: MediaQuery.of(context).size.height * 0.10,
                  width: MediaQuery.of(context).size.width * 0.10,
                  child: Image.asset("lib/icons/time.png"),
                ),
                onPressed: () async {
                  final timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (timeOfDay != null) {
                    setState(() {
                      _times.add(timeOfDay.format(context));
                    });
                  }
                },
              );
            }
            return Chip(
              label: Text(_times[index]),
              onDeleted: () {
                setState(() {
                  _times.removeAt(index);
                });
              },
              deleteIconColor: Colors.red,
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _medicine = Provider.of<MedicineProviderLocal>(context).medicine;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Container(
              alignment: Alignment.bottomCenter,
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.06,
              child: Image.asset(
                "lib/icons/bell.png",
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ],
        title: Column(
          children: [
            const SizedBox(height: 50),
            Text(
              "Find your desire\nhealth solution",
              style: GoogleFonts.inter(
                color: const Color.fromARGB(255, 51, 47, 47),
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        toolbarHeight: 130,
        elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: const BoxDecoration(),
                child: TextField(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const find_ai(),
                      ),
                    );
                  },
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.none,
                  autofocus: false,
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    focusColor: Colors.black26,
                    fillColor: const Color.fromARGB(255, 247, 247, 247),
                    filled: true,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        height: 10,
                        width: 10,
                        child: Image.asset(
                          "lib/icons/search.png",
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                    prefixIconColor: const Color.fromARGB(202, 255, 0, 0),
                    label:
                        const Text("Search drugs, articles, side effects..."),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            HorizontalCalendar(
              date: DateTime.now(),
              initialDate: DateTime.now(),
              textColor: Colors.black,
              backgroundColor: Colors.white,
              selectedColor: Colors.red,
              showMonth: true,
              locale: Localizations.localeOf(context),
              onDateSelected: (date) {
                if (kDebugMode) {
                  print(date.toString());
                }
              },
            ),
            SizedBox(height: 20),
            // Add your banner widget here
            AddMedicinePage(),
            SizedBox(height: 20),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  )
                : _medicine.length == 0
                    ? Center(
                        child: Text(
                          "No Products Here To Show",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _medicine.length,
                        itemBuilder: (context, index) {
                          Medicine medicine = _medicine[index];
                          return Card(
                            // Card properties
                            child: ListTile(
                              title: Text(medicine.name ?? ''),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Form: ${medicine.form ?? ''}"),
                                  Text(
                                      "Frequency: ${medicine.frequency ?? ''}"),
                                  Text("Days: ${medicine.days ?? ''}"),
                                  Text("Time: ${medicine.time ?? ''}"),
                                ],
                              ),
                              onTap: () {
                                _editMedicine(medicine);
                              },
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  Provider.of<MedicineProviderLocal>(context,
                                          listen: false)
                                      .deleteMedicine(medicine.id!);
                                  getMedicine();
                                },
                              ),
                            ),
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }
}
