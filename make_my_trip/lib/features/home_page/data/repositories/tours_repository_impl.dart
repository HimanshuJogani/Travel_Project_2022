import 'package:make_my_trip/features/home_page/data/data_sources/tours_datasource.dart';

import 'package:make_my_trip/features/home_page/domain/repositories/tours_repository.dart';

import '../models/ToursModel.dart';

class ToursRepository_impl extends ToursRepository {
  ToursDataSource toursDataSource;

  ToursRepository_impl({required this.toursDataSource});

  @override
  get_tours() async{
    var reponse = await toursDataSource.get_tours();
    return reponse;
  }
}