import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced/app/functions.dart';
import 'package:flutter_advanced/domain/models/model.dart';
import 'package:flutter_advanced/presentation/base/baseviewmodel.dart';
import 'package:flutter_advanced/presentation/resources/assets_manager.dart';
import 'package:flutter_advanced/presentation/resources/strings_manager.dart';

class OnBoardingViewModel extends BaseViewModel
    with OnBoardingViewModelInputs, OnBoardingViewModelOutputs {
  // stream controller -> enables view-model to communicate with view.
  final StreamController _streamController =
      StreamController<SliderViewObject>();

  late final List<SliderObject> _list;
  int _currentIndex = 0;

  // inputs
  @override
  void start() {
    _list = _getSliderObject();
    // send this slider data to our view
    _postDataToView();
  }

  @override
  void dispose() {
    _streamController.close();
  }

  @override
  int goNextPage() {
    // greater than currentPageIndex (will increment 1)
    int nextIndex = _currentIndex++;
    // if the next index will be greater than _list length
    if (nextIndex >= _list.length) {
      _currentIndex = 0;
      // to start again for the first item in our list
    }
    return _currentIndex;
  }

  @override
  int goPreviousPage() {
    // less than currentPageIndex (will decrement 1)
    int previousIndex = _currentIndex--;
    // if the previous index will be less than 0
    if (previousIndex == -1) {
      // infinite loop to go to the length of slider list
      _currentIndex = _list.length - 1;
      // to back again for the latest item in our list
    }
    return _currentIndex;
  }

  @override
  void onPageChanged(int index) {
    _currentIndex = index;
    // to update the ui of the view with the new index
    _postDataToView();
  }

  @override
  void skip(BuildContext context, String routeName) {
    navigateAndReplacement(context, routeName);
  }

  @override
  Sink get inputSliderViewObject => _streamController.sink;

  // outputs
  @override
  Stream<SliderViewObject> get outputSliderViewObject =>
      _streamController.stream.map((sliderViewObject) => sliderViewObject);

  // private functions

  List<SliderObject> _getSliderObject() => [
        SliderObject(
          AppStrings.onBoardingTitle1.tr(),
          AppStrings.onBoardingSubTitle1.tr(),
          ImageAssets.onBoardingLogo1,
        ),
        SliderObject(
          AppStrings.onBoardingTitle2.tr(),
          AppStrings.onBoardingSubTitle2.tr(),
          ImageAssets.onBoardingLogo2,
        ),
        SliderObject(
          AppStrings.onBoardingTitle3.tr(),
          AppStrings.onBoardingSubTitle3.tr(),
          ImageAssets.onBoardingLogo3,
        ),
        SliderObject(
          AppStrings.onBoardingTitle4.tr(),
          AppStrings.onBoardingSubTitle4.tr(),
          ImageAssets.onBoardingLogo4,
        ),
      ];

  _postDataToView() {
    // to store the data inside our stream controller's sink
    inputSliderViewObject.add(
        SliderViewObject(_list[_currentIndex], _list.length, _currentIndex));
  }
}

// inputs mean the orders that our view model will receive from our view
abstract class OnBoardingViewModelInputs {
  void goNextPage(); // when user clicks on right arrow or swipe left.
  void goPreviousPage(); // when user clicks on left arrow or swipe right.
  void onPageChanged(int index);
  void skip(BuildContext context, String routeName);

  Sink
      get inputSliderViewObject; // this is the way to add data to the stream .. stream input
}

// outputs mean data or results that will be sent from our view model to our view
abstract class OnBoardingViewModelOutputs {
  Stream<SliderViewObject> get outputSliderViewObject;
}

class SliderViewObject {
  SliderObject sliderObject;
  int numOfSlides; // length
  int currentIndex;

  SliderViewObject(this.sliderObject, this.numOfSlides, this.currentIndex);
}
