import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BlogPage extends StatelessWidget {
  final String topic;
  final String details;
  final String date;

  const BlogPage(
      {Key? key,
      required this.topic,
      required this.details,
      required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          topic, // Display topic in app bar
          style: GoogleFonts.poppins(color: Colors.black, fontSize: 18.sp),
        ),
        centerTitle: false,
        elevation: 0,
        toolbarHeight: 100,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                topic, // Display topic in app bar
                style:
                    GoogleFonts.poppins(color: Colors.black, fontSize: 18.sp),
              ),
              SizedBox(
                height: 5,
              ),
              Text(date),
              SizedBox(
                height: 5,
              ),
              Text(
                details,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
