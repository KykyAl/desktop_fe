import 'dart:developer';

import 'package:Devpelopment/data/controller.dart';
import 'package:Devpelopment/widget/video.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DataController dataController = Get.put(DataController());
  final FocusNode _focusNode = FocusNode();

  void _clearAndFocus() {
    dataController.kartuController.value.clear();
    _focusNode.requestFocus();
  }

  final List<String> imagePaths = [
    'Logo2.jpg',
    'Logo2.jpg',
    'Logo2.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 10,
              child: Obx(() => Text(
                    dataController.currentTime.value,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStackedText("Milky", Color(0xFFFFD54F)),
                      SizedBox(width: 20),
                      _buildStackedText("Verse", Color(0xFFFFB6C1)),
                    ],
                  ),
                  Obx(() {
                    return Text(
                      dataController.result.value == "N/A"
                          ? "Memuat alamat toko..."
                          : dataController.result.value,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                flex: 2,
                                child: _buildGlowingContainer(
                                  _buildHoverImage(imagePaths[0]),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: _buildGlowingContainer(
                                  _buildHoverImage(imagePaths[1]),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: _buildGlowingContainer(
                                  _buildHoverImage(imagePaths[2]),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 4,
                                child: _carousel([
                                  'Logo2.jpg',
                                  "vidio1.mp4",
                                  "vidio2.mp4",
                                ]),
                              ),
                              Expanded(
                                flex: 3,
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    bool isSmallScreen =
                                        constraints.maxWidth < 500;
                                    return AnimatedSwitcher(
                                      duration: Duration(milliseconds: 500),
                                      child: isSmallScreen
                                          ? Column(
                                              children: [
                                                _buildGlowingContainer(
                                                    _buildNoKartuContainer(
                                                        context)),
                                                SizedBox(height: 10),
                                                _buildGlowingContainer(
                                                    _buildUserContainer(
                                                        context)),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: _buildGlowingContainer(
                                                      _buildNoKartuContainer(
                                                          context)),
                                                ),
                                                Expanded(
                                                  child: _buildGlowingContainer(
                                                      _buildUserContainer(
                                                          context)),
                                                ),
                                              ],
                                            ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildHoverImage(String imagePath) {
  //   return AnimatedContainer(
  //     duration: Duration(milliseconds: 400),
  //     margin: EdgeInsets.all(10),
  //     width: double.infinity,
  //     height: double.infinity,
  //     decoration: BoxDecoration(
  //       color: Colors.blueGrey[700],
  //       borderRadius: BorderRadius.circular(15),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.indigo.withOpacity(0.3),
  //           blurRadius: 15,
  //           offset: Offset(0, 8),
  //         ),
  //       ],
  //       border: Border.all(
  //         color: Colors.indigo.withOpacity(0.9),
  //         width: 2,
  //       ),
  //     ),
  //     child: Center(
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(5),
  //         child: Image.network(
  //           '${dataController.baseUrl2.value}$imagePath',
  //           width: double.infinity,
  //           height: double.infinity,
  //           fit: BoxFit.fill,
  //           loadingBuilder: (context, child, loadingProgress) {
  //             if (loadingProgress == null) return child;
  //             return Center(child: CircularProgressIndicator());
  //           },
  //           errorBuilder: (context, error, stackTrace) {
  //             return Center(child: Icon(Icons.image_not_supported, size: 50));
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildImageContainer(String imagePath) {
  //   return Obx(
  //     () => Container(
  //       width: MediaQuery.of(context).size.width,
  //       height: MediaQuery.of(context).size.height,
  //       margin: EdgeInsets.only(right: 8, bottom: 8),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(5),
  //         color: Colors.green,
  //       ),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(5),
  //         child:
  //       ),
  //     ),
  //   );
  // }
  bool isVideo(String url) {
    return url.toLowerCase().endsWith('.mp4');
  }

  Widget _carousel(List<String> videoPaths) {
    return CarouselSlider.builder(
     options: CarouselOptions(
        height: double.infinity,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 7),
        enlargeCenterPage: true,
        viewportFraction: 0.7,
        enableInfiniteScroll: true,
        scrollDirection: Axis.horizontal,
        aspectRatio: 16 / 9,
        pageSnapping: true,
      ),
      itemCount: videoPaths.length,
      itemBuilder: (context, index, realIndex) {
        String mediaUrl = '${dataController.baseUrl2}${videoPaths[index]}';
        log(mediaUrl);
        return AnimatedContainer(
          duration: Duration(milliseconds: 400),
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.withOpacity(0.8),
                blurRadius: 15,
                spreadRadius: 3,
              ),
            ],
            border: Border.all(
              color: Colors.indigo.withOpacity(0.9),
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: isVideo(mediaUrl)
                ? VideoPlayerWidget(videoUrl: mediaUrl) // Widget khusus video
                : Image.network(mediaUrl, fit: BoxFit.cover), // Gambar biasa
          ),
        );
      },
    );
  }

  Widget _buildHoverImage(String imagePath) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      margin: EdgeInsets.all(10),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blueGrey[500],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.5),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: Colors.indigo.withOpacity(0.9),
          width: 2,
        ),
      ),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          // child: Image.asset(
          //   "assets/images/Logo2.jpg",
          //   fit: BoxFit.cover,
          //   width: double.infinity,
          //   height: double.infinity,
          // ),
          child: Image.network(
            '${dataController.baseUrl2.value}$imagePath',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return Center(child: Icon(Icons.image_not_supported, size: 50));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGlowingContainer(Widget child) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.8),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: child,
      ),
    );
  }

  Widget _buildNoKartuContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blueGrey[700],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              color: Colors.blueGrey[900],
            ),
            child: Text(
              "Kartu User",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          // Body
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "No.Kartu",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: dataController.kartuController.value,
                  decoration: InputDecoration(
                    labelText: "Masukkan Kartu",
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      dataController.fetchData(value);
                    }
                  },
                ),
                SizedBox(height: 15),
                Text(
                  "Sisa Token",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Obx(() {
                  return TextField(
                    controller: TextEditingController(
                        text: dataController.totalToken.value),
                    enabled: false,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.blueGrey[600],
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[700],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              color: Colors.blueGrey[900],
            ),
            child: Center(
              child: Text(
                "Detail User",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "User",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Obx(() => Text(
                              dataController.listTransaction.isEmpty
                                  ? 'N/A'
                                  : dataController.listTransaction[0].usrCr
                                      .toString(),
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 14),
                            )),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Count",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Obx(() => Text(
                              dataController.listTransaction.isEmpty
                                  ? '0'
                                  : dataController.listTransaction[0].count
                                      .toString(),
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 14),
                            )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStackedText(String text, Color color) {
    return Stack(
      children: [
        Text(
          text,
          style: GoogleFonts.kavoon(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3
              ..color = Color(0xFF1A237E),
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                offset: Offset(0, 10),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        Text(
          text,
          style: GoogleFonts.kavoon(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
