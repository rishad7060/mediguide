import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical/Screens/Views/Homepage.dart';
import 'package:medical/Screens/Views/appointment.dart';
import 'package:medical/Screens/Views/doctor_details_screen.dart';
import 'package:medical/Screens/Widgets/doctorList.dart';
import 'package:medical/Screens/Widgets/listicons.dart';
import 'package:medical/services/chat_service.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class find_ai extends StatefulWidget {
  const find_ai({super.key});

  @override
  State<find_ai> createState() => _find_aiState();
}

class _find_aiState extends State<find_ai> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  bool isLoading = false;

  void _performSearch() async {
    String? response =
        await ChatService().generateResponse(_searchController.text);
    setState(() {
      isLoading = true;
      _searchQuery = response ?? "";
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.06,
              child: Image.asset("lib/icons/back2.png")),
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.leftToRight, child: Homepage()));
          },
        ),
        title: Text(
          "Chat Box",
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                  "This is full ai response you can search about pills, side effects, other medical related things but we don't recomend do action acording to this if you have any medical issues please consult a doctor"),
              _buildSearchBar(),
              SizedBox(height: 20),
              _buildSearchResults()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search...',
        // prefixIcon: Icon(Icons.search),
        suffixIcon: IconButton(
          icon: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.05,
              child: Image.asset("lib/icons/search.png")),
          onPressed: _performSearch,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Center(
      child: Text(
        _searchQuery.isEmpty
            ? 'No search query entered'
            : 'Results for: $_searchQuery'.replaceAll('*', ''),
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }
}
