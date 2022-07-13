import 'package:bloc/bloc.dart';
import 'package:make_my_trip/features/sign_up/domain/use_cases/register_user_usecase.dart';
import 'package:make_my_trip/utils/validators/user_info/user_information_validations.dart';
import 'package:meta/meta.dart';
part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({required this.registerusecase}) : super(SignUpInitial());
  final Register_User_Usecase registerusecase;

  validate_Email(String email){
    var resemail = UserInfoValidation.emailAddressValidation(email);
    if(resemail!=null) {
      emit(SignUpError(resemail.toString()));
    }
    else{
      emit(SignUpError(""));
    }
  }
  validate_Name(String name){
    var resname = UserInfoValidation.nameValidation(name);
    if(resname!=null){
      emit(SignUpError(resname));
    }
    else{
      emit(SignUpError(""));
    }
  }
  validate_Password(String password){
    RegExp regex =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if(!regex.hasMatch(password)){
      emit(SignUpError("Please Enter a valid password"));
    }
    else{
      emit(SignUpError(""));
    }
  }

  create_User({ required String email,required String password}){

    try{
      registerusecase.call(Map(),email,password).then((value) => value.fold((l) =>print("left"), (r) => emit(RegisterSuccess(success_message: 'Registered User Successfully!'))));
    }
    catch(e){
    }
  }
}
