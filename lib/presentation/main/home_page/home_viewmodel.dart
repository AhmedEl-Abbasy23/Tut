import 'dart:async';
import 'dart:ffi';
import 'package:flutter_advanced/domain/models/model.dart';
import 'package:flutter_advanced/domain/usecase/home_usecase.dart';
import 'package:flutter_advanced/presentation/base/baseviewmodel.dart';
import 'package:flutter_advanced/presentation/common/state_renderer/state_render_impl.dart';
import 'package:flutter_advanced/presentation/common/state_renderer/state_renderer.dart';
import 'package:rxdart/rxdart.dart';

class HomeViewModel extends BaseViewModel
    with HomeViewModelInputs, HomeViewModelOutputs {
  // BehaviorSubject from (rxdart) same as StreamController.broadcast().
  final StreamController _dataStreamController =
      BehaviorSubject<HomeViewObject>();

  final HomeUseCase _homeUseCase;

  HomeViewModel(this._homeUseCase);

  // inputs
  @override
  void start() {
    _getHome();
  }

  _getHome() async {
    // to show fullScreenLoading while getting home data.
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState));
    (await _homeUseCase.execute(Void)).fold((failure) {
      inputState.add(
          ErrorState(StateRendererType.fullScreenErrorState, failure.message));
    }, (home) {
      inputState.add(ContentState());
      // sinking input after getting home data.
      inputHomeData.add(HomeViewObject(home.data!.banners, home.data!.services, home.data!.stores));
    });
  }

  @override
  Sink get inputHomeData => _dataStreamController.sink;

  // outputs
  @override
  void dispose() {
    _dataStreamController.close();
    super.dispose();
  }

  @override
  Stream<HomeViewObject> get outputHomeData =>
      _dataStreamController.stream.map((data) => data);
}

abstract class HomeViewModelInputs {
  Sink get inputHomeData;
}

abstract class HomeViewModelOutputs {
  Stream<HomeViewObject> get outputHomeData;
}


class HomeViewObject {
  List<BannerAd> banners;
  List<Service> services;
  List<Store> stores;

  HomeViewObject(this.banners, this.services, this.stores);
}