import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:Devpelopment/data/datasource/api.dart';
import 'package:Devpelopment/data/model/data_model.dart';
import 'package:Devpelopment/data/repo/data_repository.dart';
import 'package:Devpelopment/data/repo/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  var errorMessage = "".obs; // Tambahkan variabel errorMessage


  Future<void> fetchLocalIp() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4) {
          log("IP Address: ${addr.address}");
          baseUrl.value = 'http://${addr.address}:8000/api';
          return;
        }
      }
    }
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
      if (baseUrl.isEmpty) {
        await fetchLocalIp();
      }

      var response = await http.post(
        Uri.parse('${baseUrl.value}/configure-database'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(body?.toJson()),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        print('Failed to load data, status code: ${response.statusCode}');
        return http.Response('Failed to load data', response.statusCode);
      }
    } catch (e) {
      print('Error: $e');
      return http.Response('Error: $e', 500);
    }
  }
}
