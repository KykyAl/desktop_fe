import 'dart:convert';
import 'dart:developer';

import 'package:Devpelopment/data/model/data_model.dart';
import 'package:http/http.dart' as http;

class Datasource {


  Future<http.Response> fetchDatasource(DataModel? body) async {
    try {
      var response = await http.post(
        Uri.parse('configure-database'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(body?.toJson()),
      );
      log(response.body);

      if (response.statusCode == 200) {
        return response; 
      } else {
        print('Failed to load data, status code: ${response.statusCode}');
        return http.Response('Failed to load data', response.statusCode);
      }
    } catch (e) {
      print('Error: $e');
      return http.Response(
          'Error: $e', 500); 
    }
  }
  
}
