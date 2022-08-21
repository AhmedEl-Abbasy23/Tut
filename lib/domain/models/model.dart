// we make non-nullable variables because we do not need to pass any nullable variables
// or objects to our view code
// OnBoarding models
class SliderObject {
  String title;
  String subTitle;
  String image;

  SliderObject(this.title, this.subTitle, this.image);
}

// General models
class DeviceInfo {
  String name;
  String identifier;
  String version;

  DeviceInfo(this.name, this.identifier, this.version);
}

// Login models
class Customer {
  String id;
  String name;
  int numberOfNotifications;

  Customer(this.id, this.name, this.numberOfNotifications);
}

class Contacts {
  String phone;
  String link;
  String email;

  Contacts(this.phone, this.link, this.email);
}

// but here we can make nullable variables
class Authentication {
  Customer? customer;
  Contacts? contacts;

  Authentication(this.customer, this.contacts);
}

// Forgot-password model
class ForgotPassword {
  String support;

  ForgotPassword(this.support);
}

// Home models
class BannerAd {
  int id;
  String link;
  String title;
  String image;

  BannerAd(this.id, this.link, this.title, this.image);
}

class Service {
  int id;
  String title;
  String image;

  Service(this.id, this.title, this.image);
}

class Store {
  int id;
  String title;
  String image;

  Store(this.id, this.title, this.image);
}

class HomeData {
  List<BannerAd> banners;
  List<Service> services;
  List<Store> stores;

  HomeData(this.banners, this.services, this.stores);
}

class Home {
  HomeData? data;

  Home(this.data);
}

// Store Details model
class StoreDetails {
  String image;
  int id;
  String title;
  String details;
  String services;
  String about;

  StoreDetails(
    this.image,
    this.id,
    this.title,
    this.details,
    this.services,
    this.about,
  );
}
