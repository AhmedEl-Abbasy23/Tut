import 'dart:async';

import 'package:flutter_advanced/app/functions.dart';
import 'package:flutter_advanced/domain/usecase/login_usecase.dart';
import 'package:flutter_advanced/presentation/base/baseviewmodel.dart';
import 'package:flutter_advanced/presentation/common/freezed_data_classes.dart';
import 'package:flutter_advanced/presentation/common/state_renderer/state_render_impl.dart';
import 'package:flutter_advanced/presentation/common/state_renderer/state_renderer.dart';

class LoginViewModel extends BaseViewModel
    with LoginViewModelInputs, LoginViewModelOutputs {
  // broadcast to enable this stream have more subscribers can listen to the values.
  // use 3 streams to sink and stream 3 values
  final StreamController _emailStreamController =
      StreamController<String>.broadcast();
  final StreamController _passwordStreamController =
      StreamController<String>.broadcast();
  final StreamController _isAllInputsValidStreamController =
      StreamController<void>.broadcast();
  final StreamController isUserLoggedInSuccessfullyStreamController = StreamController<String>();

  // data-class object -> may be user will change the data that he entered again.
  // will store the entered data in it, to use it in login method.
  var loginObject = LoginObject('', '');

  final LoginUseCase _loginUseCase;

  LoginViewModel(this._loginUseCase);

  // inputs
  @override
  void dispose() {
    _emailStreamController.close();
    _passwordStreamController.close();
    _isAllInputsValidStreamController.close();
    isUserLoggedInSuccessfullyStreamController.close();
  }

  @override
  void start() {
    // view orders state renderer to show the content of screen.
    inputState.add(ContentState());
  }

  @override
  setPassword(String password) {
    inputPassword.add(password);
    // data class operation same as kotlin
    // update login object every time the user update the password
    loginObject = loginObject.copyWith(password: password);
    // validate after user input
    _validate();
  }

  @override
  setEmail(String email) {
    inputEmail.add(email);
    // data class operation same as kotlin
    // update login object every time the user update the username
    loginObject = loginObject.copyWith(email: email);
    // validate after user input
    _validate();
  }

  @override
  login() async {
    // setting the state of the state rendering to be loading. (show loading popup)
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _loginUseCase.execute(
            LoginUseCaseInput(loginObject.email, loginObject.password)))
        .fold(
            // left -> failure
            (failure) => {
                  // setting the state of the state rendering to be error. (show error popup)
                  inputState.add(ErrorState(
                      StateRendererType.popupErrorState, failure.message))
                },
            // right -> success (data)
            (data) {
                  // setting the state of the state rendering to be content. (show content screen)
                  inputState.add(ContentState());
                  // navigate to main screen after the login
              isUserLoggedInSuccessfullyStreamController.add("ABCDEFG"); // fake token
                });
  }

  @override
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  Sink get inputEmail => _emailStreamController.sink;

  @override
  Sink get inputIsAllInputsValid => _isAllInputsValidStreamController.sink;

  // outputs
  @override
  Stream<bool> get outputIsPasswordValid => _passwordStreamController.stream
      .map((password) => _isPasswordValid(password));

  @override
  Stream<bool> get outputIsEmailValid => _emailStreamController.stream
      .map((email) => isEmailValid(email));

  @override
  Stream<bool> get outputIsAllInputsValid =>
      _isAllInputsValidStreamController.stream.map((_) => _isAllInputsValid());

  // private functions

  bool _isPasswordValid(String password) {
    return password.isNotEmpty && password.length >= 6;
  }

  bool _isAllInputsValid() {
    return isEmailValid(loginObject.email) &&
        _isPasswordValid(loginObject.password);
  }

  _validate() {
    // no data should pass inside the sink (void)
    inputIsAllInputsValid.add(null);
  }
}

abstract class LoginViewModelInputs {
  // three functions for actions
  setEmail(String email);

  setPassword(String password);

  login();

  // three sinks for streams
  Sink get inputEmail;

  Sink get inputPassword;

  Sink get inputIsAllInputsValid;
}

abstract class LoginViewModelOutputs {
  Stream<bool> get outputIsEmailValid;

  Stream<bool> get outputIsPasswordValid;

  Stream<bool> get outputIsAllInputsValid;
}
