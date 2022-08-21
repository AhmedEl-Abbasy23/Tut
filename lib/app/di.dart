import 'package:flutter_advanced/app/app_prefs.dart';
import 'package:flutter_advanced/data/data_source/local_data_source.dart';
import 'package:flutter_advanced/data/data_source/remote_data_source.dart';
import 'package:flutter_advanced/data/network/app_api.dart';
import 'package:flutter_advanced/data/network/dio_factory.dart';
import 'package:flutter_advanced/data/network/network_info.dart';
import 'package:flutter_advanced/data/repository/repository_implementer.dart';
import 'package:flutter_advanced/domain/repository/repository.dart';
import 'package:flutter_advanced/domain/usecase/forgot_password_usecase.dart';
import 'package:flutter_advanced/domain/usecase/home_usecase.dart';
import 'package:flutter_advanced/domain/usecase/login_usecase.dart';
import 'package:flutter_advanced/domain/usecase/register_usecase.dart';
import 'package:flutter_advanced/domain/usecase/store_details_usecase.dart';
import 'package:flutter_advanced/presentation/forgot_password/forgot_password_viewmodel.dart';
import 'package:flutter_advanced/presentation/login/login_viewmodel.dart';
import 'package:flutter_advanced/presentation/main/home_page/home_viewmodel.dart';
import 'package:flutter_advanced/presentation/register/register_viewmodel.dart';
import 'package:flutter_advanced/presentation/store_details/store_details_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// instance -> the map that will contain all the registered instances inside get_it
final instance = GetIt.instance;

// app module -> its a module where we put all generic dependencies
Future<void> initAppModule() async {
  // lazySingleton -> it have only one instance we call it when we need.
  // lazy -> to initialize it when we calling it.

  final sharedPrefs = await SharedPreferences.getInstance();
  // shared preferences instance
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // app preferences instance
  instance
      .registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));
  // network info instance
  instance.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(
      InternetConnectionChecker())); // DataConnectionChecker doesn't need any dependencies

  // dio factory instance
  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));

  // app service client instance
  // to get dio from getDio() function
  final dio = await instance<DioFactory>().getDio();
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  // remote data source instance
  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImplementer(instance()));

  // local data source instance
  instance.registerLazySingleton<LocalDataSource>(
      () => LocalDataSourceImplementer());

  // repository instance
  instance.registerLazySingleton<Repository>(
      () => RepositoryImpl(instance(), instance(), instance()));
}

// login module -> its a module where we put login dependencies
initLoginModule() {
  // check if at least one of those instances haven't registered to register it
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    // factory -> everytime we call it, it create a new instance.
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
    instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance()));
  }
}

// forgot-password module -> its a module where we put forgot-password dependencies
initForgotPasswordModule() {
  if (!GetIt.I.isRegistered<ForgotPasswordUseCase>()) {
    // factory -> everytime we call it, it create a new instance.
    instance.registerFactory<ForgotPasswordUseCase>(
        () => ForgotPasswordUseCase(instance()));
    instance.registerFactory<ForgotPasswordViewModel>(
        () => ForgotPasswordViewModel(instance()));
  }
}

// register module -> its a module where we put register dependencies
initRegisterModule() {
  if (!GetIt.I.isRegistered<RegisterUseCase>()) {
    instance
        .registerFactory<RegisterUseCase>(() => RegisterUseCase(instance()));
    instance.registerFactory<RegisterViewModel>(
        () => RegisterViewModel(instance()));
    instance.registerFactory<ImagePicker>(() => ImagePicker());
  }
}

// home module -> its a module where we put home dependencies
initHomeModule() {
  if (!GetIt.I.isRegistered<HomeUseCase>()) {
    instance.registerFactory<HomeUseCase>(() => HomeUseCase(instance()));
    instance.registerFactory<HomeViewModel>(() => HomeViewModel(instance()));
  }
}

// store details module -> its a module where we put store details dependencies
initStoreDetailsModule() {
  if (!GetIt.I.isRegistered<StoreDetailsUseCase>()) {
    instance.registerFactory<StoreDetailsUseCase>(
        () => StoreDetailsUseCase(instance()));
    instance.registerFactory<StoreDetailsViewModel>(
        () => StoreDetailsViewModel(instance()));
  }
}

resetAllModules() {
  instance.reset(dispose: false);
  // to re initialize dio to get token everytime changes not first time only.
  initAppModule();
  initLoginModule();
  initRegisterModule();
  initRegisterModule();
  initHomeModule();
  initStoreDetailsModule();
}
