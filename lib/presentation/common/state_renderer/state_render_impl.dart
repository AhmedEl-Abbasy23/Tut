import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced/app/constant.dart';
import 'package:flutter_advanced/presentation/common/state_renderer/state_renderer.dart';
import 'package:flutter_advanced/presentation/resources/strings_manager.dart';

// FlowState -> communicate with view and state-renderer class. (Flow of states)
abstract class FlowState {
  StateRendererType getStateRendererType();

  String getMessage();
}

// Loading state (POPUP, FULL SCREEN)
class LoadingState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  LoadingState({required this.stateRendererType, String? message})
      : message = message ?? AppStrings.loading.tr();

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

// Error state (POPUP, FULL SCREEN)
class ErrorState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  ErrorState(this.stateRendererType, this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

// Success state (POPUP)
class SuccessState extends FlowState {
  String message;

  SuccessState(this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.popupSuccessState;
}

// Content state -- to show the content UI of the screen
class ContentState extends FlowState {
  ContentState();

  @override
  String getMessage() => Constant.empty;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.contentScreenState;
}

// Empty state -- to show empty screen
class EmptyState extends FlowState {
  String message;

  EmptyState(this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.emptyScreenState;
}

// connect FlowState with StateRenderer
extension FlowStateExtension on FlowState {
  Widget getScreenWidget(
    BuildContext context,
    Widget contentScreenWidget, // screen UI
    Function retryActionFunction, // in error states
  ) {
    // (runtimeType) to get the correct & current type
    switch (runtimeType) {
      case LoadingState:
        {
          // popup state
          if (getStateRendererType() == StateRendererType.popupLoadingState) {
            // Showing two layers
            // 2- showing popup dialog
            showPopUp(context, getStateRendererType(), getMessage());
            // 1-return the content UI of the screen
            return contentScreenWidget;
          } else {
            // full screen state
            return StateRenderer(
              stateRendererType: getStateRendererType(),
              message: getMessage(),
              retryActionFunction: retryActionFunction,
            );
          }
        }
      case ErrorState:
        {
          dismissDialog(context);
          // popup state
          if (getStateRendererType() == StateRendererType.popupErrorState) {
            // Showing two layers
            // 2- showing popup dialog
            showPopUp(context, getStateRendererType(), getMessage());
            // 1- return the content UI of the screen
            return contentScreenWidget;
          } else {
            // full screen state
            return StateRenderer(
              stateRendererType: getStateRendererType(),
              message: getMessage(),
              retryActionFunction: retryActionFunction,
            );
          }
        }
      case SuccessState:
        dismissDialog(context);

        showPopUp(
          context,
          getStateRendererType(),
          getMessage(),
          title: AppStrings.success,
        );
        return contentScreenWidget;
      case ContentState:
        {
          dismissDialog(context);
          return contentScreenWidget;
        }
      case EmptyState:
        {
          return StateRenderer(
            stateRendererType: getStateRendererType(),
            message: getMessage(),
            retryActionFunction: () {}, // isn't needed
          );
        }
      default:
        {
          dismissDialog(context);
          return contentScreenWidget;
        }
    }
  }

  showPopUp(
      BuildContext context, StateRendererType stateRendererType, String message,
      {String title = Constant.empty}) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => showDialog(
        context: context,
        builder: (BuildContext context) => StateRenderer(
          stateRendererType: stateRendererType,
          message: message,
          title: title,
          retryActionFunction: () {},
        ),
      ),
    );
  }

  // to check if there are many dialogs are showing in the same time.
  _isThereCurrentDialogShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;

  // to dismiss the current dialog before showing another dialog.
  dismissDialog(BuildContext context) {
    if (_isThereCurrentDialogShowing(context)) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }
}
