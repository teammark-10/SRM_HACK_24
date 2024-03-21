import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:studiesy/Ui/Transcription.dart';
import 'package:studiesy/Ui/chatScreen.dart';
import 'package:studiesy/models/databaseMethods.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Color> borderColors = [
    // Color(0xFF967c47),
    Color(0xFFf8d154),
  ];

  int currentColorIndex = 0;
  // List<String> imageAssets = [
  //   'assets/image1.png',
  //   'assets/image2.png',
  //   'assets/image3.png',
  //   'assets/image4.png',
  // ];
  // List subjects = [
  //   'Physics',
  //   'Mathematics',
  //   'English',
  //   'Chemistry',
  // ];

  Stream? notes;

  @override
  void initState() {
    DataBaseMethods().getNotes().then((val) {
      setState(() {
        notes = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 3.h, left: 5.w),
                  child: Text(
                    "Heyy,",
                    style: GoogleFonts.didactGothic(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                    width:
                        230), // Add some space between the text and the button
                Padding(
                  padding: EdgeInsets.only(top: 3.h, left: 5.w),
                  child: InkWell(
                    onTap: () {
                      // Add your action here
                    },
                    child: Container(
                      height: 50, // Adjust height as needed
                      width:
                          50, // Make width equal to height to create a circular shape
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Make container circular
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/prof_front.jpg'), // Replace with your image asset path
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.5.h),
              child: Text(
                "Welcome to Eduverse",
                style: GoogleFonts.didactGothic(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w900),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.5.h),
            //   child: SearchBar(
            //     hintText: 'Search',
            //     leading: Icon(
            //       Icons.search,
            //       size: 25.sp,
            //       color: const Color.fromARGB(255, 0, 0, 0),
            //     ),
            //     hintStyle: MaterialStatePropertyAll(
            //       GoogleFonts.poppins(
            //         textStyle:
            //             const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            //       ),
            //     ),
            //     elevation: const MaterialStatePropertyAll(0),
            //     backgroundColor: const MaterialStatePropertyAll(
            //       Color.fromRGBO(220, 224, 255, 0.843),
            //     ),
            //     shape: MaterialStatePropertyAll(
            //       ContinuousRectangleBorder(
            //         borderRadius: BorderRadius.all(
            //           Radius.circular(20.sp),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0.5.h),
            //   child: Text(
            //     'Learn Live',
            //     style: GoogleFonts.poppins(
            //       textStyle: TextStyle(
            //         fontWeight: FontWeight.w600,
            //         fontSize: 12.sp,
            //         color: Color.fromARGB(255, 0, 0, 0),
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 200,
                width: 370,
                decoration: BoxDecoration(
                    color: Color(0xFF8070EB),
                    // gradient: const LinearGradient(
                    //     begin: Alignment.topLeft,
                    //     end: Alignment.bottomRight,
                    //     colors: [
                    //       Color.fromARGB(248, 244, 87, 255),
                    //       Color.fromARGB(248, 143, 75, 147)
                    //     ]),
                    // image: DecorationImage(
                    //   image: AssetImage(
                    //       'assets/try.png'), // Replace with your image asset path
                    //   fit: BoxFit.fitHeight, // You can adjust the fit as needed
                    // ),
                    borderRadius: BorderRadius.circular(20.sp)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 2.h,
                        left: 4.w,
                      ),
                      child: Text(
                        "Transforming",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: GoogleFonts.didactGothic(
                            height: 1,
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                      ),
                      child: Text(
                        "Education!!",
                        style: GoogleFonts.didactGothic(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Row(children: [
                      SizedBox(
                        width: 12,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const TranscriptionPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xf8d154),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25), // Rounded rectangle border radius
                          ), // Change color as needed
                        ),
                        child: Text(
                          "Your live class",
                          style: GoogleFonts.didactGothic(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    ]),
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(left: 5.w),
            //   child: Row(
            //     children: [
            //       for (int i = 0; i < 4; i++)
            //         Container(
            //           height: 70.0,
            //           width: 70.0,
            //           margin: const EdgeInsets.all(8.0),
            //           child: Card(
            //             shape: CircleBorder(
            //               side: BorderSide(
            //                 width: 2,
            //                 color: borderColors[i],
            //               ),
            //             ),
            //             child: InkWell(
            //               onTap: () {
            //                 Navigator.push(
            //                   context,
            //                   MaterialPageRoute(
            //                       builder: (context) =>
            //                           const TranscriptionPage()),
            //                 );
            //               },
            //               child: ClipOval(
            //                 child: Container(
            //                   color: borderColors[i],
            //                   child: Center(
            //                     child: Image.asset(
            //                       imageAssets[i],
            //                       height: 40.0,
            //                       width: 40.0,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //     ],
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0.5.h),
              child: Text(
                "Your Classes",
                style: GoogleFonts.didactGothic(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600),
              ),
            ),
            genNotes()
          ],
        )),
      ),
    );
  }

  genNotes() {
    return Expanded(
        child: StreamBuilder(
            stream: notes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.5.h),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 4 / 3, crossAxisCount: 1),
                    itemBuilder: (context, index) {
                      currentColorIndex =
                          (currentColorIndex + 1) % borderColors.length;
                      return Padding(
                        padding: EdgeInsets.all(1.5.w),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConversationScreen(
                                  chatRoomId: 'dfdf',
                                  userName: 'Studiesy',
                                  subject: snapshot.data.docs[index]['name'],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                                // gradient: const LinearGradient(
                                //     begin: Alignment.topLeft,
                                //     end: Alignment.bottomRight,
                                //     colors: [
                                //       Color.fromARGB(248, 244, 87, 255),
                                //       Color.fromARGB(248, 143, 75, 147)
                                //     ]),
                                // image: DecorationImage(
                                //   image: AssetImage(
                                //       'assets/bg.jpg'), // Replace with your image asset path
                                //   fit: BoxFit
                                //       .cover, // You can adjust the fit as needed
                                // ),
                                color: borderColors[currentColorIndex],
                                borderRadius: BorderRadius.circular(20.sp)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 2.h,
                                    left: 4.w,
                                  ),
                                  child: Text(
                                    snapshot.data.docs[index]['name'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: GoogleFonts.didactGothic(
                                        height: 1,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                  ),
                                  child: Text(
                                    snapshot.data.docs[index]['teacher'],
                                    style: GoogleFonts.didactGothic(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                  ),
                                  child: Text(
                                    snapshot.data.docs[index]['date'],
                                    style: GoogleFonts.didactGothic(
                                        color: Color.fromARGB(255, 87, 87, 87),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                    vertical: 0.5.h,
                                  ),
                                  child: Text(
                                    snapshot.data.docs[index]['summary'],
                                    overflow: TextOverflow.fade,
                                    maxLines: 7,
                                    style: GoogleFonts.didactGothic(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                // const Align(
                                //   alignment: Alignment.center,
                                //   child: Icon(
                                //     Icons.arrow_forward_ios,
                                //     color: Color.fromARGB(255, 0, 0, 0),
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
