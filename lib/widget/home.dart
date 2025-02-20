import 'package:Devpelopment/data/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DataController dataController = Get.put(DataController());
  final FocusNode _focusNode = FocusNode();

  final List<String> imagePaths = [
    'image1.jpg',
    'image2.jpg',
    'image3.jpg',
    'image4.jpg',
  ];

  void _clearAndFocus() {
    dataController.kartuController.value.clear();
    _focusNode.requestFocus();
  }

  Widget _buildImageContainer(String imagePath) {
    return Obx(
      () => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.only(right: 8, bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.green,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                          flex: 2, child: _buildImageContainer(imagePaths[0])),
                      Expanded(
                          flex: 2, child: _buildImageContainer(imagePaths[1])),
                      Expanded(
                          flex: 2, child: _buildImageContainer(imagePaths[2])),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Expanded(
                          flex: 5, child: _buildImageContainer(imagePaths[3])),
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(15),
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
                                    Row(
                                      children: [
                                        Text(
                                          "No.Kartu ",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    TextField(
                                      controller:
                                          dataController.kartuController.value,
                                      focusNode: _focusNode,
                                      decoration: InputDecoration(
                                        labelText: "Masukkan Kartu",
                                        labelStyle:
                                            TextStyle(color: Colors.white70),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white70),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      style: TextStyle(color: Colors.white),
                                      keyboardType: TextInputType.number,
                                      onSubmitted: (value) {
                                        if (value.isNotEmpty) {
                                          dataController.fetchData(value);
                                          _clearAndFocus();
                                        }
                                      },
                                    ),
                                    Obx(() {
                                      if (dataController
                                          .errorMessage.isNotEmpty) {
                                        return Text(
                                          "Not Found",
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 14),
                                        );
                                      } else {
                                        return SizedBox.shrink();
                                      }
                                    }),
                                    SizedBox(height: 18),
                                    Text(
                                      "Sisa Token: ",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Obx(() {
                                      return Expanded(
                                        child: TextField(
                                          controller: TextEditingController(
                                              text: dataController
                                                  .totalToken.value),
                                          enabled: false,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width <
                                                    600
                                                ? 16
                                                : 22, 
                                            fontWeight: FontWeight.bold,
                                          ),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.blueGrey[600],
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(15),
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              "User",
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.2,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Obx(() {
                                              if (dataController
                                                  .listTransaction.isEmpty) {
                                                return Text(
                                                  'N/A',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                );
                                              }
                                              return Text(
                                                dataController
                                                    .listTransaction[0].usrCr
                                                    .toString(),
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              );
                                            }),
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
                                                letterSpacing: 1.2,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Obx(() {
                                              if (dataController
                                                  .listTransaction.isEmpty) {
                                                return Text(
                                                  '0',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                );
                                              }
                                              return Text(
                                                dataController
                                                    .listTransaction[0].count
                                                    .toString(),
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              );
                                            }),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                  ],
                                ),
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
    );
  }
}
