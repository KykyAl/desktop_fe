import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:Devpelopment/data/datasource/api.dart';
import 'package:Devpelopment/data/model/data_model.dart';
import 'package:Devpelopment/data/repo/data_repository.dart';
import 'package:Devpelopment/data/repo/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class DataController extends GetxController {
  RxString result = "N/A".obs;
  RxList<UserRepository> listData = <UserRepository>[].obs;
  RxList<TransactionRepository> listTransaction = <TransactionRepository>[].obs;

  final Datasource datasource = Datasource();
  Rx<TextEditingController> kartuController =
      TextEditingController(text: '').obs;
  RxString totalToken = "0".obs;
  RxString baseUrl = "".obs;
  RxString baseUrl2 = "".obs;
  final box = GetStorage();

  Rx<TextEditingController> savedIp = TextEditingController(text: '').obs;
  var currentTime = ''.obs;
  var errorMessage = "".obs;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    checkAndFetchStore();
    startRealTimeClock();
    startAutoRefresh();
  }

  @override
  void onClose() {
    savedIp.value.dispose();
    timer?.cancel();
    super.onClose();
  }

  void startRealTimeClock() {
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      currentTime.value = DateTime.now().toString().split('.')[0]; // Format waktu
    });
  }


  void startAutoRefresh() {
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) async {
      if (kartuController.value.text.isNotEmpty) {
        await fetchData(kartuController.value.text); // Refresh data otomatis
      }
    });
  }

// Metode Baru
  Future<void> checkAndFetchStore() async {
    await checkSavedIp();
    await apiStore();
  }

  Future<void> fetchLocalIp(String ip) async {
    if (ip.isNotEmpty) {
    //  baseUrl2.value = 'http://127.0.0.1:8000/api/images/';
    //   baseUrl.value = 'http://127.0.0.1:8000/api';
     baseUrl2.value = 'http://$ip:9133/api/images/';
      baseUrl.value = 'http://$ip:9133/api';
      log("BASE URL: ${baseUrl.value}");
      box.write("ip", ip);
    } else {
      errorMessage.value = "IP tidak boleh kosong";
    }
  }

  Future<void> checkSavedIp() async {
    if (box.hasData("ip")) {
      String saved = box.read("ip");
      savedIp.value.text = saved;
      await fetchLocalIp(saved);
    }
  }

  void logout() {
    box.remove("ip");
    savedIp.value.clear();
    errorMessage.value = "";
  }

  Future<void> fetchData(String noNfc) async {
    try {
      listData.clear();
      listTransaction.clear();
      totalToken.value = "0";
      errorMessage.value = "";
      await Future.delayed(Duration(milliseconds: 200));
      final response = await fetchDatasource(DataModel(noNfc: noNfc));
      log(response.body);
      final responseDecode = jsonDecode(response.body);

      if (responseDecode.containsKey('error')) {
        errorMessage.value = responseDecode['error'];
        return;
      }

      final transactions = responseDecode['transactions'];
      final users = responseDecode['user'];

      if (transactions.length == users.length) {
        for (int i = 0; i < users.length; i++) {
          var user = UserRepository.fromJson(users[i]);
          var userTransaction = TransactionRepository.fromJson(transactions[i]);

          listData.add(user);
          listTransaction.add(userTransaction);

          int tokenAwal = int.tryParse(user.saldo ?? '0') ?? 0;
          int pemakaianToken = int.tryParse(user.pemakaianSaldo ?? '0') ?? 0;
          int bonusToken = int.tryParse(user.saldoBonus ?? '0') ?? 0;
          int pemakaianBonusToken =
              int.tryParse(user.pemakaianBonus ?? '0') ?? 0;
          int total =
              tokenAwal + pemakaianToken + bonusToken + pemakaianBonusToken;

          totalToken.value = total.toString();
          debugPrint("Total Token untuk ${user.noNfc}: ${totalToken.value}");
        }
      } else {
        errorMessage.value = "Jumlah transaksi dan pengguna tidak sesuai.";
      }
    } catch (e) {
      errorMessage.value = "Gagal mengambil data: ${e.toString()}";
      debugPrint("Error fetching data: $e");
    }
  }

  Future<http.Response> fetchDatasource(DataModel? body) async {
    log('${baseUrl.value}/configure-database');

    try {
      if (baseUrl.value.isEmpty) {
        if (savedIp.value.text.isNotEmpty) {
          await fetchLocalIp(savedIp.value.text);
        } else {
          log("IP kosong, tidak bisa fetch data");
          return http.Response('IP tidak tersedia', 500);
        }
      }

      var response = await http.post(
        Uri.parse('${baseUrl.value}/configure-database'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(body?.toJson()),
      );

      if (response.statusCode == 200) {
        log("Data Berhasil di Fetch");
        return response;
      } else {
        log('Gagal Fetch Data, Status Code: ${response.statusCode}');
        return http.Response('Gagal Fetch Data', response.statusCode);
      }
    } catch (e) {
      log('Error Fetch Data: $e');
      return http.Response('Error: $e', 500);
    }
  }

  //# Handler API yang masuk
  Future<void> apiStore() async {
    if (baseUrl.value.isEmpty) {
      log("BASE URL belum diatur, tidak bisa fetch data");
      errorMessage.value = "IP Tidak Ditemukan";
      return;
    }

    try {
      var response = await http
          .post(
        Uri.parse('${baseUrl.value}/detail-master'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"params": "TOKO_ALMT"}),
      )
          .timeout(const Duration(seconds: 10), onTimeout: () {
        log('Request Timeout');
        return http.Response('Request Timeout', 408);
      });

      if (response.statusCode == 200) {
        log("Data alamat toko berhasil di-fetch");
        var responseDecode = jsonDecode(response.body);

        if (responseDecode["data"] is List &&
            responseDecode["data"].isNotEmpty) {
          final tokoItem = (responseDecode["data"] as List).firstWhere(
            (element) => element["key2"] == "TOKO_ALMT",
            orElse: () => null,
          );

          if (tokoItem != null) {
            result.value =
                tokoItem["keterangan"] ?? "Keterangan tidak tersedia";
          } else {
            result.value = "Tidak ada data TOKO_ALMT";
          }
        } else {
          result.value = "Data kosong atau tidak valid";
        }
      } else {
        log('Gagal Fetch Data, Status Code: ${response.statusCode}');
        errorMessage.value = 'Gagal mengambil alamat toko';
      }
    } catch (e) {
      errorMessage.value = "Gagal mengambil data: ${e.toString()}";
      log("Error fetching store address: $e");
    }
  }
}
