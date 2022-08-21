import 'dart:async';

import 'package:flutter_advanced/app/functions.dart';
import 'package:flutter_advanced/domain/usecase/forgot_password_usecase.dart';
import 'package:flutter_advanced/presentation/base/baseviewmodel.dart';
import 'package:flutter_advanced/presentation/common/freezed_data_classes.dart';
import 'package:flutter_advanced/presentation/common/state_renderer/state_render_impl.dart';
import 'package:flutter_advanced/presentation/common/state_renderer/state_renderer.dart';

class ForgotPasswordViewModel extends BaseViewModel
    with ForgotPasswordViewModelInputs, ForgotPasswordViewModelOutputs {
  final StreamController _emailStreamController =
      StreamController<String>.broadcast();
  final StreamController _isEmailValidStreamController = StreamController<void>.broadcast();
  final StreamController isUserResetPasswordSuccessfullyStreamController = StreamController<bool>();

  var forgotPasswordObject = ForgotPasswordObject('');
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordViewModel(this._forgotPasswordUseCase);

  // inputs
  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    _emailStreamController.close();
    _isEmailValidStreamController.close();
    super.dispose();
  }

  @override
  setEmail(String email) {
    inputEmail.add(email);
    forgotPasswordObject = forgotPasswordObject.copyWith(email: email);
    // to sink (inputIsEmailValid)
    _validate();
  }

  @override
  forgotPassword() async {
    // setting the state of the state rendering to be loading. (show loading popup)
    inputState.add(LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _forgotPasswordUseCase.execute(ForgotPasswordUseCaseInput(forgotPasswordObject.email))).fold(
      // left -> failure
            (failure) => {
          // setting the state of the state rendering to be error. (show error popup)
          inputState.add(ErrorState(StateRendererType.popupErrorState, failure.message))
        },
        // right -> success (data)
            (data) {
          // setting the state of the state rendering to be content. (show content screen)
              inputState.add(SuccessState(data.support));
          // navigate to login screen after reset password
          isUserResetPasswordSuccessfullyStreamController.add(true);
            });
  }

  @override
  Sink get inputEmail => _emailStreamController.sink;

  @override
  Sink get inputIsEmailValid => _isEmailValidStreamController.sink;

  // outputs

  @override
  Stream<bool> get outputIsEmailValid =>
      _isEmailValidStreamController.stream.map((_) => _isInputEmailValid());

  // private functions
  bool _isInputEmailValid() {
    return isEmailValid(forgotPasswordObject.email);
  }

  _validate() {
    // no data should pass inside the sink (void)
    inputIsEmailValid.add(null);
  }
}

abstract class ForgotPasswordViewModelInputs {
  setEmail(String email);

  forgotPassword();

  Sink get inputEmail;

  Sink get inputIsEmailValid;
}

abstract class ForgotPasswordViewModelOutputs {
  Stream<bool> get outputIsEmailValid;
}
