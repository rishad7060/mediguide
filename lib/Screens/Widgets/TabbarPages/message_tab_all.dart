import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical/Screens/Views/blog_page.dart';
import 'package:medical/Screens/Widgets/message_all_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MessageTabAll extends StatefulWidget {
  const MessageTabAll({Key? key}) : super(key: key);

  @override
  _MessageTabAllState createState() => _MessageTabAllState();
}

class _MessageTabAllState extends State<MessageTabAll>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  final List<String> topics = [
    "It's super helpful to make your dose",
    "The Gut Microbiome: The Tiny Tenants with a Big Impact",
    "The Unsung Hero of Health",
  ];

  final List<String> details = [
    "Dive into the fascinating world of the gut microbiome! This blog post will explore the trillions of bacteria living in your gut and how they influence everything from digestion to mood. Learn about the factors that affect your gut health, the benefits of a balanced microbiome, and tips on how to nurture these tiny tenants for optimal well-being.",
    "We all know sleep is important, but do you understand just how crucial it is for your physical and mental health? This blog post will delve into the science of sleep, explaining its impact on your immune system, brain function, and overall well-being. Explore tips for creating a healthy sleep routine, overcoming common sleep problems, and waking up feeling refreshed and energized.",
    "The world of medicine is rapidly evolving, and telemedicine is at the forefront. This blog post will explore the benefits of virtual doctor visits, from increased convenience and accessibility to improved chronic disease management. Learn how telemedicine works, what types of appointments are well-suited for it, and how to get started with virtual healthcare.",
  ];

  final List<String> dates = [
    "02/01/2024",
    "01/05/2024",
    "08/11/2023",
  ];

  final List<String> subtexts = [
    "A model of health care...",
    "A new era in gut health...",
    "The future of healthcare...",
  ];

  final List<String> images = [
    "images/article1.png",
    "images/img6.png",
    "images/capsules.png",
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Updates",
          style: GoogleFonts.poppins(color: Colors.black, fontSize: 18.sp),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(topics.length, (index) {
            return GestureDetector(
              onTap: () {
                if (details.length >= topics.length) {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.bottomToTop,
                      child: BlogPage(
                        topic: topics[index],
                        details: details[index],
                        date: dates[index],
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Blog detail for '${topics[index]}' is missing. Please update your code.",
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: MessageAllWidget(
                image: images[index],
                mainText: topics[index],
                subText: subtexts[index],
                time: dates[index],
              ),
            );
          }),
        ),
      ),
    );
  }
}
