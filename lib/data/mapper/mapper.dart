import 'package:flutter_advanced/app/constant.dart';
import 'package:flutter_advanced/app/extensions.dart';
import 'package:flutter_advanced/data/responses/responses.dart';
import 'package:flutter_advanced/domain/models/model.dart';

// to convert the response into a non-nullable object (model)
// converting data from our response class to the model class into a non-nullable objects
// using our extension which inside app layer and our mapper file

// Authentication & Register mappers
extension CustomerResponseMapper on CustomerResponse? {
  Customer toDomain() {
    return Customer(
      this?.id?.orEmpty() ?? Constant.empty,
      this?.name?.orEmpty() ?? Constant.empty,
      this?.numberOfNotifications?.orZero() ?? Constant.zero,
    );
  }
}

extension ContactsResponseMapper on ContactsResponse? {
  Contacts toDomain() {
    return Contacts(
      this?.phone?.orEmpty() ?? Constant.empty,
      this?.link?.orEmpty() ?? Constant.empty,
      this?.email?.orEmpty() ?? Constant.empty,
    );
  }
}

// it is not a data type
extension AuthenticationResponseMapper on AuthenticationResponse? {
  Authentication toDomain() {
    return Authentication(
      this?.customer?.toDomain(),
      this?.contacts?.toDomain(),
    );
  }
}

// Forgot password mapper
extension ForgotPasswordResponseMapper on ForgotPasswordResponse? {
  ForgotPassword toDomain() {
    return ForgotPassword(
      this?.support?.orEmpty() ?? Constant.empty,
    );
  }
}

// Home mapper

extension BannerResponseMapper on BannerResponse? {
  BannerAd toDomain() {
    return BannerAd(
      this?.id?.orZero() ?? Constant.zero,
      this?.link?.orEmpty() ?? Constant.empty,
      this?.title?.orEmpty() ?? Constant.empty,
      this?.image?.orEmpty() ?? Constant.empty,
    );
  }
}

extension ServiceResponseMapper on ServiceResponse? {
  Service toDomain() {
    return Service(
      this?.id?.orZero() ?? Constant.zero,
      this?.title?.orEmpty() ?? Constant.empty,
      this?.image?.orEmpty() ?? Constant.empty,
    );
  }
}

extension StoreResponseMapper on StoreResponse? {
  Store toDomain() {
    return Store(
      this?.id?.orZero() ?? Constant.zero,
      this?.title?.orEmpty() ?? Constant.empty,
      this?.image?.orEmpty() ?? Constant.empty,
    );
  }
}

extension HomeResponseMapper on HomeResponse? {
  Home toDomain() {
    // mapping banners & adding it inside list<BannerAd>[].
    List<BannerAd> mappedBanners =
        (this?.data?.banners?.map((banner) => banner.toDomain()) ??
                const Iterable.empty())
            .cast<BannerAd>()
            .toList();
    // mapping services & adding it inside list<Service>[].
    List<Service> mappedServices =
        (this?.data?.services?.map((service) => service.toDomain()) ??
                const Iterable.empty())
            .cast<Service>()
            .toList();
    // mapping store & adding it inside list<Store>[].
    List<Store> mappedStores =
        (this?.data?.stores?.map((store) => store.toDomain()) ??
                const Iterable.empty())
            .cast<Store>()
            .toList();
    // adding the mapped lists to our home_page model to map it.
    var data = HomeData(mappedBanners, mappedServices, mappedStores);
    return Home(data);
  }
}

// Store Details mapper

extension StoreDeatailsResponseMapper on StoreDetailsResponse? {
  StoreDetails toDomain() {
    return StoreDetails(
      this?.image?.orEmpty() ?? Constant.empty,
      this?.id?.orZero() ?? Constant.zero,
      this?.title?.orEmpty() ?? Constant.empty,
      this?.details?.orEmpty() ?? Constant.empty,
      this?.services?.orEmpty() ?? Constant.empty,
      this?.about?.orEmpty() ?? Constant.empty,
    );
  }
}


