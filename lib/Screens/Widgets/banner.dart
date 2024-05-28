import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:medical/Screens/add_medicine_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical/Providers/medicine_provider_local.dart';
import 'package:medical/Screens/Views/Dashboard_screen.dart';
import 'package:medical/Screens/Views/Homepage.dart';
import 'package:medical/model/Medicine.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: BoxDecoration(
          color: Color.fromARGB(153, 236, 232, 232),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25),
                  Text(
                    "Early protection for\nyour family's health",
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddMedicinePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Add Reminder",
                      style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.3,
              alignment: Alignment.bottomCenter,
              child: Image.asset("lib/icons/female.png"),
            ),
          ],
        ),
      ),
    );
  }
}

class AddMedicinePage extends StatefulWidget {
  const AddMedicinePage({Key? key}) : super(key: key);

  @override
  _AddMedicinePageState createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final _formKey = GlobalKey<FormState>();
  String? _medicineName;
  String? _medicineForm;
  String? _frequency;
  List<String> _times = [];
  List<bool> _daysSelected = List.generate(7, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              PageTransition(
                type: PageTransitionType.leftToRight,
                child: Homepage(),
              ),
            );
          },
        ),
        title: Text("Add Medicine"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 20.sp),
              _buildMedicineNameField(),
              SizedBox(height: 20.sp),
              _buildMedicineFormField(),
              SizedBox(height: 20.sp),
              _buildFrequencyField(),
              SizedBox(height: 20.sp),
              if (_frequency == 'Specific days') _buildDaysSelector(),
              SizedBox(height: 20.sp),
              _buildTimesField(),
              SizedBox(height: 20.sp),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicineNameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Medicine Name',
        labelStyle: GoogleFonts.poppins(color: Colors.black),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.red),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the medicine name';
        }
        return null;
      },
      onSaved: (value) {
        _medicineName = value;
      },
    );
  }

  Widget _buildMedicineFormField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Form',
        labelStyle: GoogleFonts.poppins(color: Colors.black),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.red),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
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

  Widget _buildFrequencyField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Frequency',
        labelStyle: GoogleFonts.poppins(color: Colors.black),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.red),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
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
  }

  Widget _buildTimesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Times',
          style: GoogleFonts.poppins(color: Colors.red, fontSize: 16.sp),
        ),
        Wrap(
          spacing: 8.sp,
          children: List<Widget>.generate(_times.length + 1, (index) {
            if (index == _times.length) {
              return IconButton(
                icon: Container(
                  height: 40.sp,
                  width: 40.sp,
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

  String _getSelectedDays() {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    List<String> selectedDays = [];
    for (int i = 0; i < _daysSelected.length; i++) {
      if (_daysSelected[i]) {
        selectedDays.add(days[i]);
      }
    }
    return selectedDays.join(", ");
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.sp),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            final medicine = Medicine(
              name: _medicineName!,
              form: _medicineForm!,
              frequency: _frequency!,
              days: _getSelectedDays(),
              time: _times.join(", "),
            );
            MedicineProviderLocal().insertMedicine(medicine);
            Navigator.pushReplacement(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: Dashboard(),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        child: Text(
          'Save',
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 16.sp),
        ),
      ),
    );
  }
}
