import 'package:Devpelopment/widget/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blueGrey[900],
        body: box.hasData("ip") ? HomePage() : InputPage(),
      ),
    );
  }
}
class InputPage extends StatelessWidget {
  final TextEditingController inputController = TextEditingController();
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Masukkan IP",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 20),

              // TEXTFIELD
              Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(right: 50, left: 50),
                  child: TextField(
                    controller: inputController,
                    style: GoogleFonts.poppins(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blueGrey[700],
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: "Masukkan IP",
                      labelStyle: GoogleFonts.poppins(color: Colors.white70),
                      prefixIcon: Icon(Icons.wifi, color: Colors.indigo),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // BUTTON
              InkWell(
                onTap: () {
                  if (inputController.text.isNotEmpty) {
                    box.write("ip", inputController.text);
                    Get.off(() => HomePage(), transition: Transition.fadeIn);
                  } else {
                    Get.snackbar(
                      "Error!",
                      "IP tidak boleh kosong",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                      margin: EdgeInsets.all(15),
                      borderRadius: 10,
                      duration: Duration(seconds: 2),
                      icon: Icon(Icons.error, color: Colors.white),
                    );
                  }
                },
                child: Container(
                  width: 200,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[700],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.5),
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Text(
                    "LANJUT",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
