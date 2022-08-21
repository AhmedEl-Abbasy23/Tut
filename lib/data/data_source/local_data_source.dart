import 'package:flutter_advanced/data/network/error_handler.dart';
import 'package:flutter_advanced/data/responses/responses.dart';

const cacheHomeKey = "Cache_Home_Key";
const cacheStoreDetailsKey = "Cache_Store_Details_Key";
const cacheInterval = 60 * 1000; // 1 minute cache in milli-second.
// (Interval) -> the maximum time of using the cachedData.

abstract class LocalDataSource {
  Future<HomeResponse> getHome();

  // to cache home response data into CachedItem.
  Future<void> saveHomeToCache(HomeResponse homeResponse);

  Future<StoreDetailsResponse> getStoreDetails();

  // to cache home response data into CachedItem.
  Future<void> saveStoreDetailsToCache(StoreDetailsResponse storeDetailsResponse);

  // to clear cache when user logout.
  void clearCache();

  // to remove specific element from cache when use make changes.
  void removeFromCache(String key);
}

class LocalDataSourceImplementer implements LocalDataSource {
  // (run time cache) type
  Map<String, CachedItem> cachedMap = Map();

  @override
  Future<HomeResponse> getHome() async {
    // retrieve the cachedItem from cachedMap.
    // null-able -> maybe null at the first time, As we haven't save any data.
    CachedItem? cachedItem = cachedMap[cacheHomeKey];

    if (cachedItem != null && cachedItem.isValid(cacheInterval)) {
      // return the response from home cache.
      return cachedItem.data; // look like the home response from API.
    } else {
      // return an error that cache isn't exists or its not valid.
      // (its not valid) -> cache time out.
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
      // throw this error to (try & catch) which inside repositoryImplementer methods.
    }
  }

  @override
  Future<void> saveHomeToCache(HomeResponse homeResponse) async {
    // use{cacheHomeKey} to retrieve the value of home response.
    cachedMap[cacheHomeKey] = CachedItem(homeResponse);
  }

  @override
  void clearCache() {
    cachedMap.clear();
  }

  @override
  void removeFromCache(String key) {
    cachedMap.remove(key);
  }

  @override
  Future<StoreDetailsResponse> getStoreDetails() async {
    CachedItem? cachedItem = cachedMap[cacheStoreDetailsKey];

    if (cachedItem != null && cachedItem.isValid(cacheInterval)) {
      // return the response from store details cache.
      return cachedItem.data;
    } else {
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    }
  }

  @override
  Future<void> saveStoreDetailsToCache(StoreDetailsResponse storeDetailsResponse) async{
    cachedMap[cacheStoreDetailsKey] = CachedItem(storeDetailsResponse);
  }
}

class CachedItem {
  // to receive any type of data.
  dynamic data;

  // to save the initial caching time.
  int cacheTime = DateTime.now().millisecondsSinceEpoch;

  CachedItem(this.data);
}

extension CachedItemExtension on CachedItem {
  // (expirationTimeInMilliSec) -> the maximum time of using the cachedData.
  bool isValid(int expirationTimeInMilliSec) {
    // current time of checking the validation of cachedData.
    int currentTimeInMilliSec = DateTime.now().millisecondsSinceEpoch;

    // (cacheTime) -> the initial caching time.
    // to check if(time is out or not), to set (isValid) value.
    bool isValid = currentTimeInMilliSec - cacheTime < expirationTimeInMilliSec;
    return isValid;
  }
}
