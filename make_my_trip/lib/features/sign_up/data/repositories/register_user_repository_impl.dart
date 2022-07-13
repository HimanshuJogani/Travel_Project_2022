
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:make_my_trip/core/failures/failures.dart';
import '../../domain/repositories/register_user_repository.dart';
import '../data_sources/register_user_datasource.dart';
class Register_User_Repository_Impl extends Register_User_Repository{
  Register_User_Datasource register_user_datasource;

  Register_User_Repository_Impl({required this.register_user_datasource});



  @override
  Future<Either<Failures, String>> register_user(Map param,String email,String password) async{


      var response = await register_user_datasource.register_user(email: email.toString(), password: password.toString());
      if(response=="true"){
        return Right("Successful");
      }
      else{
        return Left(throw UnimplementedError("Not successful"));
      }


  }




}