import 'dart:async';
import 'dart:ffi';

import 'package:flutter_advanced/domain/models/model.dart';
import 'package:flutter_advanced/domain/usecase/store_details_usecase.dart';
import 'package:flutter_advanced/presentation/base/baseviewmodel.dart';
import 'package:flutter_advanced/presentation/common/state_renderer/state_render_impl.dart';
import 'package:flutter_advanced/presentation/common/state_renderer/state_renderer.dart';
import 'package:rxdart/rxdart.dart';

class StoreDetailsViewModel extends BaseViewModel
    with StoreDetailsViewModelInputs, StoreDetailsViewModelOutputs {
  final StreamController _dataStreamController =
      BehaviorSubject<StoreDetails>();

  final StoreDetailsUseCase _storeDetailsUseCase;

  StoreDetailsViewModel(this._storeDetailsUseCase);

  // inputs
  @override
  void start() {
    _getStoreDetailsData();
  }

  _getStoreDetailsData() async {
    // to show fullScreenLoading while getting home data.
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState));
    (await _storeDetailsUseCase.execute(Void)).fold((failure) {
      inputState.add(
          ErrorState(StateRendererType.fullScreenErrorState, failure.message));
    }, (data) {
      inputState.add(ContentState());
      // sinking input after getting storeDetails data.
      inputStoreDetails.add(data);
    });
  }

  @override
  Sink get inputStoreDetails => _dataStreamController.sink;

  // outputs
  @override
  void dispose() {
    _dataStreamController.close();
    super.dispose();
  }

  @override
  Stream<StoreDetails> get outputStoreDetails =>
      _dataStreamController.stream.map((storeDetailsData) => storeDetailsData);
}

abstract class StoreDetailsViewModelInputs {
  Sink get inputStoreDetails;
}

abstract class StoreDetailsViewModelOutputs {
  Stream<StoreDetails> get outputStoreDetails;
}
