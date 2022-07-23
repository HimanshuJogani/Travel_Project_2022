import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:make_my_trip/core/failures/failures.dart';
import 'package:make_my_trip/features/hotel_detail/data/model/hotel_detail_model.dart';
import 'package:make_my_trip/utils/constants/base_constants.dart';

abstract class HotelDetailRemoteDataSource {
  Future<Either<Failures, HotelDetailModel>> getAllHotelDetailData(int index);
}

class HotelDetailRemoteDataSourceImpl implements HotelDetailRemoteDataSource {
  final Dio dio;
  HotelDetailRemoteDataSourceImpl(this.dio);

  void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  Future<Options> createDioOptions() async {
    final userToken = await FirebaseAuth.instance.currentUser!.getIdToken();
    printWrapped(userToken);
    return Options(headers: {'token': userToken});
  }
  @override
  Future<Either<Failures, HotelDetailModel>> getAllHotelDetailData(
      int index) async {
    return _getAllCharacterUrl(
        "${BaseConstant.baseUrl}hotel/gethotel/getperticularhotel/${index}");
  }

  Future<Either<Failures, HotelDetailModel>> _getAllCharacterUrl(
      String url) async {
    try {
      final response = await dio.get(url,options: await createDioOptions());

      if (response.statusCode == 200) {
        HotelDetailModel hotelDetailModel;
        final apidata = response.data;
        hotelDetailModel = HotelDetailModel.fromJson(apidata);
        print(hotelDetailModel.features);
        return Right(hotelDetailModel);
      } else {
        return Left(ServerFailure());
      }
    } catch (err) {
      return Left(ServerFailure());
    }
  }
}
