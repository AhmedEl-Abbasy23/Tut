import 'package:dio/dio.dart';
import 'package:flutter_advanced/app/constant.dart';
import 'package:flutter_advanced/data/responses/responses.dart';
import 'package:retrofit/http.dart';

part 'app_api.g.dart';

@RestApi(baseUrl: Constant.baseUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  @POST(Constant.login)
  Future<AuthenticationResponse> login(
    @Field("email") String email,
    @Field("password") String password,
    @Field("imei") String imei,
    @Field("deviceType") String deviceType,
  );

  @POST(Constant.forgotPassword)
  Future<ForgotPasswordResponse> forgotPassword(@Field("email") String email);

  @POST(Constant.register)
  Future<AuthenticationResponse> register(
    @Field("user_name") String userName,
    @Field("country_mobile_code") String countryMobileCode,
    @Field("mobile_number") String mobileNumber,
    @Field("email") String email,
    @Field("password") String password,
    @Field("profile_picture") String profilePicture,
  );

  @GET(Constant.home)
  Future<HomeResponse> getHome();

  @GET(Constant.storeDetails)
  Future<StoreDetailsResponse> getStoreDetails();
}
