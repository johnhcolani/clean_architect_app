import 'dart:async';

import 'package:clean_architect_app/domain/usecase/login_usecase.dart';
import 'package:clean_architect_app/presentation/base/base_viewModel.dart';

import '../common/freezed_data_classes.dart';

class LoginViewModel extends BaseViewModel
    with LoginViewModelInputs, LoginViewModelOutputs {
  StreamController _usernameStreamController =
      StreamController<String>.broadcast();
  StreamController _passwordStreamController =
      StreamController<String>.broadcast();
  StreamController _isAllInputValidStreamController = StreamController<void>.broadcast();

  var loginObject = LoginObject("", "");

  LoginUseCase? _loginUseCase;  //todo remove ?
  LoginViewModel(this._loginUseCase); //inputs

  @override
  void dispose() {
    _usernameStreamController.close();
    _isAllInputValidStreamController.close();
    _passwordStreamController.close();
  }

  @override
  void start() {
    // TODO: implement start
  }

  @override
  Sink get inputPassword => _passwordStreamController.sink;
  @override
  // TODO: implement inputIsAllInputValid
  Sink get inputIsAllInputValid => _isAllInputValidStreamController.sink;

  @override
  Sink get inputUserName => _usernameStreamController.sink;

  @override
  login() async {
    // (await _loginUseCase.execute(
    //         LoginUseCaseInput(loginObject.username, loginObject.password)))
    //     .fold((failure) => {
    //       // left -> failure
    //      print(failure.message)
    // }, (data) => {
    //       // right -> success(data)
    //   print(data.customer?.name)
    // });
  }

  @override
  setPassword(String password) {
    inputPassword.add(password);
    loginObject = loginObject.copyWith(
        password: password);//data class operation same as kotlin
    _validate();
  }

  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    loginObject = loginObject.copyWith(
        username: userName);//data class operation same as kotlin
    _validate();
  }

  // outputs

  @override
  Stream<bool> get outputIsPasswordValid => _passwordStreamController.stream
      .map((password) => _isPasswordValid(password));

  @override
  Stream<bool> get outputIsUserNameValid => _usernameStreamController.stream
      .map((userName) => _isUserNameValid(userName));
  @override
  Stream<bool> get outputIsAllInputsValid => _isAllInputValidStreamController.stream.map((_) => _isAllInputsValid());

  //private function
  _validate(){
    inputIsAllInputValid.add(null);
  }

  bool _isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  bool _isUserNameValid(String userName) {
    return userName.isNotEmpty;
  }
  bool _isAllInputsValid(){
 return _isPasswordValid(loginObject.password)&& _isUserNameValid(loginObject.username);
  }

}

abstract class LoginViewModelInputs {
  // three functions for actions
  setUserName(String userName);

  setPassword(String password);

  login();

  // two sinks for streams
  Sink get inputUserName;

  Sink get inputPassword;

  Sink get inputIsAllInputValid;
}

abstract class LoginViewModelOutputs {
  Stream<bool> get outputIsUserNameValid;
  Stream<bool> get outputIsPasswordValid;
  Stream<bool> get outputIsAllInputsValid;
}
