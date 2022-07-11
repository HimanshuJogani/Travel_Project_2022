import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:make_my_trip/features/home_page/data/data_sources/tours_datasource.dart';

import '../models/ToursModel.dart';

class Tours_DataSource_impl extends ToursDataSource {
  Stream<List<ToursModel>> get_tours() async* {
    yield* Stream.periodic(Duration(seconds: 0), (_) async {
      final response =
          await http.get(Uri.parse('http://192.168.101.164:4000/tour/10'));
      var data = jsonDecode(response.body.toString());
      List<ToursModel> postlist = [];
      {
        for (Map i in data) {
          postlist.add(ToursModel.fromJson(i));
        }
      }
      return postlist;
    }).asyncMap((event) async => await event);
  }
}